local function open_with_mpv()
  local Terminal = require("toggleterm.terminal").Terminal
  vim.ui.input({ prompt = "Enter file name: ", completion = "file", default = "~/Downloads/" }, function(input)
    if input then
      local escaped_input = input:gsub("([%s%(%)])", "\\%1")
      if input ~= "" then
        Terminal:new({
          cmd = "mpv --keep-open --fs " .. escaped_input .. " ; exec $SHELL",
          hidden = false,
        }):toggle()
      end
    end
  end)
end

return open_with_mpv
