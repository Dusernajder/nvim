return {
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
				ensure_installed = { "lua_ls", "csharp_ls", "ts_ls", "pyright", "html" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
			lspconfig.csharp_ls.setup({
				cmd = { vim.fn.stdpath("data") .. "/mason/bin/csharp-ls" },
				cmd_env = { DOTNET_ROOT = "/opt/homebrew/opt/dotnet@8/libexec" },
				root_dir = function(fname)
					return util.root_pattern("*.sln")(fname) or util.root_pattern("*.csproj")(fname)
				end,
				filetypes = { "cs" },
				capabilities = capabilities,
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
