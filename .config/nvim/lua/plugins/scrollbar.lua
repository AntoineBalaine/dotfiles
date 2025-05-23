return {
  "lewis6991/satellite.nvim",
  opts = {
    current_only = false,
    winblend = 20,
    zindex = 80,
    excluded_filetypes = {},
    width = 10,
    handlers = {
      cursor = {
        enable = true,
      },
      gitsigns = {
        enable = true,
        signs = { -- can only be a single character (multibyte is okay)
          add = "█",
          change = "█",
          delete = "█",
        },
        -- Highlights:
        -- SatelliteGitSignsAdd (default links to GitSignsAdd)
        -- SatelliteGitSignsChange (default links to GitSignsChange)
        -- SatelliteGitSignsDelete (default links to GitSignsDelete)
      },
      search = {
        enable = true,
        -- Highlights:
        -- - SatelliteSearch (default links to Search)
        -- - SatelliteSearchCurrent (default links to SearchCurrent)
      },
      diagnostic = {
        enable = true,
        signs = { "█", "█", "█" },
        min_severity = vim.diagnostic.severity.HINT,
        -- Highlights:
        -- - SatelliteDiagnosticError (default links to DiagnosticError)
        -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
        -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
        -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
      },
      marks = {
        enable = false,
        show_builtins = false, -- shows the builtin marks like [ ] < >
        key = "m",
        -- Highlights:
        -- SatelliteMark (default links to Normal)
      },
      quickfix = {
        signs = { "-", "=", "≡" },
        -- Highlights:
        -- SatelliteQuickfix (default links to WarningMsg)
      },
    },
  },
}
