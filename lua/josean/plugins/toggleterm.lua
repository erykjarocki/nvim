return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 50,
        open_mapping = [[<c-\>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "float",
      })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<C-t>", "<Cmd>ToggleTerm<CR>", opts)
        vim.keymap.set("t", "<C-j>", "<Nop>", opts)
        vim.keymap.set("t", "<C-k>", "<Nop>", opts)
        -- vim.keymap.set("t", "<C-c>", "<Cmd>ToggleTerm<CR>", opts)
        -- vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        -- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        -- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        -- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        -- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        -- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end
      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      local Terminal = require("toggleterm.terminal").Terminal

      ------------------- PNPM CHANGESET DEPS ----------------------

      vim.keymap.set("n", "<leader>swc", require("josean.scripts.web.changeset"), { desc = "Add changeset" })

      ------------------- PNPM BUILD PROJECT ----------------------

      vim.keymap.set(
        "n",
        "<leader>swb",
        require("josean.scripts.web.build-project"),
        { desc = "Install and build dependencies" }
      )

      ------------------- LAZY GIT TOGGLE ----------------------

      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        -- Enable full screen: https://github.com/akinsho/toggleterm.nvim/issues/505
        float_opts = {
          width = vim.o.columns,
          height = vim.o.lines,
        },
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

      ------------------- TOGGLE TERMINAL ----------------------

      vim.keymap.set("n", "<C-t>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

      ------------------- MPV PLAYER ----------------------

      vim.keymap.set(
        "n",
        "<leader>mp",
        require("josean.scripts.open-with-mpv"),
        { desc = "Open media with mpv player" }
      )

      ------------------- GENERATE ICONS FOR WEB UI-ICONS ----------------------

      vim.keymap.set(
        "n",
        "<leader>swi",
        require("josean.scripts.web.generate-icons"),
        { desc = "Generate icon from downloaded svg" }
      )

      ------------------- PANDA CODEGEN ----------------------

      vim.keymap.set("n", "<leader>swp", function()
        local run_script = require("josean.scripts.plugins.script-runner")
        run_script({ "pnpm panda", "pnpm codegen" })
      end, { desc = "Panda generate" })

      ------------------- NUKE PORTS AND NODE ----------------------

      vim.keymap.set("n", "<leader>xx", function()
        Terminal:new({
          cmd = "killport 8081 8080 8082 8083 6006 && killall node",
          hidden = false,
        }):toggle()

        local animate = require("josean.utils.animations.animation")
        animate(require("josean.utils.animations.frames.explosion"))
      end, { desc = "💣 Nuke all node and ports" })

      ------------------- NPM SCRIPTS IN TELESCOPE ----------------------

      vim.keymap.set("n", "<leader>sp", require("josean.scripts.run-npm-script"), { noremap = true, silent = true })

      ------------------- NPM VERSION OF PACKAGE IN LINE ----------------------

      vim.keymap.set(
        "n",
        "<leader>npmv",
        require("josean.scripts.npm.versions").show_package_versions,
        { noremap = true, silent = true, desc = "Show list of versions of the package 📦📋" }
      )

      vim.keymap.set("n", "<leader>npmi", function()
        local run_scripts = require("josean.scripts.plugins.script-runner")
        run_scripts({ "pnpm i" })
      end, { noremap = true, silent = true, desc = "Install packages 📦📥" })
    end,
    --
    -- Update current line dependency to latest
    vim.keymap.set("n", "<leader>npml", function()
      require("josean.scripts.npm.versions").update_to_latest()
    end, { desc = "Update package to latest 📦🆕" }),
  },
}
