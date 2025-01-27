-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("user.removegetters")
require("user.transform_setters")
require("user.helpers")
require("user.lua_adventures")

-- Create a command to call the function
vim.api.nvim_create_user_command("TransformFn", transform_function_declaration, {})

vim.cmd("packadd cfilter")
require("nvim-treesitter.configs").setup({
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { "c", "ruby" }, -- optional, list of language that will be disabled
    -- [options]
  },
})
