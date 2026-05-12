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

        -- Auto-restart C# language server when opening a .NET project
        local csharp_restarted = false
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "CocDiagnosticChange",
            callback = function()
                if not csharp_restarted and vim.bo.filetype == "cs" then
                    vim.defer_fn(function()
                        vim.cmd("CocCommand dotnet.restartServer")
                        csharp_restarted = true
                    end, 500)
                end
            end,
        })
    end,
}
