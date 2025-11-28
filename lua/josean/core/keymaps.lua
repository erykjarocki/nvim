vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Move cursor Up" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Move cursor Down" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Move cursor left" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>w>", "10<C-w>>", { desc = "Make splits equal size" })
keymap.set("n", "<leader>w<", "10<C-w><", { desc = "Make splits equal size" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })

-- make p behave normally (not losing clipboard value after paste)
keymap.set("v", "p", "P", { desc = "paste with preserve clipboard" })
keymap.set("v", "y", "ygv<ESC>", { desc = "yank without moving cursor" })

--  COMMAND MODE --

-- use <C-j> and <C-k> to navigate command history
vim.cmd("cnoremap <expr> <C-K> wildmenumode() ? '<C-P>' : '<Up>'")
vim.cmd("cnoremap <expr> <C-J> wildmenumode() ? '<C-N>' : '<Down>'")

-- accept completion with <CR> in command mode if popup menu is visible
vim.keymap.set("c", "<cr>", function()
  if vim.fn.pumvisible() == 1 then
    return "<c-y>"
  end
  return "<cr>"
end, { expr = true })

-- Update current line dependency to latest
vim.keymap.set("n", "<leader>npml", function()
  require("josean.scripts.npm.versions").update_to_latest()
end, { desc = "Update package to latest 📦 🆕" })
