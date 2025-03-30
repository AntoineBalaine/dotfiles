-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_command("set wrap")
vim.api.nvim_command("set relativenumber")
vim.opt.scrolloff = 0
vim.opt.concealcursor = "nc"
vim.opt.spell = false
vim.lsp.inlay_hint.enable(false)
vim.opt.conceallevel = 0
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "Force conceallevel to always be 0",
})
vim.g.snacks_animate = false
-- vim.g.root_spec = { "cwd" }
vim.o.grepprg = "rg --vimgrep --smart-case --follow"
vim.opt.formatoptions:remove({
  -- "c", -- auto-wrap comments
  -- "r", -- auto-insert comment leader after `o` and `O` (allegedly?)
  "o", -- auto-insert comment leader after <ENTER>
})

-- these stupid plugins that reset this option at every file open…
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

vim.g.minipairs_disable = true
vim.opt.spell = false -- Disable spell checking globally
vim.opt.spelllang = {} -- Clear spell check languages
