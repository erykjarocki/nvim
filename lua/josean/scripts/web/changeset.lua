local run_changeset = function()
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = "pnpm changeset", hidden = false }):toggle()
end

return run_changeset
