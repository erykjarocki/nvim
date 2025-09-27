local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Utility: walk up directories to find package.json
local function find_package_json(start_dir)
  local dir = start_dir
  local Path_sep = package.config:sub(1, 1) -- "/" on unix, "\" on windows

  while dir and dir ~= "" do
    local candidate = dir .. Path_sep .. "package.json"
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break -- reached root
    end
    dir = parent
  end

  return nil
end

-- Extract scripts
local function get_package_scripts()
  local file_dir = vim.fn.expand("%:p:h")
  local json_path = find_package_json(file_dir)

  if not json_path then
    print("No package.json found upwards from current file")
    return {}, nil
  end

  local content = vim.fn.readfile(json_path)
  local ok, package = pcall(vim.fn.json_decode, table.concat(content, "\n"))
  if not ok or not package.scripts then
    print("No scripts found in " .. json_path)
    return {}, nil
  end

  local results = {}
  for script, _ in pairs(package.scripts) do
    table.insert(results, script)
  end

  return results, vim.fn.fnamemodify(json_path, ":h")
end

local function run_npm_script(opts)
  opts = opts or {}

  local scripts, pkg_dir = get_package_scripts()
  if not scripts or vim.tbl_isempty(scripts) then
    return
  end

  pickers
    .new(opts, {
      prompt_title = "package.json scripts (" .. pkg_dir .. ")",
      finder = finders.new_table({
        results = scripts,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        local run_script = function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            local cmd = "npm run " .. selection[1]
            -- run inside package.json folder
            vim.cmd("split | terminal cd " .. pkg_dir .. " && " .. cmd)
            vim.cmd("resize 15")
          end
        end

        map("i", "<CR>", run_script)
        map("n", "<CR>", run_script)

        return true
      end,
    })
    :find()
end

return run_npm_script
