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
