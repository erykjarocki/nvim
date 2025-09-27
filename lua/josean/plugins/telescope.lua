return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })
    local function filenameFirst(_, path)
      local tail = vim.fs.basename(path)
      local parent = vim.fs.dirname(path)
      if parent == "." then
        return tail
      end
      return string.format("%s\t\t%s", tail, parent)
    end

    -- end of nice search and pickers added to setup
    telescope.setup({
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting

          mappings = { -- extend mappings
            i = {
              -- ["<C-k>"] = lga_actions.quote_prompt(),
              -- ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- ["<C-space>"] = actions.to_fuzzy_refine,
            },
          },
        },
      },
      pickers = {
        live_grep_args = {
          path_display = filenameFirst,
        },
        find_files = {
          path_display = filenameFirst,
        },
        live_grep = {
          path_display = filenameFirst,
        },
        oldfiles = {
          path_display = filenameFirst,
        },
        grep_string = {
          path_display = filenameFirst,
        },
      },
      defaults = {
        file_ignore_patterns = {
          "NvimTree_1",
          "pnpm%-lock.yaml",
          "pnpm%-workspace.yaml",
          "lazy%-lock.json",
          "node_modules",
          ".*/dist/.*",
        },
        path_display = { "smart" },
        sorting_strategy = "descending",
        mappings = {
          n = {
            ["<C-c>"] = actions.close, -- move to next result
            -- <Tab> → actions.toggle_selection + actions.move_selection_next
            -- <S-Tab> (Shift-Tab) → actions.toggle_selection + actions.move_selection_previous
            ["<C-y>"] = actions.toggle_selection + actions.move_selection_previous, -- move to next result
            -- respects selection
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-t>"] = actions.toggle_all, -- toggle all
          },
          i = {
            -- respects selection
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-c>"] = actions.close, -- move to next result
            ["<C-y>"] = actions.toggle_selection + actions.move_selection_previous, -- move to next result
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-t>"] = actions.toggle_all, -- toggle all
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files in cwd" })
    keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "List edited files (git status)" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope resume initial_mode=normal<cr>", { desc = "Find files in cwd" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
    keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers list" })
    keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Find diagnostics" })
    keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Findin help_tags" })
    keymap.set(
      "v",
      "<leader>fw",
      "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>",
      { desc = "Find selected string in cwd" }
    )

    local function open_live_grep_with_text()
      telescope.extensions.live_grep_args.live_grep_args({
        -- this is presumably slow, consider different approach
        default_text = '"" packages/ui-kit --iglob ""',
        attach_mappings = function(_, map)
          -- Defer the cursor movement to ensure the prompt is ready
          vim.defer_fn(function()
            -- Move the cursor after the word "hello"
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            local prompt_winnr = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_cursor(prompt_winnr, { 1, 3 })
          end, 10)
          return true
        end,
      })
    end

    -- Set key mapping to call the custom function
    -- vim.keymap.set("n", "<leader>fa", open_live_grep_with_text, { desc = "Find files with 'hello world' pre-filled" })
  end,
}
