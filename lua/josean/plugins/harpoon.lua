return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = true,
    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,
    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,
    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,
    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },
    -- set marks specific to each git branch inside git repository
    mark_branch = false,
    -- enable tabline with harpoon marks
    tabline = false,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
  },
  config = function()
    -- require("telescope").load_extension("harpoon")
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Add file to harpoon" })
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<C-p>", function()
      harpoon:list():select(1)
    end, { desc = "Select 1 file" })

    vim.keymap.set("n", "<C-n>", function()
      harpoon:list():select(2)
    end, { desc = "Select 2 file" })

    vim.keymap.set("n", "<C-s>", function()
      harpoon:list():select(3)
    end, { desc = "Select 3 file" })

    -- vim.keymap.set("n", "<C-s>", function()
    --   harpoon:list():select(4)
    -- end, { desc = "Select 4 file" })
  end,
}
