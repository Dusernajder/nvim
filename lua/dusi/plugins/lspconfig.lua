return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "csharp_ls" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")
            lspconfig.lua_ls.setup({})
            lspconfig.csharp_ls.setup({
                cmd = { vim.fn.stdpath("data") .. "/mason/bin/csharp-ls" },
                cmd_env = { DOTNET_ROOT = "/opt/homebrew/opt/dotnet@8/libexec" },
                root_dir = function(fname)
                    return util.root_pattern '*.sln'(fname) or util.root_pattern '*.csproj'(fname)
                end,
                filetypes = { "cs" },
            })
        end
    }
}
