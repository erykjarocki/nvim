return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  lazy = false,
  enabled = true,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview",
        autocomplete = false,
        setup,
      },
      window = {
        completion = cmp.config.window.bordered({
          max_height = 1,
          scrollbar = true,
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["Down"] = cmp.mapping.select_next_item(), -- next suggestion
        ["Up"] = cmp.mapping.select_prev_item(), -- prev suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-i>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- mapping = {
      --   ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
      --   ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
      --   ["Down"] = cmp.mapping.select_next_item(), -- next suggestion
      --   ["Up"] = cmp.mapping.select_prev_item(), -- prev suggestion
      --   ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      --   ["<C-f>"] = cmp.mapping.scroll_docs(4),
      --   ["<C-i>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      --   ["<C-e>"] = cmp.mapping({
      --     i = cmp.mapping.abort(),
      --     c = cmp.mapping.close(),
      --   }),
      --   ["<CR>"] = cmp.mapping.confirm({ select = false }),
      -- },

      -- sources for autocompletion
      -- TODO wait for fix, its not currently working
      -- { name = "copilot", group_index = 2 },
      -- TODO think about better snippets, current are useles
      -- { name = "luasnip" }, -- snippets
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            local item = entry:get_completion_item()
            -- Filter out completions coming from @newhope/components
            if item.label and string.match(item.label, "^@newhope/components") then
              return false
            end
            return true
          end,
        },
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
