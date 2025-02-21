return {
    { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { 'echasnovski/mini.nvim', version = '*' },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
--    {
--        "nvim-neo-tree/neo-tree.nvim",
--        branch = "v3.x",
--        dependencies = {
--            "nvim-lua/plenary.nvim",
--            "nvim-tree/nvim-web-devicons", 
--            "MunifTanjim/nui.nvim",
--        }
--    },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
}
