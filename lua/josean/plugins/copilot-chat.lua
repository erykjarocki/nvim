return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    enabled = false,
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function()
      local chat = require("CopilotChat")
      local context = chat.context
      local utils = chat.utils

      vim.keymap.set("n", "<leader>cco", function()
        chat.open({ context = nil, selection = nil }) -- Open with truly empty context
      end, { desc = "CopilotChat toggle" })
      vim.keymap.set("n", "<leader>cct", "<cmd>CopilotChatTest<CR>", { desc = "CopilotChat Test file" })
      vim.keymap.set("n", "<leader>ccx", "<cmd>CopilotChatStop<CR>", { desc = "CopilotChat stop" })
      vim.keymap.set("n", "<leader>ccr", "<cmd>CopilotChatReset<CR>", { desc = "CopilotChat reset" })
      vim.keymap.set("n", "<leader>ccm", "<cmd>CopilotChatModels<CR>", { desc = "CopilotChat choose model" })
      vim.keymap.set("n", "<leader>cca", "<cmd>CopilotChatAgents<CR>", { desc = "CopilotChat choose agent" })
      vim.keymap.set("n", "<leader>ccp", "<cmd>CopilotChatPrompts<CR>", { desc = "CopilotChat prompt list" })

      vim.keymap.set("n", "<leader>ccf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotChat Fix Diagnostic in file" })

      vim.keymap.set("n", "<leader>ccs", function()
        local input = vim.fn.input("Save as: ")
        if input ~= "" then
          chat.save(input)
        end
      end, { desc = "CopilotChat - save" })

      vim.keymap.set("n", "<leader>ccl", function()
        local input = vim.fn.input("Load: ")
        if input ~= "" then
          chat.load(input)
        end
      end, { desc = "CopilotChat - load" })

      vim.keymap.set("n", "<leader>ccb", function()
        chat.open({ selection = require("CopilotChat.select").buffer })
      end, { desc = "CopilotChat - Chat for current buffer" }) -- restore last workspace session for current directory

      vim.keymap.set("v", "<leader>cco", function()
        chat.open({ selection = require("CopilotChat.select").visual })
      end, { desc = "CopilotChat - Chat for current selection" })

      vim.keymap.set("v", "<leader>cce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat Explain selection" })
      vim.keymap.set("v", "<leader>ccd", "<cmd>CopilotChatDocs<CR>", { desc = "CopilotChat Document selection" })
      vim.keymap.set("v", "<leader>ccp", "<cmd>CopilotChatOptimize<CR>", { desc = "CopilotChat optimize selection" })
      vim.keymap.set("v", "<leader>ccr", "<cmd>CopilotChatReview<CR>", { desc = "CopilotChat review selection" })
      vim.keymap.set("v", "<leader>ccf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotChat fix selection" })
      vim.keymap.set("v", "<leader>cct", "<cmd>CopilotChatTest<CR>", { desc = "CopilotChat generate tests" })

      local prompts = require("josean.copilot.system-prompts")
      chat.setup({
        model = "claude-sonnet-4",
        debug = true, -- Enable debugging
        temperature = 0.5,
        question_header = "## Eric ", -- Header to use for user questions
        answer_header = "## Copilot ", -- Header to use for AI answers
        system_prompt = prompts.COPILOT_INSTRUCTIONS,
        prompts = {
          Generate = {
            system_prompt = prompts.COPILOT_INSTRUCTIONS .. prompts.COPILOT_GENERATE,
          },
          REVIEW_PLAYWRIGHT = {
            system_prompt = prompts.COPILOT_REVIEW_PLAYWRIGHT,
            -- context = "git:main",
          },
        },
        mappings = {
          complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
          },
          close = {
            normal = "<C-c>",
            insert = "<C-c>",
          },
          reset = {
            normal = "<C-x>",
            insert = "<C-x>",
          },
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-s>",
          },
          accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>",
          },
          yank_diff = {
            normal = "gy",
          },
          show_diff = {
            normal = "gd",
          },
          show_info = {
            normal = "gp",
          },
          show_context = {
            normal = "gs",
          },
        },
      })
    end,
    -- See Commands section for default commands if you want to lazy load on them
    contexts = {

      file = {
        input = function(callback)
          local telescope = require("telescope.builtin")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          telescope.find_files({
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                callback(selection[1])
              end)
              return true
            end,
          })
        end,
      },
    },
  },
}
