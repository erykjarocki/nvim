vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.incsearch = true

opt.cursorline = true
-- adds different character to show diff -> for diffview plugin
opt.fillchars:append({ diff = " " })

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
--
-- show sign column so that text doesn't shift
opt.signcolumn = "auto:2"

-- allow backspace on indent, end of line or insert mode start position
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.foldcolumn = "auto"
opt.foldmethod = "manual"
opt.foldenable = true

-- turn off swapfile
opt.swapfile = false

-- vim session for plugin auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- detect changes of file in disc when change occurs run :e
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-- persist undo between open and close editor
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    priority = 6,
  },
})
