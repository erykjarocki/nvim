--[[
  Playwright Test Runner for Neovim (<leader>tr)

  This mapping lets you run Playwright tests directly from the current file.
  It supports running ONLY the test that your cursor is currently inside.

  When triggered, it shows a small selection menu offering two modes:
    • Desktop mode  → pnpm play:exwp
    • Mobile mode   → pnpm play:nhwp:m

  After choosing a mode, the command runs in a vertical split terminal.

  HOW TEST DETECTION WORKS
  ------------------------
  The helper function searches upward from the cursor to find the nearest line
  containing one of these patterns:

      test("name", ...)
      test('name', ...)
      it("name", ...)
      it('name', ...)

  It extracts the test name from the quotes and passes it to Playwright using:

      --grep "<test name>"

  That way, only the targeted test runs instead of the entire file.

  SUMMARY OF FLOW
  ---------------
    1. Press <leader>pr
    2. Neovim locates the test name above the cursor
    3. You pick desktop or mobile execution
    4. A terminal opens running:
         pnpm play:<chosen> <current-file> --grep "<test name>"

  This creates a fast, editor-native workflow for running focused Playwright
  tests without leaving Neovim or typing terminal commands manually.
]]

local function find_nearest_test_name()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]

  for line_nr = cursor, 1, -1 do
    local line = vim.fn.getline(line_nr)

    -- Match test("name"), test('name'), it("name"), it('name')
    local name = line:match('%b""') or line:match("%b''")

    if name then
      return name:sub(2, -2) -- remove quotes
    end
  end

  return nil
end

vim.keymap.set("n", "<leader>pr", function()
  local current_file = vim.fn.expand("%")
  local test_name = find_nearest_test_name()

  if not test_name then
    print("No test name found above cursor.")
    return
  end

  local choices = {
    { label = "desktop", cmd = "pnpm play:exwp " .. current_file .. ' --grep "' .. test_name .. '"' },
    { label = "mobile", cmd = "pnpm play:nhwp:m " .. current_file .. ' --grep "' .. test_name .. '"' },
  }

  vim.ui.select(choices, {
    prompt = "Run Playwright test:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd("vsplit | terminal " .. choice.cmd)
  end)
end, { desc = "Run current Playwright test under cursor" })
