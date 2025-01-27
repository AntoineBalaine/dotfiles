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

-- Git hunk navigation (assuming you're using gitsigns.nvim)
vim.keymap.set("n", "<F53>", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Go to next git hunk" })

vim.keymap.set("n", "<S-M-F5>", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Go to previous git hunk" })

-- toggle inline diff
vim.keymap.set("n", "<leader>gd", function()
  -- require("gitsigns").toggle_linehl()
  require("gitsigns").toggle_deleted()
end, { desc = "Inline diff" })
-- " When using `dd` in the quickfix list, remove the item from the quickfix list.

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

local dap = require("dap")

vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })

vim.keymap.set("n", "k", RMGET, { desc = "remove getter" })


vim.keymap.set("v", "<leader>as", ":'<,'>CopilotChatSelection<CR>", { desc = "Send selection to CopilotChat" })
