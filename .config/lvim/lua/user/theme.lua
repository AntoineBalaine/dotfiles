local vscode = pcall(require('vscode'))
if (not vscode) then 
  return 
else
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
end
