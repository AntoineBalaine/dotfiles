-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("user.helpers")
require("user.lua_adventures")
insert_image = require("user.insert_image").insert_image

vim.cmd("packadd cfilter")
require("nvim-treesitter.configs").setup({
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = {
      -- "c",
      "ruby",
    }, -- optional, list of language that will be disabled
    -- [options]
  },
})

vim.opt.exrc = true
vim.o.secure = true
-- Set explicit paths if needed

-- vim.g.node_host_prog = vim.fn.exepath('neovim-node-host') -- or full path if needed
-- vim.g.python3_host_prog = vim.fn.exepath('python3')       -- or full path if needed
