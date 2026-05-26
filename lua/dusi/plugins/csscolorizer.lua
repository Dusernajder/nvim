return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
        require("colorizer").setup({
            filetypes = {
                "*", -- Enable for all filetypes by default
                css = { rgb_fn = true },
                javascript = { rgb_fn = true },
                html = { mode = "foreground" },
            },
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
                -- hex support
                RGB = true,
                RRGGBB = true,
                RRGGBBAA = true,
                AARRGGBB = true,
            },
        })
    end,
}
