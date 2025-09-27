-- put this in your init.lua or lua/plugins/package_query.lua
local M = {}

function M.show_package_versions()
  -- Ensure we're in package.json
  local buf_name = vim.api.nvim_buf_get_name(0)
  if not buf_name:match("package.json$") then
    print("Not in a package.json file")
    return
  end

  -- Get current line text
  local line = vim.api.nvim_get_current_line()

  -- Try to extract the package name from something like: "react": "^18.0.0",
  local pkg = line:match([["([^"]+)"]])

  if not pkg or pkg == "" then
    print("Could not detect package name in current line")
    return
  end

  -- Build command
  local cmd = string.format("pnpm view %s versions --registry=https://registry.npmjs.org --json; exec $SHELL", pkg)

  -- Use toggleterm
  local ok, toggleterm = pcall(require, "toggleterm.terminal")
  if not ok then
    print("toggleterm.nvim is not installed")
    return
  end

  local Terminal = toggleterm.Terminal
  Terminal:new({
    cmd = cmd,
    direction = "float", -- you can change to "horizontal"/"vertical"/"tab"
    hidden = false,
    close_on_exit = false,
  }):toggle()
end

-- Replace current line's version with latest from npm and save buffer
function M.update_to_latest()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if not buf_name:match("package.json$") then
    print("Not in a package.json file")
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1] -- current line number
  local line = vim.api.nvim_get_current_line()

  local pkg = line:match([["([^"]+)"]])
  if not pkg or pkg == "" then
    print("Could not detect package name in current line")
    return
  end

  -- Extract current version (e.g. from "react": "^18.2.0",)
  local current_version = line:match([[:%s*"[%^~]?([^"]+)"]])
  if not current_version then
    print("Could not parse current version in line")
  end

  -- Run npm info to get the latest version
  local output = vim.fn.system({
    "pnpm",
    "view",
    pkg,
    "version",
    "--registry=https://registry.npmjs.org",
    "--json",
  })

  if vim.v.shell_error ~= 0 then
    print("Error fetching package info: " .. output)
    return
  end

  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or not decoded then
    print("Could not parse npm output")
    return
  end

  local latest_version = decoded
  if type(decoded) == "table" then
    latest_version = decoded[#decoded]
  end

  if not latest_version then
    print("Could not find latest version")
    return
  end

  -- Compare with current version
  if current_version and current_version == latest_version then
    print(string.format("✅ %s is already up-to-date (%s)", pkg, latest_version))
    return
  end

  -- Replace version in the line
  local new_line = line:gsub([[:%s*"[^"]+"]], ': "' .. latest_version .. '"')

  -- Apply change in buffer
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })

  -- Save the file
  vim.cmd("write")

  print(string.format("⬆️ Updated %s: %s → %s (saved)", pkg, current_version or "?", latest_version))
end

return M
