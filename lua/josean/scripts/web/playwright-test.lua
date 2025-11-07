local run_playwright_test = function()
  -- Get the current file path
  local current_file = vim.fn.expand("%:p")

  if current_file == "" then
    print("No file is currently open")
    return
  end

  -- Check if it's a test file (ends with .test.ts, .spec.ts, etc.)
  if
    not string.match(current_file, "%.test%.ts$")
    and not string.match(current_file, "%.spec%.ts$")
    and not string.match(current_file, "%.test%.js$")
    and not string.match(current_file, "%.spec%.js$")
  then
    print("Current file is not a test file (.test.ts, .spec.ts, .test.js, .spec.js)")
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({
    cmd = "pnpm play:exwp " .. vim.fn.shellescape(current_file),
    hidden = false,
  }):toggle()
end

return run_playwright_test
