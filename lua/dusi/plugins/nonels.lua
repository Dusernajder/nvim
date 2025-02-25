return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "gbprod/none-ls-luacheck.nvim"
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.csharpier,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,

                require("none-ls-luacheck.diagnostics.luacheck"),
                require("none-ls.diagnostics.eslint_d"),
            },
        })
    end,
}
