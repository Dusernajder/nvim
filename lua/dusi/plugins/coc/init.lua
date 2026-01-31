return {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
        vim.g.coc_global_extensions = {
            "coc-json",
        }

        -- Load extensions
        require("dusi.plugins.coc.extensions")

        -- Load keymaps
        require("dusi.plugins.coc.keymaps")
    end,
}
