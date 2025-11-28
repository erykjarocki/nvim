local footer_texts = {
  "💡 Code is like humor. When you have to explain it, it’s bad.",
  "🚀 Welcome to Neovim! Let's make something awesome today!",
  "🌟 Keep pushing your limits.",
  "🔧 Debugging is like being a detective in a crime movie where you are also the murderer.",
  "💻 Happy coding! May the source be with you.",
  "🎯 Focus on the goal, not the obstacles.",
  "💡 Simplicity is the soul of efficiency.",
  "🚀 Code more, worry less.",
  "🌟 Every great developer you know got there by solving problems they were unqualified to solve until they actually did it.",
  "🔧 First, solve the problem. Then, write the code.",
  "💻 Programs must be written for people to read, and only incidentally for machines to execute.",
  "🎯 The best error message is the one that never shows up.",
  "💡 Make it work, make it right, make it fast.",
  "🚀 Code is like humor. When you have to explain it, it’s bad.",
  "🌟 Experience is the name everyone gives to their mistakes.",
  "🔧 In order to be irreplaceable, one must always be different.",
  "💻 Java is to JavaScript what car is to Carpet.",
  "🎯 Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday’s code.",
  "💡 Before software can be reusable it first has to be usable.",
  "🚀 The only way to go fast, is to go well.",
  "🌟 Any fool can write code that a computer can understand. Good programmers write code that humans can understand.",
  "🔧 If debugging is the process of removing software bugs, then programming must be the process of putting them in.",
  "💻 Walking on water and developing software from a specification are easy if both are frozen.",
  "🎯 It’s not a bug – it’s an undocumented feature.",
  "💡 Software undergoes beta testing shortly before it’s released. Beta is Latin for ‘still doesn’t work.’",
  "🚀 There are two ways to write error-free programs; only the third one works.",
  "🌟 The best thing about a boolean is even if you are wrong, you are only off by a bit.",
  "🔧 Without requirements or design, programming is the art of adding bugs to an empty text file.",
  "💻 The trouble with programmers is that you can never tell what a programmer is doing until it’s too late.",
  "🎯 Don’t worry if it doesn’t work right. If everything did, you’d be out of a job.",
  "💡 I think Microsoft named .Net so it wouldn’t show up in a Unix directory listing.",
  "🚀 There are only two kinds of programming languages: those people always bitch about and those nobody uses.",
  "🌟 The most disastrous thing that you can ever learn is your first programming language.",
  "🔧 The proper use of comments is to compensate for our failure to express ourselves in code.",
  "💻 You should name a variable using the same care with which you name a first-born child.",
  "🎯 Programming is like sex: one mistake and you’re providing support for a lifetime.",
  "💡 The best method for accelerating a computer is the one that boosts it by 9.8 m/s².",
  "🚀 If at first you don’t succeed, call it version 1.0.",
  "🌟 There are three kinds of lies: Lies, damned lies, and benchmarks.",
  "🔧 Programming is not about typing, it’s about thinking.",
  "💻 The best performance improvement is the transition from the nonworking state to the working state.",
  "🎯 The cheapest, fastest, and most reliable components are those that aren’t there.",
  "💡 The best code is no code at all.",
  "🚀 The best thing about a boolean is even if you are wrong, you are only off by a bit.",
  "🌟 The only way to go fast, is to go well.",
  "🔧 The best error message is the one that never shows up.",
  "💻 The best method for accelerating a computer is the one that boosts it by 9.8 m/s².",
  "🎯 The best thing about a boolean is even if you are wrong, you are only off by a bit.",
  "💡 The only way to go fast, is to go well.",
  "🚀 The best error message is the one that never shows up.",
}

local function get_random_footer()
  math.randomseed(os.time())
  return footer_texts[math.random(#footer_texts)]
end

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  cond = function()
    -- use this to conditionally load alpha plugin - add for ML plugins
    return true
    -- return vim.env.ALPHA ~= nil
  end,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠋⠉⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣠⣤⣤⣤⣤⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠴⠒⠊⠉⠉⠀⠀⣿⣿⣿⠿⠋⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⢀⡠⠼⠴⠒⠒⠒⠒⠦⠤⠤⣄⣀⠀⢀⣠⠴⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⣼⠿⠋⠁⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠀⣇⠔⠂⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⢰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⠤⠒⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⢀⡟⠀⣠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⢻⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⡤⠤⢴]],
      [[           ⠀⠀⠀⠀⠀⣸⠁⣾⣿⣀⣽⡆⠀⠀⠀⠀⠀⠀⠀⢠⣾⠉⢿⣦⠀⠀⠀⢸⡀⠀⠀⢀⣠⠤⠔⠒⠋⠉⠉⠀⠀⠀⠀⢀⡞]],
      [[           ⠀⠀⠀⠀⢀⡏⠀⠹⠿⠿⠟⠁⠀⠰⠦⠀⠀⠀⠀⠸⣿⣿⣿⡿⠀⠀⠀⢘⡧⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠀]],
      [[           ⠀⠀⠀⠀⣼⠦⣄⠀⠀⢠⣀⣀⣴⠟⠶⣄⡀⠀⠀⡀⠀⠉⠁⠀⠀⠀⠀⢸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠁⠀]],
      [[           ⠀⠀⠀⢰⡇⠀⠈⡇⠀⠀⠸⡾⠁⠀⠀⠀⠉⠉⡏⠀⠀⠀⣠⠖⠉⠓⢤⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⠀⠀]],
      [[           ⠀⠀⠀⠀⢧⣀⡼⠃⠀⠀⠀⢧⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⣧⠀⠀⠀⣸⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠃⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠈⢧⡀⠀⠀⠀⠀⠘⣆⠀⠀⠀⢠⠏⠀⠀⠀⠀⠈⠳⠤⠖⠃⡟⠀⠀⠀⢾⠛⠛⠛⠛⠛⠛⠛⠛⠁⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⠙⣆⠀⠀⠀⠀⠈⠦⣀⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠙⢦⠀⠀⠘⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⢠⡇⠙⠦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠴⠋⠸⡇⠈⢳⡀⠀⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⠀⡼⣀⠀⠀⠈⠙⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⣷⠴⠚⠁⠀⣀⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠀⠀⠀⡴⠁⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⡴⠚⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⣾⢷⡆⠀⣠⡴⠧⣄⣇⠀⠀⠀⠀⠀⠀⠀⢲⠀⡟⠀⠀⠀⠀⠀⠀⠀⢀⡇⣠⣽⢦⣄⢀⣴⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⡿⣼⣽⡞⠁⠀⠀⠀⢹⡀⠀⠀⠀⠀⠀⠀⠈⣷⠃⠀⠀⠀⠀⠀⠀⠀⣼⠉⠁⠀⠀⢠⢟⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⣷⠉⠁⢳⠀⠀⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⣻⠀⠀⠀⠀⠀⠀⠀⣰⠃⠀⠀⠀⠀⠏⠀⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠹⡆⠀⠈⡇⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⣸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⢳⡀⠀⠙⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⣰⠃⠀⠀⠀⠀⢀⡄⠀⢠⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⢳⡀⣰⣀⣀⣀⠀⠀⠀⠘⣦⣀⠀⠀⠀⡇⠀⠀⠀⢀⡴⠃⠀⠀⠀⠀⠀⢸⡇⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[           ⠀⠀⠉⠉⠀⠀⠈⠉⠉⠉⠙⠻⠿⠾⠾⠻⠓⢦⠦⡶⡶⠿⠛⠛⠓⠒⠒⠚⠛⠛⠁               ⠀]],
    }

    local function open_oldfiles_and_explorer()
      local ok, telescope = pcall(require, "telescope.builtin")
      if not ok then
        return
      end

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      telescope.oldfiles({
        attach_mappings = function(_, map)
          local function open_and_reveal()
            local entry = action_state.get_selected_entry()
            actions.close(_)

            if not entry or not entry.path then
              return
            end

            -- open file
            vim.cmd("edit " .. vim.fn.fnameescape(entry.path))

            -- remember current window
            local file_win = vim.api.nvim_get_current_win()

            -- reveal in nvim-tree
            pcall(vim.cmd, "NvimTreeFindFile")

            -- go back to file window
            vim.api.nvim_set_current_win(file_win)
          end

          map("i", "<CR>", open_and_reveal)
          map("n", "<CR>", open_and_reveal)

          return true
        end,
      })
    end

    vim.api.nvim_create_user_command("OpenOldfilesAndExplorer", open_oldfiles_and_explorer, {})
    dashboard.section.buttons.val = {
      dashboard.button("None", "󰁯  → Open last file", "<cmd>OpenOldfilesAndExplorer<CR>"),
      dashboard.button("None", "󱖫  → Open todo list", "<cmd>e ~/notes/todo.md<CR>"),
      dashboard.button("SPC ef", "  → Toggle file explorer", "<cmd>NvimTreeFindFile<CR>"),
      dashboard.button("SPC ff", "󰱼  → Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fw", "  → Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("q", "  → Quit NVIM", "<cmd>qa<CR>"),
    }

    dashboard.section.footer = {
      type = "text",
      val = get_random_footer(),
      opts = { position = "center", hl = "AlphaFooter" },
    }

    dashboard.config.layout = {
      { type = "padding", val = 1 },
      {
        type = "group",
        val = {
          {
            type = "text",
            val = dashboard.section.header.val,
            opts = { position = "center", hl = "AlphaHeader" },
          },
          {
            type = "text",
            val = " ",
          },
          {
            type = "group",
            val = dashboard.section.buttons.val,
            opts = { position = "center" },
          },
          { type = "padding", val = 1 },
          dashboard.section.footer,
        },
      },
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[highlight AlphaButton guifg=#B0B0B0]]) -- Gray text for buttons
    vim.cmd([[highlight AlphaHeader guifg=#BDB76B]])
    vim.cmd([[highlight AlphaFooter guifg=#BDB76B]])
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
