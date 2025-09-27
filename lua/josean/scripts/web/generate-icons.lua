local play_with_mvp = function()
  local Terminal = require("toggleterm.terminal").Terminal
  vim.ui.input({ prompt = "Enter file name: ", completion = "file", default = "~/Downloads/" }, function(input)
    if input then
      local escaped_input = input:gsub("([%s%(%)])", "\\%1")
      if input ~= "" then
        Terminal
          :new({
            cmd = "mv "
              .. escaped_input
              .. " ~/WebstormProjects/web/packages/ui-icons/assets/svg_figma/ && cd ~/WebstormProjects/web/packages/ui-icons && pnpm generate; exec $SHELL",
            hidden = false,
          })
          :toggle()
      end
    end
  end)
end

return play_with_mvp
