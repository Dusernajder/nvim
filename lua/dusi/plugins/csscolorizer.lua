return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	config = function()
		require("colorizer").setup({
			user_default_options = {
				user_default_options = {
					mode = "background",

					-- enable named colors
					names = true,
					names_opts = {
						lowercase = true,
						camelcase = true,
					},

					-- enable color functions
					rgb_fn = true,
					hsl_fn = true,

					-- hex support (explicit is better)
					RGB = true,
					RRGGBB = true,
					RRGGBBAA = true,
					AARRGGBB = true,
				},

				filetypes = {
					css = {},
					javascript = {},
					html = { mode = "foreground" },
				},
			},
		})
	end,
}
