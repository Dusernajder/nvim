return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "gbprod/none-ls-luacheck.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- Python
                null_ls.builtins.formatting.isort.with({
                    filetypes = { "python" },
                }),

                null_ls.builtins.formatting.black.with({
                    filetypes = { "python" },
                }),

                -- Lua
                null_ls.builtins.formatting.stylua.with({
                    filetypes = { "lua" },
                }),

                -- Web
                null_ls.builtins.formatting.prettier.with({
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                        "json",
                        "yaml",
                        "markdown",
                        "html",
                        "css",
                    },
                }),

                -- C#
                null_ls.builtins.formatting.csharpier.with({
                    filetypes = { "cs" },
                }),

                -- Diagnostics
                require("none-ls.diagnostics.eslint_d"),
            },
        })
    end,
}
