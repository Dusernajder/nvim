return {
	"windwp/nvim-ts-autotag",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true, -- auto close tags
				enable_rename = true, -- auto rename pairs
				enable_close_on_slash = false,
			},
		})
	end,
}
