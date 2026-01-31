return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "python",      -- debugpy
                    "codelldb",    -- C/C++/Rust
                    "coreclr",     -- .NET (netcoredbg)
                    "javadbg",     -- Java
                    "javatest",    -- Java tests
                },
                automatic_installation = true,
            })
        end,
    },
}
