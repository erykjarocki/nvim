return {
  "AlexvZyl/nordic.nvim",
  priority = 1000,
  config = function()
    local palette = require("nordic.colors")
    require("nordic").setup({
      -- This callback can be used to override the colors used in the palette.
      on_palette = function(palett)
        return palett
      end,
      -- Enable bold keywords.
      bold_keywords = false,
      -- Enable italic comments.
      italic_comments = true,
      -- Enable general editor background transparency.
      bright_border = true,
      -- Reduce the overall amount of blue in the theme (diverges from base Nord).
      reduced_blue = true,
      -- Swap the dark background with the normal one.
      swap_backgrounds = false,
      -- Override the styling of any highlight group.
      after_palette = function(palette)
        local U = require("nordic.utils")
        -- palette.bg_visual = U.blend(palette.orange.base, palette.bg, 0.15)
      end,
      on_highlight = function(highlights, palette)
        --  :filter /^Diffview/ hi -> to search for Diffview highlights
        highlights.TelescopePromptTitle = {
          underline = true,
          sp = palette.yellow.dim,
          undercurl = false,
        }
        highlights.Visual = {
          bg = palette.gray4,
        }
        highlights.PmenuSel = { bg = palette.yellow.dim, fg = palette.gray4 }
        highlights.Comment = { fg = palette.gray5 }
        highlights.DiffAdd = { bg = "None" }
        highlights.DiffviewDiffText = { bg = "#4a648c" }
        highlights.DiffviewDiffAdd = { bg = "#013220" }
        highlights.DiffviewDiffChange = { bg = "#2d4775" }

        highlights.DiffChange = {}
        highlights.MatchParen = { underline = true, bold = true, fg = palette.red.base }
        highlights.GitSignsAddPreview = { fg = palette.git.add, bg = palette.bg_sidebar }
        highlights.GitSignsDeletePreview = { fg = palette.git.delete, bg = palette.bg_sidebar }
        highlights.CursorColumn = { bg = palette.gray4 }
        highlights.CursorLineNr = { fg = palette.white0 }
      end,
      -- override = {
      --   TelescopePromptTitle = {
      --     underline = true,
      --     sp = palette.yellow.dim,
      --     undercurl = false,
      --   },
      --   -- https://github.com/AlexvZyl/nordic.nvim/blob/main/lua/nordic/groups/native.lua
      --   -- GitSignsAdd = { fg = palette.git.add, bg = palette.bg_sidebar },
      --   -- GitSignsDelete = { fg = palette.git.delete, bg = palette.bg_sidebar },
      --   -- DiffChange = { bg = palette.bg_sidebar },
      --   Visual = { bg = palette.gray4 },
      --   PmenuSel = { bg = palette.yellow.dim, fg = palette.gray4 },
      --   Comment = { fg = palette.gray5 },
      --   -- DiffChange = { bg = palette.none}, -- diff mode: Changed line |diff.txt|
      --   DiffAdd = { bg = "None" }, -- diff mode: Changed line |diff.txt|
      --   -- DiffDelete = { bg = palette.none}, -- diff mode: Changed line |diff.txt|
      --   -- GitSignsAdd = { fg = "#3d4a38" },
      --   -- GitSignsChange = { fg = palette.none, bg = palette.none },
      --   -- GitSignsDelete = { fg = palette.none, bg = palette.none },
      --   MatchParen = { underline = true, bold = true, fg = palette.red.base },
      --   GitSignsAddPreview = { fg = palette.git.add, bg = palette.bg_sidebar },
      --   GitSignsDeletePreview = { fg = palette.git.delete, bg = palette.bg_sidebar },
      --   CursorColumn = { bg = palette.gray4 },
      --   CursorLineNr = { fg = palette.white0 },
      --   -- CursorLine = { bg = palette.gray3 },
      -- },
      -- Cursorline options.  Also includes visual/selection.
      cursorline = {
        -- color = palette.gray4,
        -- Bold font in cursorline.
        bold = false,
        -- Bold cursorline number.
        bold_number = true,
        -- Available styles: 'dark', 'light'.
        theme = "light",
        -- Blending the cursorline bg with the buffer bg.
        blend = 1,
      },
      telescope = {
        -- Available styles: `classic`, `flat`.
        style = "classic",
      },
      leap = {
        -- Dims the backdrop when using leap.
        dim_backdrop = false,
      },
      ts_context = {
        -- Enables dark background for treesitter-context window
        dark_background = true,
      },
    })
    vim.cmd("colorscheme nordic")
  end,
}
