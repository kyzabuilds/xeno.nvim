local cwd = vim.fn.getcwd()

vim.opt.runtimepath:append(cwd)
package.path = table.concat({
  cwd .. "/?.lua",
  cwd .. "/?/init.lua",
  package.path,
}, ";")

vim.o.termguicolors = true
vim.o.swapfile = false
vim.o.shada = ""
vim.o.laststatus = 0
