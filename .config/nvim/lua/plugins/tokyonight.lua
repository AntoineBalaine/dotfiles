return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "moon",
    on_colors = function(colors)
      -- bg = "#222436",
      -- bg_dark = "#1e2030",
      -- bg_float = "#1e2030",
      -- bg_highlight = "#2f334d",
      -- bg_popup = "#1e2030",
      -- bg_search = "#3e68d7",
      -- bg_sidebar = "#1e2030",
      -- bg_statusline = "#1e2030",
      -- bg_visual = "#2d3f76",
      -- colors.bg_dark = "#000000"
      colors.bg = "#000000"
      -- colors.bg_dark = "#1e2030"
      colors.bg_float = "#000000"
      -- colors.bg_highlight = "#000000"
      colors.bg_search = "#000000"
      colors.bg_sidebar = "#000000"
      -- colors.bg_statusline = "#1e2030"
      -- colors.bg_visual = "#2d3f76"
    end,
  },
}
