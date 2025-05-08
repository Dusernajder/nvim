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
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>wa<CR>")
vim.keymap.set("n", "<leader>wq", "<cmd>wqa<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")

vim.keymap.set("n", "<leader>n", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>p", "<cmd>bprev<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "L", ":m '<-2<CR>gv=gv")

-- Switching between open panes
vim.keymap.set("n", "<leader>j", "<cmd>winc j<CR>")
vim.keymap.set("n", "<leader>k", "<cmd>winc k<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>winc h<CR>")
vim.keymap.set("n", "<leader>l", "<cmd>winc l<CR>")

vim.keymap.set("n", "<leader>x", "<cmd>close<CR>")

-- Create and close tab
vim.keymap.set("n", "<leader>te", "<cmd>tabedit %<CR>")
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>")

-- Black magic
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>ra", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.keymap.set("n", "<leader>r", function()
	return vim.fn.input("Build: ", vim.fn.getcwd() .. "/", "file")
end)

-- Clang switch between header/source
vim.keymap.set("n", "<leader>i", "<cmd>ClangdSwitchSourceHeader<CR>")
