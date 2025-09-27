return {
  "mason-org/mason-lspconfig.nvim",
  opts = {},
  enabled = true,
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason-lspconfig").setup({
      automatic_enable = true, -- default true, you can disable this feature to install only specific
    })
  end,
}
