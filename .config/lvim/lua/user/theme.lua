local vscode = require('vscode')
vscode.setup({
  -- Enable italic comment
  italic_comments = true,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = true,

  -- Override colors (see ./lua/vscode/colors.lua)
  color_overrides = {
    vscBack = '#000000',
  },

})


lvim.colorscheme = "vscode"
