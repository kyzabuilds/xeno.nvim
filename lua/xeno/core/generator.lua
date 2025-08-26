local M = {}
local utils = require("xeno.core.utils")
local fn = vim.fn
local fmt = string.format

function M.new_theme(name, config, global_config)
  local colorscheme_dir = fmt("%s/colors", fn.stdpath("config"))
  local colorscheme_path = fmt("%s/%s.lua", colorscheme_dir, name)

  fn.mkdir(colorscheme_dir, "p")

  local user_config = utils.extend("force", global_config or {}, config or {})

  local content = fmt(
    [=[
require("xeno").setup({
  base = "%s",
  accent = "%s",
  variation = %.1f,
  contrast = %.1f,
  transparent = %s,
})
vim.g.colors_name = "%s"
  ]=],
    user_config.base or user_config.background,
    user_config.accent,
    user_config.variation or 0.0,
    user_config.contrast or 0,
    user_config.transparent and "true" or "false",
    name
  )

  local file = io.open(colorscheme_path, "w")
  if file then
    file:write(content)
    file:close()
  else
    print(fmt("Failed to create colorscheme file: %s", colorscheme_path))
  end
end

return M

