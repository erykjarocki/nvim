return {
  "mason-org/mason.nvim",
  enabled = true,
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
