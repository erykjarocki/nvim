return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
  },

  config = function()
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 1
    vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
    vim.g.lazygit_floating_window_use_plenary = false
    -- fix problem with not reading global CONFIG_DIR variable
    local lazygit_config = vim.fn.resolve("/Users/ejarocki/.config/lazygit/config.yml")
    vim.g.lazygit_use_custom_config_file_path = 1
    vim.g.lazygit_config_file_path = lazygit_config
  end,
}
