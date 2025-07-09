-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_command("set wrap")
vim.api.nvim_command("set relativenumber")

vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 1

vim.opt.scrolloff = 0
vim.opt.concealcursor = "nc"
vim.opt.spell = false
vim.lsp.inlay_hint.enable(false)
vim.opt.conceallevel = 0
vim.g.snacks_animate = false
-- vim.g.root_spec = { "cwd" }
vim.o.grepprg = "rg --vimgrep --smart-case --follow"
vim.opt.formatoptions:remove({
  -- "c", -- auto-wrap comments
  -- "r", -- auto-insert comment leader after `o` and `O` (allegedly?)
  "o", -- auto-insert comment leader after <ENTER>
})
-- vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"

vim.g.minipairs_disable = true
vim.opt.spell = false -- Disable spell checking globally
vim.opt.spelllang = {} -- Clear spell check languages
vim.diagnostic.config({ virtual_text = false })
