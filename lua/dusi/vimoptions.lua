-- BASIC SETTINGS --
-- vim.opt.termguicolors = true
--vim.opt.background = "dark"

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamed"
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 10
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('i', 'jj', '<Esc>')

vim.keymap.set('n', '<leader>n', '<cmd>bnext<CR>')
vim.keymap.set('n', '<leader>p', '<cmd>bprev<CR>')

-- Switching between open panes
vim.keymap.set('n', '<leader>j', '<cmd>winc j<CR>')
vim.keymap.set('n', '<leader>k', '<cmd>winc k<CR>')
vim.keymap.set('n', '<leader>h', '<cmd>winc h<CR>')
vim.keymap.set('n', '<leader>l', '<cmd>winc l<CR>')

vim.keymap.set('n', '<leader>c', '<cmd>close<CR>')


-- black magic
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>ra", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


-- Highlight when yanking (copying) text 
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


