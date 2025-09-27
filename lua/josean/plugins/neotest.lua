return {
  {
    "nvim-neotest/neotest",
    version = "5.9.0",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Test under cursor",
      },
      {
        "<leader>tu",
        function()
          require("neotest").run.run({ jestCommand = "pnpm jest --updateSnapshot" })
        end,
        desc = "Update snapshots",
      },
      {
        "<leader>tR",
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
        desc = "Run tests in file",
      },
      -- {
      --   "<leader>tR",
      --   function()
      --     require("neotest").run.run({ strategy = "dap" })
      --   end,
      --   desc = "Run Last Test",
      -- },
      {
        "<leader>tL",
        function()
          require("neotest").run.run_last({ strategy = "dap" })
        end,
        desc = "Debug Last Test",
      },
      -- {
      --   "<leader>tw",
      --   "<cmd>lua require('neotest').run.run({ jestCommand = 'pnpm jest --watch ' })<cr>",
      --   desc = "Run Watch",
      -- },
      {
        "<leader>ts",
        "<cmd>Neotest summary toggle<cr>",
        desc = "Toggle test summary window",
      },
      {
        "<leader>tW",
        "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>",
        desc = "Toggle watch file",
      },
      {
        "<leader>tw",
        "<cmd>lua require('neotest').watch.toggle()<cr>",
        desc = "Toggle watch single test",
      },
      {
        "<leader>td",
        "<cmd>lua require('neotest').output.open({ enter = true })<cr>",
        desc = "Open output window",
      },
      {
        "<leader>to",
        "<cmd>lua require('neotest').output_panel.toggle({})<cr>",
        desc = "Toggle test summary window",
      },
      {
        "<leader>tc",
        "<cmd>lua require('neotest').output_panel.clear()<cr>",
        desc = "Clear output panel",
      },
      {
        "<leader>ta",
        "<cmd>Neotest attach<cr>",
        desc = "attach test",
      },
      {
        "[t",
        "<cmd>Neotest jump prev<cr>",
        desc = "Jump to prev test",
      },
      {
        "]t",
        "<cmd>Neotest jump next<cr>",
        desc = "Jump to next test",
      },
      {
        "<leader>tx",
        "<cmd>Neotest stop<cr>",
        desc = "Stop test",
      },
    },
    config = function()
      require("neotest").setup({
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          notify = "",
          passed = "",
          running = "",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "",
          unknown = "",
          watching = "",
        },
        floating = {
          border = "rounded",
          max_height = 0.9,
          max_width = 0.9,
        },
        adapters = {
          require("neotest-jest")({
            jestCommand = "pnpm test --",
            jestConfigFile = "jest.config.ts",
            -- jestConfigFile = function(file)
            --   if string.find(file, "/packages/") or string.find(file, "/apps/") then
            --     return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
            --   end
            --
            --   return vim.fn.getcwd() .. "/jest.config.ts"
            -- end,
            env = { CI = true },
            -- this function is used to determine the root of the project
            -- otherwise you would have to manually cd into the root of the given project
            cwd = function(file)
              if string.find(file, "/packages/") or string.find(file, "/apps/") then
                return string.match(file, "(.-/[^/]+/)src")
              end
              return vim.fn.getcwd()
            end,
          }),
        },
      })
    end,
  },
}
