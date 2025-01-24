-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("user.removegetters")
require("user.transform_setters")
require("user.helpers")
require("user.lua_adventures")

-- Create a command to call the function
vim.api.nvim_create_user_command("TransformFn", transform_function_declaration, {})
