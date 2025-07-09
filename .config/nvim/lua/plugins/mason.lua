return {
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    opts = {
      ensure_installed = {},
      automatic_installation = {
        exclude = { "zls" },
      },
    },
  },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0", opts = {
    inlay_hints = { enabled = false },
  } },
}
