--
-- lualine_y = {
--   { "progress", separator = " ", padding = { left = 1, right = 0 } },
-- lualine_z = { -- clock tb disabled
return {
  "nvim-lualine/lualine.nvim",

  opts = {
    sections = {
      lualine_y = {
        { "location", padding = { left = 1, right = 1 } },
      },
      lualine_z = {},
    },
  },
}
