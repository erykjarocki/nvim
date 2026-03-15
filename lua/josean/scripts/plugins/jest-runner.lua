--[[
  Jest Test Runner for Neovim (<leader>tr)

  This mapping lets you run Jest tests directly from the current file.
  It supports running ONLY the test that your cursor is currently inside.

  When triggered, it shows a selection menu offering two modes:
    • Desktop mode  → pnpm jest:desktop
    • Mobile mode   → pnpm jest:mobile

  After choosing a mode, the command runs in a vertical split terminal.

  HOW TEST DETECTION WORKS
  ------------------------
  The helper function searches upward from the cursor to find the nearest line
  containing one of these patterns:

      test("name", ...)
      test('name', ...)
      it("name", ...)
      it('name', ...)

  It extracts the test name from the quotes and passes it to Jest using:

      --testNamePattern "<test name>"

  SUMMARY OF FLOW
  ---------------
    1. Press <leader>tr
    2. Neovim locates the test name above the cursor
    3. You pick desktop or mobile execution
    4. A terminal opens running:
         pnpm jest:<chosen> <current-file> --testNamePattern "<test name>"
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

vim.keymap.set("n", "<leader>tr", function()
  local current_file = vim.fn.expand("%")
  local test_name = find_nearest_test_name()

  if not test_name then
    print("No test name found above cursor.")
    return
  end

  vim.cmd("vsplit | terminal " .. "pnpm test:ci " .. current_file .. ' -- -t"' .. test_name .. '"')
end, { desc = "Run current Jest test under cursor" })
