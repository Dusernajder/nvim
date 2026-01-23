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
				ensure_installed = { "lua_ls", "ts_ls", "pyright", "html", "angularls" },
				automatic_enable = {
					exclude = { "OmniSharp", "pyright" },
				},
			})
		end,
	},

	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup({
				hint_enable = false,
				floating_window = true,
				handler_opts = { border = "rounded" },
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

			-- lua
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

			-- Python
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
				settings = {
					python = {
						venvPath = ".",
						venv = ".venv",
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			})

			-- javascript
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			-- Angular
			lspconfig.angularls.setup({
				capabilities = capabilities,

				cmd = {
					"node",
					vim.fn.expand(
						"~/.local/share/nvim/mason/packages/angular-language-server/node_modules/@angular/language-server/index.js"
					),
					"--stdio",
				},

				on_new_config = function(new_config, new_root_dir)
					new_config.cmd = {
						"node",
						vim.fn.expand(
							"~/.local/share/nvim/mason/packages/angular-language-server/node_modules/@angular/language-server/index.js"
						),
						"--stdio",
						"--tsProbeLocations",
						new_root_dir,
						"--ngProbeLocations",
						new_root_dir,
					}
				end,

				root_dir = util.root_pattern(
					"angular.json",
					"project.json", -- Nx
					"nx.json",
					"package.json"
				),

				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
			})

			-- html
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

			vim.filetype.add({
				pattern = {
					[".*%.component%.html"] = "html",
				},
			})

			-- C
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = { "clangd", "--background-index", "--clang-tidy", "--log=error" },
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
			})

			package.loaded["lspconfig.server_configurations.omnisharp"] = nil
			vim.api.nvim_clear_autocmds({
				group = "lspconfig",
				event = "FileType",
				pattern = "cs",
			})

			-- C#
			lspconfig.omnisharp.setup({
				cmd = {
					vim.fn.expand("~/.local/share/nvim/mason/bin/omnisharp"),
					"--languageserver",
					"--hostPID",
					vim.fn.getpid(),
				},
				capabilities = capabilities,
				root_dir = function()
					return util.root_pattern("*.sln")(fname) or util.root_pattern("*.csproj")(fname)
				end,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
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

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					spacing = 4,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
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

					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)
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
