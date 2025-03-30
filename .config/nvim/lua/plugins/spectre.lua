return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    find_engine = {
      ["rg"] = {
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--sort",
          "path",
        },
      },
    },
  },
  -- config = function(_, opts)
  --   -- Apply the options
  --   require("spectre").setup(opts)
  --
  --   -- Add custom fold toggle function
  --   vim.api.nvim_create_autocmd("FileType", {
  --     pattern = "spectre_panel",
  --     callback = function()
  --       -- Create a local function to toggle folds except current
  --       local function toggle_all_folds_except_current()
  --         -- Get current line
  --         local current_line = vim.fn.line(".")
  --
  --         -- Find the start of the current fold (file header)
  --         local fold_start = current_line
  --         while fold_start > 0 do
  --           local line = vim.fn.getline(fold_start)
  --           local is_header = not line:match("^│") -- Headers don't start with the result padding
  --
  --           if is_header and fold_start < current_line then
  --             break
  --           end
  --
  --           if is_header then
  --             break
  --           end
  --
  --           fold_start = fold_start - 1
  --         end
  --
  --         -- Close all folds
  --         vim.cmd("normal! zM")
  --
  --         -- If we found a valid fold start, open just that fold
  --         if fold_start > 0 then
  --           vim.fn.cursor(fold_start, 1)
  --           vim.cmd("normal! zo")
  --           -- Return to original position
  --           vim.fn.cursor(current_line, 1)
  --         end
  --       end
  --
  --       -- Map it to a key, for example 'zf'
  --       vim.api.nvim_buf_set_keymap(0, "n", "zf", "", {
  --         noremap = true,
  --         silent = true,
  --         callback = toggle_all_folds_except_current,
  --       })
  --     end,
  --   })
  -- end,
  -- stylua: ignore
  keys = {
    { "<leader>fR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    { "<leader>fw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search Current Word" },
    { "<leader>fW", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search in Current File" },
    { '<leader>fs', function() require("spectre").toggle() end, desc = "Toggle Spectre" },
    { "<leader>fw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search Current Word" },
  },
  config = function(_, opts)
    -- Apply the options
    require("spectre").setup(opts)

    -- Add custom fold toggle function
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "spectre_panel",
      callback = function()
        -- Create a local variable to track if auto-folding is enabled
        local auto_folding_enabled = false
        local last_line = -1
        local debounce_timer = nil

        -- Function to toggle all folds except current
        local function toggle_all_folds_except_current()
          -- Get current line
          local current_line = vim.fn.line(".")

          -- Skip if we're still on the same line
          if current_line == last_line then
            return
          end
          last_line = current_line

          -- Find the start of the current fold (file header)
          local fold_start = current_line
          while fold_start > 0 do
            local line = vim.fn.getline(fold_start)
            local is_header = not line:match("^│") -- Headers don't start with the result padding

            if is_header and fold_start < current_line then
              break
            end

            if is_header then
              break
            end

            fold_start = fold_start - 1
          end

          -- Close all folds
          vim.cmd("normal! zM")

          -- If we found a valid fold start, open just that fold
          if fold_start > 0 then
            vim.fn.cursor(fold_start, 1)
            vim.cmd("normal! zo")
            -- Return to original position
            vim.fn.cursor(current_line, 1)
          end
        end

        -- Function to toggle auto-folding on/off
        local function toggle_auto_folding()
          auto_folding_enabled = not auto_folding_enabled

          if auto_folding_enabled then
            -- Create the autocmd for cursor movement
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = 0, -- Current buffer
              callback = function()
                -- Use debounce to prevent performance issues
                if debounce_timer then
                  vim.fn.timer_stop(debounce_timer)
                end

                debounce_timer = vim.fn.timer_start(100, function()
                  toggle_all_folds_except_current()
                end)
              end,
              group = vim.api.nvim_create_augroup("SpectreAutoFold", { clear = true }),
            })

            -- Show notification
            vim.notify("Spectre auto-folding enabled", vim.log.levels.INFO)

            -- Initial fold
            toggle_all_folds_except_current()
          else
            -- Clear the autocmd group to disable auto-folding
            vim.api.nvim_clear_autocmds({ group = "SpectreAutoFold" })

            -- Show notification
            vim.notify("Spectre auto-folding disabled", vim.log.levels.INFO)
          end
        end

        -- Map manual fold toggle to 'zf'
        vim.api.nvim_buf_set_keymap(0, "n", "zf", "", {
          noremap = true,
          silent = true,
          callback = toggle_all_folds_except_current,
        })

        -- Map auto-folding toggle to 'za'
        vim.api.nvim_buf_set_keymap(0, "n", "za", "", {
          noremap = true,
          silent = true,
          callback = toggle_auto_folding,
        })
      end,
    })
  end,
}
