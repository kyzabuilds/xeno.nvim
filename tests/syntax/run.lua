local cwd = vim.fn.getcwd()
vim.opt.runtimepath:append(cwd)
package.path = table.concat({
  cwd .. "/?.lua",
  cwd .. "/?/init.lua",
  package.path,
}, ";")

vim.o.termguicolors = true
require("xeno").setup({})

local detect = require("tests.syntax.detect")

local specs = vim.tbl_filter(function(p)
  local base = vim.fn.fnamemodify(p, ":t:r")
  return base ~= "detect" and base ~= "run"
end, vim.fn.glob(cwd .. "/tests/syntax/*.lua", false, true))
table.sort(specs)

local total = 0
for _, path in ipairs(specs) do
  local name = vim.fn.fnamemodify(path, ":t:r")
  total = total + detect.report(name, dofile(path))
end

print(string.format("TOTAL: %d popping token(s) across %d spec(s)", total, #specs))
