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

        -- -- Auto-restart C# language server when opening a .NET project / Auto-restart when csproj, sln, slnx files change
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            pattern = { "*.csproj", "*.sln", "*.slnx" },
            callback = function()
                vim.defer_fn(function()
                    vim.cmd("CocCommand dotnet.restartServer")
                end, 500)
            end,
        })
    end,
}
