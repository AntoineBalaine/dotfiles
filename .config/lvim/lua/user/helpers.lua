---Function to get the parent node of the current cursor position
function Get_parent_node()
  local cur_node = vim.treesitter.get_node()
  if cur_node == nil then return end
  local parent = cur_node:parent()
  local r = parent.range
  local plugin_name = vim.api.nvim_exec("lua return require('plugin_name')", true)
end

function AddPlugins_toGlobaScope()
  for k, v in ipairs(lvim.plugins) do
    local plug_name = v[1]:match "/(%S*)"
    local plugin_functions = pcall(require, plug_name)
    if (plugin_functions == nil) then return end
    _G.plugin_scopes = {}
    _G.plugin_scopes[plug_name] = plugin_functions
  end

  vim.cmd("new")
  local str = vim.inspect(_G)
  local lines = vim.split(str, '\n', { plain = true })
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

---If you're getting lazy to type `vim.print(vim.inspect(whatever))`, then this is for you.
---print some data to vim's console.
---@param data any
function P(data)
  vim.print(vim.inspect(data))
end

---Copy current file's path to system clipboard.
function cpwd()
  vim.cmd([[ :let @+ = expand("%") ]])
end

Ts_utils = require("nvim-treesitter.ts_utils")
