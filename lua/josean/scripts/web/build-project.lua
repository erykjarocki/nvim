local build_project = function()
  local input = vim.fn.input("project name filter: ")
  if input == "" then
    input = "@newhope/desktop"
  end

  -- local run_script = require("josean.scripts.plugins.script-runner")
  -- run_script({ "pnpm i && pnpm build --filter " .. input .. "" })
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({
    cmd = "pnpm i && pnpm build --filter " .. input .. "; exec $SHELL",
    hidden = false,
  }):toggle()
end

return build_project
