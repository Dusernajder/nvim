return {
    "d7omdev/nuget.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        -- optional, show dotnet command output through fidget instead of vim.notify
        "j-hui/fidget.nvim",
    },
    config = function()
        local config = require("nuget")
        config.setup({
            keys = {
                install = { "n", "<leader>ni" },
                remove = { "n", "<leader>nr" },
                clear_cache = { "n", "<leader>nc" },
            }
        })
    end,
}
