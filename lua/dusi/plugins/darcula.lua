return {
    "xiantang/darcula-dark.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    priority = 1000,
    config = function()
        require("darcula").setup({
            theme = "darcula",
            opt = {
                integrations = {
                    telescope = false,
                    snacks = true,
                    lualine = true,
                    lsp_semantics_token = true,
                    nvim_cmp = true,
                    dap_nvim = true,
                },
            },
        })
    end,
}
