return {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
        -- coc extensions
        vim.g.coc_global_extensions = {
            "coc-angular",
            "coc-html",
            "coc-css",
            "coc-tsserver",
        }

        -- DISABLE COC'S COMPLETION POPUP (use cmp instead)
        vim.g.coc_start_at_startup = 1
        vim.cmd([[
            autocmd FileType * let b:coc_suggest_disable = 1
        ]])
    end,
}
