-- Sort quickfix entries by specified criteria
-- @param criteria: 'filename', 'lnum', or 'text'
-- @param reverse: boolean, true for descending order
local function SortQuickfix(criteria, reverse)
  local qf_list = vim.fn.getqflist()

  -- Define sorting functions for different criteria
  local sort_functions = {
    filename = function(a, b)
      local a_path = vim.fn.bufname(a.bufnr)
      local b_path = vim.fn.bufname(b.bufnr)
      return reverse and (a_path > b_path) or (a_path < b_path)
    end,

    lnum = function(a, b)
      return reverse and (a.lnum > b.lnum) or (a.lnum < b.lnum)
    end,

    text = function(a, b)
      return reverse and (a.text > b.text) or (a.text < b.text)
    end,
  }

  -- Validate sorting criteria
  if not sort_functions[criteria] then
    vim.notify("Invalid sorting criteria. Use 'filename', 'lnum', or 'text'", vim.log.levels.ERROR)
    return
  end

  -- Sort the quickfix list
  table.sort(qf_list, sort_functions[criteria])

  -- Update the quickfix list
  vim.fn.setqflist(qf_list, "r")

  -- Refresh the quickfix window if it's open
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
    vim.cmd("copen")
  end

  -- Show confirmation message
  local order = reverse and "descending" or "ascending"
  vim.notify(string.format("Quickfix list sorted by %s in %s order", criteria, order), vim.log.levels.INFO)
end

-- Set up commands for easy access
vim.api.nvim_create_user_command("QFSort", function(opts)
  local criteria = opts.args or "filename"
  SortQuickfix(criteria, false)
end, {
  nargs = "?",
  complete = function()
    return { "filename", "lnum", "text" }
  end,
  desc = "Sort quickfix list by specified criteria",
})

-- Optional: Add keymaps for the quickfix window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    -- Sort by filename
    vim.keymap.set("n", "<leader>sf", function()
      SortQuickfix("filename", false)
    end, { buffer = true, desc = "Sort quickfix by filename" })

    -- Sort by line number
    vim.keymap.set("n", "<leader>sl", function()
      SortQuickfix("lnum", false)
    end, { buffer = true, desc = "Sort quickfix by line number" })

    -- Sort by text
    vim.keymap.set("n", "<leader>st", function()
      SortQuickfix("text", false)
    end, { buffer = true, desc = "Sort quickfix by text" })

    -- Reverse sort by filename
    vim.keymap.set("n", "<leader>sF", function()
      SortQuickfix("filename", true)
    end, { buffer = true, desc = "Reverse sort quickfix by filename" })
  end,
})
