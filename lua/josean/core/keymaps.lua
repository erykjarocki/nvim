vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Move cursor Up" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Move cursor Down" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Move cursor left" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>w>", "10<C-w>>", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>w<", "10<C-w><", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- make p behave normally (not losing clipboard value after paste)
keymap.set("v", "p", "P", { desc = "paste with preserve clipboard" })
keymap.set("v", "y", "ygv<ESC>", { desc = "yank without moving cursor" })

--  COMMAND MODE --

-- in command mode, use <C-j> and <C-k> to navigate command history
vim.cmd("cnoremap <expr> <C-K> wildmenumode() ? '<C-P>' : '<Up>'")
vim.cmd("cnoremap <expr> <C-J> wildmenumode() ? '<C-N>' : '<Down>'")
-- Add this function to your configuration file

-- accept completion with <CR> in command mode if popup menu is visible
vim.keymap.set("c", "<cr>", function()
  if vim.fn.pumvisible() == 1 then
    return "<c-y>"
  end
  return "<cr>"
end, { expr = true })

-- Function to find the nearest package.json directory
local function find_project_root()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.fnamemodify(current_file, ":h")

  -- Walk up the directory tree looking for package.json
  while current_dir ~= "/" do
    if vim.fn.filereadable(current_dir .. "/package.json") == 1 then
      return current_dir
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  -- Fallback to current working directory if no package.json found
  return vim.fn.getcwd()
end

-- Progress indicator state
local progress_timer = nil
local progress_frames = require("josean.utils.animations.frames.progress")
local progress_index = 1

-- Function to show progress indicator
local function show_progress()
  progress_index = (progress_index % #progress_frames) + 1
  vim.cmd("redrawstatus")
  vim.api.nvim_echo({
    { progress_frames[progress_index] .. " Generating Panda styles...", "DiagnosticInfo" },
  }, false, {})
end

-- Function to start progress indicator
local function start_progress()
  if progress_timer then
    progress_timer:stop()
  end
  progress_timer = vim.loop.new_timer()
  progress_timer:start(0, 100, vim.schedule_wrap(show_progress))
end

-- Function to stop progress indicator (without default success message)
local function stop_progress()
  if progress_timer then
    progress_timer:stop()
    progress_timer = nil
  end
  -- Clear the progress message
  vim.api.nvim_echo({ { "", "Normal" } }, false, {})
end

-- Function to run pnpm scripts
local function run_pnpm_scripts()
  local project_root = find_project_root()

  -- Start progress indicator
  start_progress()

  -- Create a script that runs in background and writes status to a file
  local temp_script = vim.fn.tempname() .. ".sh"
  local temp_log = vim.fn.tempname() .. ".log"
  local status_file = vim.fn.tempname() .. ".status"

  local script_content = string.format(
    [[
#!/bin/bash
cd "%s"

# Redirect all output to log file
exec > "%s" 2>&1

echo "=== Starting pnpm scripts in: %s ==="
echo "=== Running pnpm panda ==="
pnpm panda &
PANDA_PID=$!

echo "=== Running pnpm codegen ==="
pnpm codegen &
CODEGEN_PID=$!

# Wait for both processes to complete
wait $PANDA_PID
PANDA_EXIT=$?
wait $CODEGEN_PID  
CODEGEN_EXIT=$?

echo "=== Process Exit Codes ==="
echo "panda exit code: $PANDA_EXIT"
echo "codegen exit code: $CODEGEN_EXIT"

# Write status to status file
if [ $PANDA_EXIT -eq 0 ] && [ $CODEGEN_EXIT -eq 0 ]; then
  echo "SUCCESS" > "%s"
  echo "SUCCESS"
else
  echo "FAILURE" > "%s"
  echo "FAILURE"
fi
]],
    project_root,
    temp_log,
    project_root,
    status_file,
    status_file
  )

  -- Write the script
  vim.fn.writefile(vim.split(script_content, "\n"), temp_script)
  vim.fn.system("chmod +x " .. temp_script)

  -- Start the script in the background
  vim.fn.system(temp_script .. " &")

  -- Poll for completion by checking the status file
  local check_timer = vim.loop.new_timer()
  check_timer:start(
    500,
    500,
    vim.schedule_wrap(function()
      if vim.fn.filereadable(status_file) == 1 then
        -- Process completed, read the result
        local status = vim.fn.readfile(status_file)[1]
        check_timer:stop()
        stop_progress()

        if status == "SUCCESS" then
          -- Success - just show notification, no terminal
          vim.api.nvim_echo({ { "✅ Successfuly generated Panda styles!", "DiagnosticOk" } }, false, {})
          -- Clean up files on success
          vim.fn.delete(temp_log)
        else
          -- Failure - show error and open terminal with logs
          vim.api.nvim_echo(
            { { "❌ pnpm scripts failed! Check terminal for details.", "DiagnosticError" } },
            false,
            {}
          )

          -- Open terminal with the log output
          vim.cmd("botright split")
          local term_buf = vim.api.nvim_create_buf(false, true)
          local term_win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(term_win, term_buf)

          -- Show the log content in terminal
          vim.fn.termopen('cat "' .. temp_log .. '" && echo "\n--- Press q to close ---" && read', {
            on_exit = function()
              -- Clean up after viewing logs
              vim.fn.delete(temp_log)
            end,
          })

          -- Map 'q' to close the terminal buffer in this window
          vim.api.nvim_buf_set_keymap(term_buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
        end

        -- Clean up temp files
        vim.fn.delete(temp_script)
        vim.fn.delete(status_file)
      end
    end)
  )

  -- Print the directory where scripts are running
  print("🚀 Starting pnpm scripts in: " .. project_root)
end

vim.keymap.set("n", "<leader>cg", run_pnpm_scripts, {
  desc = "Run pnpm panda and pnpm codegen from project root",
  silent = true,
})

-- vim.keymap.set("n", "<leader>cg", function()
--   local run_scripts = require("josean.scripts.plugins.script-runner")
--   run_scripts({ "pnpm panda", "pnpm codegen" })
-- end, {
--   desc = "Generate Panda styles",
--   silent = true,
-- })
--
-- Update current line dependency to latest
vim.keymap.set("n", "<leader>npml", function()
  require("josean.scripts.npm.versions").update_to_latest()
end, { desc = "Update package to latest 📦 🆕" })
