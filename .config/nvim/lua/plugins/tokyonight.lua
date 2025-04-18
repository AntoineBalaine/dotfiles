return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "moon",
    on_colors = function(colors)
      -- bg = "#222436",
      colors.comment = "#7c88c8"
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

    on_highlights = function(hl, colors)
      hl.LineNr = {
        fg = colors.orange, -- Lighter gray for line numbers
      }

      hl.LineNrAbove = {
        fg = colors.comment, -- White for current line number
      }
      hl.LineNrBelow = {
        fg = colors.comment, -- White for current line number
      }
      hl.CursorLineNr = {
        fg = colors.orange, -- White for current line number
        bold = true,
      }
      hl["@function"] = {
        -- fg = colors.blue, -- Keep the original color
        bold = true, -- Make function names bold
        -- italic = true, -- Make function names italic
        -- You can also add underline if desired
        underline = true,
      }
    end,
  },
}
