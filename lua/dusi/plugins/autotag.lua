return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	config = function()
		require("nvim-ts-autotag").setup({
			enable = true,
			enable_rename = true,
			enable_close = true,
			enable_close_on_slash = false,
			filetypes = {
				"html",
				"xml",
				"javascript",
				"typescript",
				"typescriptreact",
				"javascriptreact",
				"angular",
			},
		})
	end,
}
