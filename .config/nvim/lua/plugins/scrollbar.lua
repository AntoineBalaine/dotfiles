return {
  "lewis6991/satellite.nvim",
  opts = {
    current_only = false,
    winblend = 0,
    zindex = 90,
    excluded_filetypes = {},
    width = 1,
    handlers = {
      cursor = { enable = true },
      gitsigns = {
        enable = true,
        signs = {
          add = "█",
          change = "█",
          delete = "█",
        },
      },
      search = {
        enable = true,
      },
      diagnostic = {
        enable = false,
        signs = { "█", "█", "█" },
        min_severity = vim.diagnostic.severity.WARN,
      },
      marks = {
        enable = false,
        show_builtins = false,
        key = "m",
      },
    },
  },
}
