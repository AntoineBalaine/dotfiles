-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.api.nvim_set_keymap("n", "<C-PageUp>", ":BufferLineCyclePrev<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":BufferLineCycleNext<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<S-j>", ":join<cr>", { silent = false })

vim.api.nvim_set_keymap("n", ";", ":lua require('dapui').eval()<CR>", { silent = false })
