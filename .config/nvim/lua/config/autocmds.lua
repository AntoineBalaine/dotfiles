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
