local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.enable({
  "eslint",
  "lua_ls",
  "jsonls",
  "yamlls",
  "html",
  "cssls",
  -- "emmet_ls",
  "ts_ls",
})

-- Setup Lua language server: make it aware of Neovim runtime & plugins
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        -- Make 'gd' and completion work for plugins like telescope.actions
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- vim.lsp.config("emmet_ls", {
--   capabilities = (function()
--     local caps = vim.lsp.protocol.make_client_capabilities()
--     -- disable completion capability
--     caps.textDocument.completion.completionItem.snippetSupport = false
--     return caps
--   end)(),
-- })

-- this did not work when it was defined on_attached in eslint.lua setup
-- so thats why its defined here
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client.name == "eslint" then
      vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
        client:request_sync("workspace/executeCommand", {
          command = "eslint.applyAllFixes",
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
              version = vim.lsp.util.buf_versions[bufnr],
            },
          },
        }, nil, bufnr)
      end, {})

      vim.keymap.set(
        "n",
        "<leader>lf",
        "<cmd>LspEslintFixAll<CR>:w<CR>",
        { noremap = true, silent = true, buffer = bufnr }
      )
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.cmd("LspEslintFixAll")
        end,
      })
    end
  end,
})
