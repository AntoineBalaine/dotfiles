require("obsidian").setup({
  dir = "~/Documents/Obsidian/Notes",
  completion = {
    nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
  },
  daily_notes = {
    folder = "journal/",
    format_date = function()
      return string.sub(os.date("%Y%m%d"), 3)
    end,
  }
})
vim.keymap.set(
  "n",
  "gf",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true }
)
