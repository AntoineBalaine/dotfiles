-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.api.nvim_set_keymap("n", "<C-PageUp>", ":BufferLineCyclePrev<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<C-PageDown>", ":BufferLineCycleNext<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<S-j>", ":join<cr>", { silent = false })
vim.api.nvim_set_keymap("n", ";", ":lua require('dapui').eval()<CR>", { silent = false })
vim.keymap.set("i", "<C-h>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("n", "<C-n>", ":cnext<cr>", { silent = false })
vim.api.nvim_set_keymap("n", "<C-p>", ":cprev<cr>", { silent = false })
-- Diagnostic navigation
vim.keymap.set("n", "<F8>", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

vim.keymap.set("n", "<F20>", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

vim.keymap.set({ "n", "v" }, "H", "^", { desc = "First non-blank character of line", noremap = true })

-- When using `dd` in the quickfix list, remove the item from the quickfix list.
function RemoveQFItem()
  local qf_list = vim.fn.getqflist()

  if #qf_list > 0 then
    local curqfidx = vim.fn.line(".") - 1
    table.remove(qf_list, curqfidx + 1) -- Lua tables are 1-indexed
    vim.fn.setqflist(qf_list, "r")

    if #qf_list > 0 then
      vim.cmd(string.format("%dcfirst", curqfidx + 1))
      vim.cmd("copen")
    else
      vim.cmd("cclose")
    end
  end
end

-- Function to remove selected lines from quickfix list
local function remove_qf_items()
  local qf_list = vim.fn.getqflist()

  local line1 = vim.fn.line("v") -- start of visual selection
  local line2 = vim.fn.line(".") -- current line (end of selection)

  print(string.format("line1: %d, line2: %d", line1, line2))

  -- Always remove from higher index to lower index
  local start_line = math.min(line1, line2)
  local end_line = math.max(line1, line2)
  -- Get the current quickfix list
  -- Remove the selected items (accounting for 1-based indexing)
  for i = end_line, start_line, -1 do
    table.remove(qf_list, i)
  end

  -- Update the quickfix list
  vim.fn.setqflist(qf_list, "r")

  -- Refresh the quickfix window
  -- local qf_win = vim.fn.getqflist({ winid = 0 }).winid
  -- if qf_win ~= 0 then
  --   vim.cmd("copen")
  -- end
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    -- Make buffer modifiable
    vim.opt_local.modifiable = true
    -- Set error format to match the quickfix format
    vim.opt_local.errorformat = "%f\\|%l\\ col\\ %c\\|%m"

    -- Now cgetbuffer should work correctly
    -- You can use normal vim commands, and then update with:
  end,
})

-- Set up the keymap for the quickfix window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    -- Map 'd' in visual mode to remove selected items
    vim.keymap.set(
      { "v", "x" },
      "d",
      remove_qf_items,
      { buffer = true, desc = "Remove selected items from quickfix list" }
    )

    -- vim.keymap.set("x", "d", remove_qf_items, { buffer = true, desc = "Remove selected items from quickfix list" })
  end,
})

-- Set up the keymap for the quickfix window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", RemoveQFItem, { buffer = true, desc = "Remove item from quickfix list" })
  end,
})

-- toggle completions
vim.keymap.set("n", "<leader>C", function()
  local cmp = require("cmp")
  local enabled = cmp.get_config().enabled -- Get current state
  cmp.setup({ enabled = not enabled }) -- Toggle state
  if enabled == false then
    vim.g.copilot_enabled = false
  else
    vim.g.copilot_enabled = false
  end
  vim.notify("Completions " .. (not enabled and "enabled" or "disabled"))
end, { desc = "Toggle completions (CMP)" })

vim.keymap.set("i", "<D-CR>", "<Esc>o", { noremap = true, desc = "Create new line above and enter insert mode" })
vim.keymap.set("i", "<S-D-CR>", "<Esc>O", { noremap = true, desc = "Create new line above and enter insert mode" })

-- Map <C-Up> to jump to the window above
vim.api.nvim_set_keymap("n", "<C-Up>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-Up>", "<C-o><C-w>k", { noremap = true })

-- Map <C-Down> to jump to the window below
vim.api.nvim_set_keymap("n", "<C-Down>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-Down>", "<C-o><C-w>j", { noremap = true })

-- Map <C-Left> to jump to the window on the left
vim.api.nvim_set_keymap("n", "<C-Left>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-Left>", "<C-o><C-w>h", { noremap = true })

-- Map <C-Right> to jump to the window on the right
vim.api.nvim_set_keymap("n", "<C-Right>", "<C-w>l", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-Right>", "<C-o><C-w>l", { noremap = true })

-- stylua: ignore
vim.keymap.set("n", "<leader>bc", function() vim.cmd("close") end, { desc = "close window" })
