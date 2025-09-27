return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    {
      "<leader>a+",
      function()
        local tree_ext = require("avante.extensions.nvim_tree")
        tree_ext.add_file()
      end,
      desc = "Select file in NvimTree",
      ft = "NvimTree",
    },
    {
      "<leader>a-",
      function()
        local tree_ext = require("avante.extensions.nvim_tree")
        tree_ext.remove_file()
      end,
      desc = "Deselect file in NvimTree",
      ft = "NvimTree",
    },
  },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local api = require("nvim-tree.api")
    local telescope = require("telescope")

    local function open_live_grep_with_current_dir()
      local treeNode = api.tree.get_node_under_cursor()
      if treeNode then
        telescope.extensions.live_grep_args.live_grep_args({
          -- this is presumably slow, consider different approach
          default_text = '"" ' .. treeNode.absolute_path .. ' --iglob ""',
          attach_mappings = function()
            -- Defer the cursor movement to ensure the prompt is ready
            vim.defer_fn(function()
              -- Move the cursor after the word "hello"
              local prompt_winnr = vim.api.nvim_get_current_win()
              vim.api.nvim_win_set_cursor(prompt_winnr, { 1, 3 })
            end, 10)
            return true
          end,
        })
      else
        print("No node selected")
        return nil
      end
    end

    -- Set key mapping to call the custom function
    vim.keymap.set(
      "n",
      "<leader>fa",
      open_live_grep_with_current_dir,
      { desc = "Open live grape in current tree node" }
    )

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      -- vim.keymap.del("n", "<C-e>")
      -- vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
    end

    nvimtree.setup({
      update_focused_file = { enable = true },
      on_attach = my_on_attach,
      view = {
        width = 45,
        relativenumber = true,
        preserve_window_proportions = true,
        adaptive_size = false,
      },
      -- change folder arrow icons
      renderer = {
        root_folder_label = "--",
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              -- arrow_closed = "", -- arrow when folder is closed
              -- arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          -- resize_window = false,
        },
      },
      filters = {
        custom = { ".DS_Store", "node_modules" },
        git_ignored = false,
      },
    })

    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end,
}
