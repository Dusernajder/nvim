return {
    {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "p00f/clangd_extensions.nvim",
    },

    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = function()
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local ls = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            ls.filetype_extend("typescript", { "tsdoc" })
            ls.filetype_extend("javascript", { "jsdoc" })
            ls.filetype_extend("lua", { "luadoc" })
            ls.filetype_extend("python", { "pydoc" })
            ls.filetype_extend("rust", { "rustdoc" })
            ls.filetype_extend("cs", { "csharpdoc" })
            ls.filetype_extend("java", { "javadoc" })
            ls.filetype_extend("c", { "cdoc" })
            ls.filetype_extend("cpp", { "cppdoc" })
            ls.filetype_extend("php", { "phpdoc" })
            ls.filetype_extend("kotlin", { "kdoc" })
            ls.filetype_extend("ruby", { "rdoc" })
            ls.filetype_extend("sh", { "shelldoc" })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            require("lazydev").setup({
                library = { "nvim-dap-ui" },
            })

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                experimental = {
                    ghost_text = { hl_group = "Comment" },
                },

                window = {
                    completion = {
                        side_padding = 1,
                        border = "rounded",
                    },
                    documentation = {
                        side_padding = 1,
                        border = "rounded",
                    },
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-x>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    -- { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),

                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.recently_used,
                        require("clangd_extensions.cmp_scores"),
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },

                formatting = {
                    format = function(entry, vim_item)
                        -- First apply tailwind colorizer
                        vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

                        -- Then apply lspkind
                        vim_item = lspkind.cmp_format({
                            mode = "symbol_text",
                        })(entry, vim_item)

                        -- Your custom logic
                        if entry.source.name == "nvim_lsp" then
                            if entry.completion_item.additionalTextEdits then
                                vim_item.menu = "[+Import]"
                            end
                        end

                        if entry.source.name == "html-css" then
                            vim_item.menu = "[CSS]"
                        end

                        return vim_item
                    end,
                },
            })

            -- Python-only: trigger import suggestions for symbol under cursor
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "python",
                callback = function()
                    vim.keymap.set("n", "<leader>ii", function()
                        local cmp = require("cmp")
                        local word = vim.fn.expand("<cword>")
                        if word == "" then
                            return
                        end

                        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                        local line = vim.api.nvim_get_current_line()
                        col = col + 1 -- 1-based

                        -- find word boundaries safely
                        local start_col = col
                        while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
                            start_col = start_col - 1
                        end

                        local end_col = col
                        while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
                            end_col = end_col + 1
                        end

                        start_col = start_col - 1
                        end_col = end_col - 1
                        if start_col >= end_col then
                            return
                        end

                        -- rewrite symbol (no visible change, but triggers completion context)
                        vim.api.nvim_buf_set_text(0, row - 1, start_col, row - 1, end_col, { word })

                        -- ENTER INSERT MODE, then trigger cmp
                        vim.api.nvim_feedkeys("a", "n", false)
                        vim.schedule(function()
                            cmp.complete({
                                config = {
                                    sources = {
                                        { name = "nvim_lsp" },
                                    },
                                },
                            })
                        end)
                    end, { buffer = true, desc = "Import symbol under cursor" })
                end,
            })
        end,
    },
}
