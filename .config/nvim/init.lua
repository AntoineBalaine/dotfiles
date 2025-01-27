-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("user.helpers")
require("user.lua_adventures")

vim.cmd("packadd cfilter")
require("nvim-treesitter.configs").setup({
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { "c", "ruby" }, -- optional, list of language that will be disabled
    -- [options]
  },
})
