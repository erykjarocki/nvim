return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  enabled = false,
  config = function()
    -- vim.keymap.set("i", "<C-y>", "copilot#Accept()", { desc = "Copilot accept hint" })
    -- vim.keymap.set("i", "<C-n>", "copilot#Next()", { desc = "Copilot next hint" })
    -- vim.keymap.set("i", "<C-p>", "copilot#Previous()", { desc = "Copilot previous hint" })

    require("copilot").setup({
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          -- TODO consider adding C-y as standard way of accepting
          accept = "<C-y>",
          accept_word = false,
          accept_line = false,
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-e>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      server_opts_overrides = {
        trace = "verbose",
        settings = {
          advanced = {
            inlineSuggestCount = 5, -- #completions for getCompletions
          },
        },
      },
    })
  end,
}
