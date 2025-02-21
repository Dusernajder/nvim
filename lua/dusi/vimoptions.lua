-- BASIC SETTINGS --
-- vim.opt.termguicolors = true
vim.opt.background = "dark"

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
