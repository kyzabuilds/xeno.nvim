local helpers = require("tests.helpers")

local M = {}

local function spec_files()
  local root = vim.fn.getcwd()
  local files = vim.fn.glob(root .. "/tests/**/*_spec.lua", false, true)
  table.sort(files)
  return files
end

function M.run()
  for _, file in ipairs(spec_files()) do
    dofile(file)
  end

  local failures = {}

  for _, case in ipairs(helpers.cases) do
    local ok, err = xpcall(case.fn, debug.traceback)

    if ok then
      print("PASS " .. case.name)
    else
      print("FAIL " .. case.name)
      print(err)
      table.insert(failures, case.name)
    end
  end

  print(string.format("Summary: %d passed, %d failed", #helpers.cases - #failures, #failures))

  if #failures > 0 then
    vim.cmd("cquit " .. #failures)
    return
  end

  vim.cmd("qa")
end

return M
