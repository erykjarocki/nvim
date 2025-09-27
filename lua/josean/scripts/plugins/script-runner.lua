-- Function to find nearest project root (with package.json)
local function find_project_root()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.fnamemodify(current_file, ":h")

  while current_dir ~= "/" do
    if vim.fn.filereadable(current_dir .. "/package.json") == 1 then
      return current_dir
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return vim.fn.getcwd()
end

-- Progress animation
local progress_timer = nil
local progress_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" } -- fallback
local progress_index = 1

local function show_progress(message)
  progress_index = (progress_index % #progress_frames) + 1
  vim.api.nvim_echo({
    { progress_frames[progress_index] .. " " .. (message or "Working..."), "DiagnosticInfo" },
  }, false, {})
end

local function start_progress(message)
  if progress_timer then
    progress_timer:stop()
  end
  progress_timer = vim.loop.new_timer()
  progress_timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      show_progress(message)
    end)
  )
end

local function stop_progress()
  if progress_timer then
    progress_timer:stop()
    progress_timer = nil
  end
  vim.api.nvim_echo({ { "", "Normal" } }, false, {})
end

-- Generic reusable runner
local function run_commands(commands, opts)
  opts = opts or {}
  local project_root = find_project_root()
  local temp_script = vim.fn.tempname() .. ".sh"
  local temp_log = vim.fn.tempname() .. ".log"
  local status_file = vim.fn.tempname() .. ".status"

  -- Build script contents dynamically
  local script_lines = {
    "#!/bin/bash",
    'cd "' .. project_root .. '"',
    'exec > "' .. temp_log .. '" 2>&1',
    "echo '=== Starting in " .. project_root .. " ==='",
  }

  local ids = {}
  for i, cmd in ipairs(commands) do
    table.insert(script_lines, "echo '=== Running: " .. cmd .. " ==='")
    table.insert(script_lines, cmd .. " &")
    table.insert(script_lines, "PID" .. i .. "=$!")
    table.insert(ids, "PID" .. i)
  end

  for i, pid in ipairs(ids) do
    table.insert(script_lines, "wait $" .. pid)
    table.insert(script_lines, "STATUS" .. i .. "=$?")
  end

  table.insert(script_lines, "EXIT=0")
  for i, _ in ipairs(ids) do
    table.insert(script_lines, "if [ $STATUS" .. i .. " -ne 0 ]; then EXIT=1; fi")
  end

  table.insert(
    script_lines,
    'if [ $EXIT -eq 0 ]; then echo "SUCCESS" > "'
      .. status_file
      .. '"; else echo "FAILURE" > "'
      .. status_file
      .. '"; fi'
  )

  vim.fn.writefile(script_lines, temp_script)
  vim.fn.system("chmod +x " .. temp_script)
  vim.fn.system(temp_script .. " &")

  -- Start progress animation
  start_progress("Running commands...")

  local check_timer = vim.loop.new_timer()
  check_timer:start(
    500,
    500,
    vim.schedule_wrap(function()
      if vim.fn.filereadable(status_file) == 1 then
        local status = vim.fn.readfile(status_file)[1]
        check_timer:stop()
        stop_progress()

        if status == "SUCCESS" then
          vim.api.nvim_echo(
            { { "✅ Successfully ran: " .. table.concat(commands, " && "), "DiagnosticOk" } },
            false,
            {}
          )
          vim.fn.delete(temp_log)
        else
          vim.api.nvim_echo({ { "❌ Command(s) failed! Opening logs...", "DiagnosticError" } }, false, {})

          vim.cmd("botright split")
          local term_buf = vim.api.nvim_create_buf(false, true)
          local term_win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(term_win, term_buf)
          vim.fn.termopen('cat "' .. temp_log .. '" && echo "\n--- Press q to close ---" && read', {
            on_exit = function()
              vim.fn.delete(temp_log)
            end,
          })
          vim.api.nvim_buf_set_keymap(term_buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
        end

        vim.fn.delete(temp_script)
        vim.fn.delete(status_file)
      end
    end)
  )

  print("🚀 Running in: " .. project_root .. " -> " .. table.concat(commands, " && "))
end

return run_commands
