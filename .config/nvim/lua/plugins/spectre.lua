local spectre_config = {
  "nvim-pack/nvim-spectre",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    fold_on_search = true,
    auto_fold = true,
    find_engine = {
      ["rg"] = {
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--sort",
          "path",
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>fR", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    { "<leader>fw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search Current Word" },
    { "<leader>fW", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search in Current File" },
    { '<leader>fs', function() require("spectre").toggle() end, desc = "Toggle Spectre" },
    { "<leader>fw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search Current Word" },
    { "<leader>fy", function() require("spectre").copy_enabled_filenames() end, desc = "copy enabled files’ names"}
  },
}

-- spectre_config[0] = "AntoineBalaine/nvim-spectre"
-- spectre_config["dev"] = true
-- spectre_config["dir"] = "/Users/antoine/Documents/personnel/experiments/nvim_plugins/nvim-spectre",

return spectre_config
