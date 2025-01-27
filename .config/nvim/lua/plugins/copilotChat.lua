return {
  {
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
      model = "gpt-3.5-turbo",
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
  },
}
