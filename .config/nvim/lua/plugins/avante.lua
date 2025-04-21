local function setup_avante_syntax()
  -- Enable treesitter injection for markdown
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    incremental_selection = { enable = true },
    injections = {
      enable = true,
    },
  })

  -- Register AvanteInput as markdown for syntax purposes
  vim.treesitter.language.register("markdown", "AvanteInput")

  -- Set up syntax for both filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "Avante", "AvanteInput" },
    callback = function()
      -- Enable markdown syntax
      vim.opt_local.syntax = "markdown"
    end,
  })
end
return {
  "AntoineBalaine/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  -- branch = "main", -- Explicitly track the main branch of your fork
  -- version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  dev = true,
  dir = "/Users/antoine/Documents/personnel/experiments/nvim_plugins/avante.nvim",
  opts = {
    -- add any opts here
    -- for example
    scroll = false,
    provider = "claude",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-7-sonnet-20250219",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      disable_tools = true, -- disable tools!
    },
    windows = {
      edit = {
        start_insert = false, -- Start insert mode when opening the edit window
      },
      ask = {
        start_insert = false, -- Start insert mode when opening the ask window
      },
    },
    behaviour = {
      auto_apply_diff_after_generation = false,

      auto_scroll_response = false,
      -- enable_claude_text_editor_tool_mode = false,
    },
    disabled_tools = {

      -- "git_diff",
      -- "git_commit",
      -- "list_files",
      -- "search_files",
      -- "search_keyword",
      -- "read_file_toplevel_symbols",
      -- "read_file",
      "bash",
      "create_dir",
      "create_file",
      "delete_dir",
      "delete_file",
      "fetch",
      "grep",
      "python",
      "rag_search",
      "rename_dir",
      "rename_file",
      "view",
      "web_search",
    },
    mappings = {
      sidebar = {
        close = {},
      },

      stop = "<leader>aS",
    },
    -- web_search_engine = {
    --   provider = "kagi", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
    --   proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    -- },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  config = function(_, opts)
    -- Set up the plugin with the provided options
    require("avante").setup(opts)

    -- Register autocmd for Avante filetype
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "Avante", "AvanteInput" },
      callback = function()
        vim.opt_local.foldmethod = "expr"
        -- This expression checks if the line starts (^) with your markers
        vim.opt_local.foldexpr = [[getline(v:lnum) =~# '^```' ? '>1' : getline(v:lnum) =~# '^```' ? '<1' : '=']]
        vim.opt_local.foldcolumn = "1"
        vim.opt_local.foldenable = true
        -- vim.opt_local.foldtext = [[
        --     let line = getline(v:foldstart)
        --     return '> ' . line
        -- ]]
      end,
    })
  end,
  init = function()
    setup_avante_syntax()
    vim.api.nvim_create_user_command("AvanteSelection", function(opts)
      -- Get the selection range
      local start_line = opts.line1
      local end_line = opts.line2
      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
      local filetype = vim.bo[bufnr].filetype
      local filename = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":p:.")

      -- Create the lines to insert with complete format string
      local insert_lines = {
        string.format("```%s %s:%d-%d", filetype, filename, start_line, end_line),
      }
      -- Add selected lines
      for _, line in ipairs(lines) do
        table.insert(insert_lines, line)
      end
      -- Add closing fence
      table.insert(insert_lines, "```")

      -- Find the Avante input buffer
      local avante_input_buf = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "AvanteInput" then
          avante_input_buf = buf
          break
        end
      end

      if avante_input_buf then
        -- Append the text to the Avante input buffer
        local avante_win = vim.fn.bufwinid(avante_input_buf)
        if avante_win ~= -1 then
          local last_line = vim.api.nvim_buf_line_count(avante_input_buf)
          -- If the buffer is not empty, add a newline before the new content
          if
            last_line > 1 or (last_line == 1 and vim.api.nvim_buf_get_lines(avante_input_buf, 0, 1, false)[1] ~= "")
          then
            table.insert(insert_lines, 1, "")
          end
          vim.api.nvim_buf_set_lines(avante_input_buf, last_line, last_line, false, insert_lines)
          -- Move cursor to the end
          vim.api.nvim_win_set_cursor(avante_win, { last_line + #insert_lines, 0 })
        end
      else
        vim.notify("No Avante input buffer found. Please open Avante first.", vim.log.levels.ERROR)
      end
    end, { range = true })
  end,

  keys = {
    { "<leader>as", ":'<,'>AvanteSelection<CR>", mode = { "x", "v" }, desc = "Send selection to Avante" },
  },
}
