formatters = {
  superhtml = {
    inherit = false,
    command = "superhtml",
    stdin = true,
    args = { "fmt", "--stdin" },
  },
  ziggy = {
    inherit = false,
    command = "ziggy",
    stdin = true,
    args = { "fmt", "--stdin" },
  },
  ziggy_schema = {
    inherit = false,
    command = "ziggy",
    stdin = true,
    args = { "fmt", "--stdin-schema" },
  },
}

return {
  "stevearc/conform.nvim",
  optional = true,
  ---@param opts ConformOpts
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters_by_ft.shtml = { "superhtml" }
    opts.formatters_by_ft.ziggy = { "ziggy" }
    opts.formatters_by_ft.ziggy_schema = { "ziggy_schema" }

    opts.formatters = opts.formatters or {}
    opts.formatters.superhtml = {
      inherit = false,
      command = "superhtml",
      stdin = true,
      args = { "fmt", "--stdin" },
    }
    opts.formatters.ziggy = {
      inherit = false,
      command = "ziggy",
      stdin = true,
      args = { "fmt", "--stdin" },
    }
    opts.formatters.ziggy_schema = {
      inherit = false,
      command = "ziggy",
      stdin = true,
      args = { "fmt", "--stdin-schema" },
    }
  end,
}
