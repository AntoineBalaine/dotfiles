return {
  "lewis6991/gitsigns.nvim",
  config = {
    linehl = true,
  },

  keys = {
    -- F53 is actually Shift+F5 in many terminals, but I'm keeping your original keycode
    {
      "<F53>",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "Go to next git hunk",
    },
    {
      "<S-M-F5>",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "Go to previous git hunk",
    },

    {
      -- toggle inline diff
      "<leader>gd",
      function()
        -- require("gitsigns").toggle_linehl()
        require("gitsigns").toggle_deleted()
      end,
      { desc = "Inline diff" },
    },
  },
}
