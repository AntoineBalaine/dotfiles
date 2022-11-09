vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    -- Set buffer-local options
    vim.opt_local.relativenumber = true
    vim.opt_local.number = true
    -- vim.opt_local.conceallevel = 0

    vim.opt_local.concealcursor = "nc"
  end,
})
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" },
    "gptlang/lua-tiktoken",
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  init = function()
    vim.api.nvim_create_user_command("CopilotChatSelection", function(opts)
      -- Get the selection range
      local start_line = opts.line1
      local end_line = opts.line2
      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
      local filetype = vim.bo[bufnr].filetype
      local filename = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":p:.")

      -- Create the lines to insert with fold markers
      local insert_lines = {
        string.format("```%s %s:%d-%d", filetype, filename, start_line, end_line),
      }
      -- Add selected lines
      for _, line in ipairs(lines) do
        table.insert(insert_lines, line)
      end
      -- Add closing fence and fold marker
      table.insert(insert_lines, "```")

      -- Find the CopilotChat buffer
      local chat_buf = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "copilot-chat" then
          chat_buf = buf
          break
        end
      end

      if chat_buf then
        -- Append the text to the chat buffer
        local chat_win = vim.fn.bufwinid(chat_buf)
        if chat_win ~= -1 then
          local last_line = vim.api.nvim_buf_line_count(chat_buf)
          vim.api.nvim_buf_set_lines(chat_buf, last_line, last_line, false, insert_lines)
          -- Move cursor to the end
          vim.api.nvim_win_set_cursor(chat_win, { last_line + #insert_lines, 0 })
        end
      else
        vim.notify("No CopilotChat buffer found", vim.log.levels.ERROR)
      end
    end, { range = true })
  end,
  opts = {
    -- context = nil,
    model = "claude-3.5-sonnet",
    chat_autocomplete = true,
    selection = false,
    contexts = {
      selection = {
        -- Add selection context
        description = "Selected text in the current buffer",
        resolve = function(_, source)
          local select = require("CopilotChat.select")
          return { select.visual(source) }
        end,
      },
      -- You can keep other contexts if you want them
    },
  },

  keys = {
    { "<leader>as", ":'<,'>CopilotChatSelection<CR>", desc = "Send selection to CopilotChat" },
    -- History management
    { "<leader>aS", ":CopilotChatSave ", desc = "Save Chat History" },
    { "<leader>al", ":CopilotChatLoad ", desc = "Load Chat History" },

    -- Configuration and info
    { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "Debug Info" },
    { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
    { "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "Select Agent" },

    -- Visual mode commands
    { "<leader>ae", ":'<,'>CopilotChat explain this code<cr>", mode = "v", desc = "Explain Selected Code" },
    {
      "<leader>at",
      ":'<,'>CopilotChat write tests for this code<cr>",
      mode = "v",
      desc = "Generate Tests for Selection",
    },
    { "<leader>af", ":'<,'>CopilotChat fix this code<cr>", mode = "v", desc = "Fix Selected Code" },
    { "<leader>ar", ":'<,'>CopilotChat refactor this code<cr>", mode = "v", desc = "Refactor Selected Code" },

    -- Regular commands
    { "<leader>ac", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Chat" },
    { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open Chat" },
    { "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Close Chat" },
    { "<leader>ax", "<cmd>CopilotChatStop<cr>", desc = "Stop Chat Output" },
    { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },

    -- Selection to chat
    { "<leader>as", ":'<,'>CopilotChatSelection<CR>", mode = "v", desc = "Send selection to chat" },
  },
}
