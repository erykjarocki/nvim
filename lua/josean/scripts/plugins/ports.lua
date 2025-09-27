-- lua/portwatcher.lua
local M = {}

-- Ports to monitor
local ports = { 8080, 8081, 8082, 8083 }

-- Store ongoing timer
local timer = nil

-- Last result
local occupied_cache = {}

-- Helper to check TCP port availability
local function check_port(port, callback)
  local sock = vim.loop.new_tcp()
  -- Try connecting to localhost:port
  sock:connect("127.0.0.1", port, function(err)
    if not sock:is_closing() then
      sock:close()
    end
    if err then
      callback(false) -- failed connect => port free
    else
      callback(true) -- connected => port occupied
    end
  end)
end

local float_buf = nil
local float_win = nil

local function render_float()
  local occupied = {}
  for _, p in ipairs(ports) do
    if occupied_cache[p] then
      table.insert(occupied, tostring(p))
    end
  end

  local text = ""
  local hl_group = "MoreMsg"
  if #occupied > 0 then
    text = "  : " .. table.concat(occupied, ",")
  else
    text = "  : all free"
  end

  -- Create or reuse floating buffer
  if not (float_buf and vim.api.nvim_buf_is_valid(float_buf)) then
    float_buf = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { text })
  -- Apply highlight to whole line
  vim.api.nvim_buf_add_highlight(float_buf, -1, hl_group, 0, 0, -1)

  -- Get editor size
  local ui = vim.api.nvim_list_uis()[1]
  local width = #text
  local height = 1
  local row = 2
  local col = ui.width - width - 1

  -- Create float win if needed
  if not (float_win and vim.api.nvim_win_is_valid(float_win)) then
    float_win = vim.api.nvim_open_win(float_buf, false, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      focusable = false,
      noautocmd = true,
      border = "none",
    })
    -- transparent overlay look
    vim.api.nvim_win_set_option(float_win, "winblend", 10)
  else
    -- Update position if editor resized
    vim.api.nvim_win_set_config(float_win, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
    })
  end
end

-- Schedule async checks over all ports
local function check_ports_async(cb)
  local results = {}
  local remaining = #ports

  for _, port in ipairs(ports) do
    check_port(port, function(is_used)
      results[port] = is_used
      remaining = remaining - 1
      if remaining == 0 then
        cb(results)
      end
    end)
  end
end

-- Render function: bottom-right corner using extmark + virt_text
local ns = vim.api.nvim_create_namespace("portwatcher")

-- Public start function
function M.start(interval_ms)
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end

  timer = vim.loop.new_timer()
  timer:start(0, interval_ms or 2000, function()
    check_ports_async(function(results)
      occupied_cache = results
      -- Defer all buffer manipulation to main thread
      vim.schedule(function()
        render_float()
      end)
    end)
  end)
end

-- Public stop function
function M.stop()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

return M
