-- Your nvim-dap config
return {
  "mfussenegger/nvim-dap",
  optional = true,
  -- stylua: ignore
  keys = {
    { "<F5>",  function() require("dap").continue() end  , { desc = "Debug: Continue" } },
    { "<F10>", function() require("dap").step_over() end  , { desc = "Debug: Step Over" } },
    { "<F11>", function() require("dap").step_into() end  , { desc = "Debug: Step Into" } },
    { "<F12>", function() require("dap").step_out() end  , { desc = "Debug: Step Out" } },
  },
}
