return {
  "folke/flash.nvim",
  keys = {
    -- disable the keymap to grep files
    --
    -- "s", ,
    -- "S", mode = { "n", "o", "x" },
    { "s", mode = { "n", "x", "o" }, false },
    { "S", mode = { "n", "x", "o" }, false },

    {
      "j",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "J",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
  },
}
