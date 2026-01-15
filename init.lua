require("dusi.vimoptions")
require("dusi")

package.loaded["lspconfig.server_configurations.omnisharp"] = nil
vim.api.nvim_clear_autocmds({ group = "lspconfig", event = "FileType", pattern = "cs" })
