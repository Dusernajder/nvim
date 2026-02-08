-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", "<Cmd>CocCommand diagnostics.open<CR>", { desc = "Show diagnostics" })
vim.keymap.set("n", "[d", "<Plug>(coc-diagnostic-prev)", { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", "<Plug>(coc-diagnostic-next)", { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", "<Cmd>CocList diagnostics<CR>", { desc = "Diagnostics list" })

-- LSP function keymaps
vim.keymap.set("n", "gD", "<Plug>(coc-declaration)", { desc = "Go to declaration" })
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { desc = "Go to definition" })
vim.keymap.set("n", "K", "<Cmd>call CocActionAsync('doHover')<CR>", { desc = "Hover documentation" })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { desc = "Go to implementation" })
vim.keymap.set("i", "<C-k>", "<Cmd>call CocActionAsync('showSignatureHelp')<CR>", { desc = "Signature help" })
-- vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })
vim.keymap.set("n", "<leader>D", "<Plug>(coc-type-definition)", { desc = "Type definition" })
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { desc = "Rename symbol" })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { desc = "References" })
vim.keymap.set("n", "<leader>f", "<Cmd>call CocActionAsync('format')<CR>", { desc = "Format" })

-- Code actions
vim.keymap.set("n", "<leader>ca", "<Plug>(coc-codeaction-line)", { desc = "Code action (line)" })
vim.keymap.set("v", "<leader>ca", "<Plug>(coc-codeaction-selected)", { desc = "Code action (selection)" })
vim.keymap.set("n", "<leader>m", "<Plug>(coc-codeaction-source)", { desc = "Source code action (organize imports)" })
vim.keymap.set("n", "<leader>qi", function()
    vim.fn.CocActionAsync("codeAction", "quickfix")
end, { desc = "Quick fix" })


-- Completion keymaps
vim.cmd([[
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
    "inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
    "inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"

    inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
    inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

    inoremap <silent><expr> <C-s> coc#refresh()
]])
