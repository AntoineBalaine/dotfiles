---If you're getting lazy to type `vim.print(vim.inspect(whatever))`, then this is for you.
---print some data to vim's console.
---@param data any
function P(data)
  vim.print(vim.inspect(data))
end

---Copy current file's path to system clipboard.
function cpwd()
  vim.cmd([[ let @+ = expand("%") ]])
end

---@param data string|table
function pipe(data)
  local text = vim.inspect(data)
  local buf_num = vim.api.nvim_create_buf(true, true)
  local split_text = vim.fn.split(text, "\n") ---@cast split_text string[]
  vim.api.nvim_buf_set_text(buf_num, 0, 0, 0, 0, split_text)
  vim.api.nvim_set_current_buf(buf_num)
end

function LSP_format()
  vim.lsp.buf.format()
end
