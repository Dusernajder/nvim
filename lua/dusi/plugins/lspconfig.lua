return {
    {
        "RishabhRD/nvim-lsputils",
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "omnisharp", "ts_ls", "pyright", "html" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities.textDocument.completion.completionItem.snippetSupport = true
            -- capabilities.textDocument.completion.completionItem.resolveSupport = {
            --     properties = {
            --         "documentation",
            --         "detail",
            --         "additionalTextEdits",
            --     },
            -- }
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")

            -- misc
            require("dusi.misc.razor")

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if
                            path ~= vim.fn.stdpath("config")
                            and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
                        then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            version = "LuaJIT",
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                            },
                        },
                    })
                end,
                settings = {
                    Lua = {},
                },
            })

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            lspconfig.pyright.setup({
                capabilities = capabilities,
                filetypes = { "python" },
            })

            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                root_dir = function(fname)
                    return util.root_pattern(
                        ".clangd",
                        ".clang-tidy",
                        ".clang-format",
                        "compile_commands.json",
                        "compile_flags.txt",
                        "configure.ac" -- AutoTools
                    )(fname) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
                end,
                options = {
                    IndentWidth = 4,
                },
            })

            lspconfig.omnisharp.setup({
                cmd = { "/usr/local/bin/omnisharp/omnisharp", "--languageserver", "--hostPID", vim.fn.getpid() },
                capabilities = capabilities,
                root_dir = function()
                    return util.root_pattern("*.sln")(fname) or util.root_pattern("*.csproj")(fname)
                end,
                settings = {
                    omnisharp = {
                        useModernNet = true,
                        RoslynExtensionsOptions = {
                            EnableImportCompletion = true,
                            -- EnableAnalyzersSupport = true,
                            AnalyzeOpenDocumentsOnly = false,
                        },
                    },
                },
            })
            lspconfig.html.setup({
                capabilities = function()
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities.textDocument.completion.completionItem.snippetSupport = true
                    return capabilities
                end,
                cmd = { "vscode-html-language-server", "--stdio" },
                filetypes = { "html" },
                init_options = {
                    configurationSection = { "html", "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true,
                    },
                },
                root_dir = function(fname)
                    return root_pattern(fname) or vim.loop.os_homedir()
                end,
                settings = {},
            })

            -- Buffer global keymaps
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
            vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(event)
                    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    local opts = { buffer = event.buf }

                    -- Buffer local mappings
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "<leader>m", function()
                        local params = vim.lsp.util.make_range_params()
                        params.context = { only = { "source.organizeImports" } }

                        -- Try 'textDocument/codeAction' (code actions for LSP)
                        vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx, config)
                            if err or not result or vim.tbl_isempty(result) then
                                -- If no direct import found, try general code actions
                                vim.lsp.buf.code_action()
                                return
                            end

                            -- Select the first import action
                            local edit = result[1].edit
                            if edit then
                                vim.lsp.util.apply_workspace_edit(edit, ctx.client_id .. "")
                            else
                                vim.lsp.buf.execute_command(result[1].command)
                            end
                        end)
                    end, { desc = "Auto-import class or missing library" })
                end,
            })

            -- format file before save
            --
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --     group = vim.api.nvim_create_augroup("AutoFormat", { clear = true })
            --     pattern = "*",
            --     callback = function()
            --         vim.lsp.buf.format { async = false }
            --
            --     end,
            -- })
        end,
    },
}
