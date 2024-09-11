-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_command("set wrap")
vim.api.nvim_command("set relativenumber")
vim.opt.scrolloff = 0
vim.opt.concealcursor = "nc"
vim.opt.spell = false