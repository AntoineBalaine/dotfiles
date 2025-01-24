-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    command = "setlocal makeprg=tectonic\\ %",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "zig",
    callback = function()
        vim.keymap.set("n", "<leader>zb", function()
            require("zig-comp-diag").runWithCmd({ "zig", "build", "-Dtest=true" })
        end, { buffer = true, desc = "Zig build" })

        vim.keymap.set("n", "<leader>zt", function()
            require("zig-comp-diag").runWithCmd({ "zig", "test", vim.fn.expand("%") })
        end, { buffer = true, desc = "Zig test current file" })

        vim.keymap.set("n", "<leader>zT", function()
            require("zig-comp-diag").runWithCmd({ "zig", "build", "test" })
        end, { buffer = true, desc = "Zig build test" })

        vim.keymap.set("n", "<leader>zr", function()
            require("zig-comp-diag").runWithCmd({
                "zig",
                "build",
                "-Dtest=true",
                "--prefix",
                '"/Users/a266836/Library/Application Support/REAPER/UserPlugins"',
                "&&",
                "/Applications/REAPER.app/Contents/MacOS/REAPER",
                "new",
            })
        end, { buffer = true, desc = "Zig install reaper" })
    end,
})


vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "quickfix",
    callback = function()
        if vim.bo.buftype == "quickfix" then
            local list = #vim.fn.getloclist(0) > 0 and vim.fn.getloclist(0) or vim.fn.getqflist()
            local item = list[vim.fn.line('.')]
            if item and item.filename then
                vim.cmd('pedit! ' .. vim.fn.fnameescape(item.filename))
            end
        end
    end,
})

-- these stupid plugins that reset this option at every file open…
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.diagnostic.config({ virtual_text = false })
  end,
  desc = "Force conceallevel to always be 0",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
  end,
  desc = "Don’t highlight folds",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    -- Add all filetypes you want to fold
    local fold_filetypes = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "rust",
      "go",
      "zig",
    }

    -- Check if current filetype should be folded
    if vim.tbl_contains(fold_filetypes, filetype) then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt_local.foldnestmax = 1
      vim.cmd("normal! zM")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function()
    vim.keymap.set("n", "<leader>zb", function()
      require("zig-comp-diag").runWithCmd({ "zig", "build", "-Dtest=true" })
    end, { buffer = true, desc = "Zig build" })

    vim.keymap.set("n", "<leader>zt", function()
      require("zig-comp-diag").runWithCmd({ "zig", "test", vim.fn.expand("%") })
    end, { buffer = true, desc = "Zig test current file" })

    vim.keymap.set("n", "<leader>zT", function()
      require("zig-comp-diag").runWithCmd({ "zig", "build", "test" })
    end, { buffer = true, desc = "Zig build test" })

    vim.keymap.set("n", "<leader>zr", function()
      require("zig-comp-diag").runWithCmd({
        "zig",
        "build",
        "-Dtest=true",
        "--prefix",
        '"/Users/a266836/Library/Application Support/REAPER/UserPlugins"',
        "&&",
        "/Applications/REAPER.app/Contents/MacOS/REAPER",
        "new",
      })
    end, { buffer = true, desc = "Zig install reaper" })
  end,
})
