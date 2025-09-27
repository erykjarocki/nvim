-- lua/lspstatus.lua
local M = {}

local namespace = vim.api.nvim_create_namespace("LspStatusNamespace")
local win_id = nil
local buf_id = nil

-- Function to gather active LSPs for the current buffer
local function get_attached_lsps()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return #names > 0 and table.concat(names, ", ") or "No LSP"
end

-- Function to create or update floating window
local function update_lsp_status()
  -- If not in normal buffer, skip (exclude e.g. NvimTree, help, etc.)
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft == "" or vim.bo.buftype ~= "" then
    return
  end

  local text = " " .. get_attached_lsps() -- using gear icon
  if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    vim.api.nvim_buf_del_extmark(buf_id, namespace, 1)
  end

  -- Close old floating window if exists
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end

  buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { text })
  vim.api.nvim_buf_add_highlight(buf_id, namespace, "ModeMsg", 0, 0, -1)

  local ui = vim.api.nvim_list_uis()[1]
  local opts = {
    relative = "editor",
    width = #text,
    height = 1,
    col = ui.width - #text - 1,
    row = 1,
    style = "minimal",
    focusable = false,
    border = nil,
  }

  win_id = vim.api.nvim_open_win(buf_id, false, opts)
end

-- Auto update on events like attach/detach/change buffers
function M.setup()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufWritePost", "InsertLeave", "LspAttach", "LspDetach" }, {
    callback = update_lsp_status,
  })
  local timer = vim.loop.new_timer()
  timer:start(
    0,
    2000,
    vim.schedule_wrap(function()
      update_lsp_status()
    end)
  )
end

return M
