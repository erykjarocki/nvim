-- Function to show explosion animation
local function show_animation(frames)
  local ns = vim.api.nvim_create_namespace("explosionAnimation")

  -- Create scratch buffer + floating win
  local bufnr = vim.api.nvim_create_buf(false, true)
  local width, height = 40, 12

  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "double",
  })

  -- Ensure window closes when finished
  vim.bo[bufnr].modifiable = false

  local i = 1
  local timer = vim.loop.new_timer()
  timer:start(
    0,
    400,
    vim.schedule_wrap(function()
      if not vim.api.nvim_win_is_valid(win) then
        timer:stop()
        timer:close()
        return
      end

      if i > #frames then
        timer:stop()
        timer:close()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        return
      end

      -- Reset buffer
      vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(frames[i], "\n"))
      vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

      -- Apply highlights
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      for lnum, line in ipairs(vim.split(frames[i], "\n")) do
        local hl = "Normal"
        if line:find("%^") or line:find("%*") or line:find("%)") then
          hl = "WarningMsg" -- yellow/orange
        end
        if line:find("#") or line:find("@") or line:find("&") then
          hl = "ErrorMsg" -- red
        end
        if line:find("%|") then
          hl = "Title" -- brighter (like stem of mushroom)
        end
        vim.api.nvim_buf_add_highlight(bufnr, ns, hl, lnum - 1, 0, -1)
      end

      i = i + 1
    end)
  )
end

return show_animation
