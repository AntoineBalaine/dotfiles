return {
  "AntoineBalaine/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  branch = "main", -- Explicitly track the main branch of your fork
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  dev = { true },
  dir = "/Users/antoine/.local/share/nvim/lazy/avante.nvim",
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
}
