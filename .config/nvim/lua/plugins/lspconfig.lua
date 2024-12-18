-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("ziggy", {}),
--   pattern = "ziggy",
--   callback = function()
--     vim.lsp.start({
--       name = "Ziggy LSP",
--       cmd = { "ziggy", "lsp" },
--       -- root_dir = vim.loop.cwd(),
--       flags = { exit_timeout = 1000, debounce_text_changes = 150 },
--     })
--   end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("ziggy_schema", {}),
--   pattern = "ziggy_schema",
--   callback = function()
--     vim.lsp.start({
--       name = "Ziggy LSP",
--       cmd = { "ziggy", "lsp", "--schema" },
--       -- root_dir = vim.loop.cwd(),
--       flags = { exit_timeout = 1000, debounce_text_changes = 150 },
--     })
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("superhtml", {}),
  pattern = "superhtml",
  callback = function()
    vim.lsp.start({
      name = "SuperHTML LSP",
      cmd = { "superhtml", "lsp" },
      -- root_dir = vim.loop.cwd(),
      flags = { exit_timeout = 1000, debounce_text_changes = 150 },
    })
  end,
})
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        superhtml = {
          mason = false,
          cmd = { "/Users/a266836/Documents/personnel/Experiments/zig/projects/superhtml/zig-out/bin/superhtml", "lsp" },
        },
        -- supermd = {
        --   mason = false,
        --   cmd = { "~/Documents/personnel/Experiments/zig/projects/supermd/zig-out/bin/docgen", "lsp" },
        -- },
        ziggy = {
          mason = false,
          cmd = { "/Users/a266836/Documents/personnel/Experiments/zig/projects/ziggy/zig-out/bin/ziggy", "lsp" },
        },
        -- ["ziggy-schema"] = {
        --   mason = false,
        --   cmd = {
        --     "/Users/a266836/Documents/personnel/Experiments/zig/projects/ziggy/zig-out/bin/ziggy",
        --     "lsp",
        --     "--schema",
        --   },
        -- },

        zls = {
          -- mason = false,
          -- cmd = { "/Users/a266836/Documents/personnel/Experiments/zig/projects/zls/zig-out/bin/zls" },
          -- settings = {
          --   zig_exe_path = "/Users/a266836/Documents/personnel/Experiments/zig/zig-macos-aarch64-0.14.0-dev.1951+857383689/zig",
          -- },
        },
      },
    },
  },
}
