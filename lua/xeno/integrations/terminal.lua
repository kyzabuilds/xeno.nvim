local M = {}
local utils = require("xeno.core.utils")

function M.setup_terminal_colors(colors)
  local g = vim.g
  local is_dark_theme = utils.get_variant() == 1

  if is_dark_theme then
    g.terminal_color_0 = colors.base_900
    g.terminal_color_1 = colors.red
    g.terminal_color_2 = colors.green
    g.terminal_color_3 = colors.yellow
    g.terminal_color_4 = colors.blue
    g.terminal_color_5 = colors.purple
    g.terminal_color_6 = colors.cyan
    g.terminal_color_7 = colors.base_300

    g.terminal_color_8 = colors.base_500
    g.terminal_color_9 = colors.orange
    g.terminal_color_10 = colors.accent_300
    g.terminal_color_11 = colors.accent_200
    g.terminal_color_12 = colors.accent_400
    g.terminal_color_13 = colors.accent_300
    g.terminal_color_14 = colors.accent_200
    g.terminal_color_15 = colors.base_100
  else
    g.terminal_color_0 = colors.base_300
    g.terminal_color_1 = colors.red
    g.terminal_color_2 = colors.green
    g.terminal_color_3 = colors.yellow
    g.terminal_color_4 = colors.blue
    g.terminal_color_5 = colors.purple
    g.terminal_color_6 = colors.cyan
    g.terminal_color_7 = colors.base_900

    g.terminal_color_8 = colors.base_500
    g.terminal_color_9 = colors.orange
    g.terminal_color_10 = colors.accent_300
    g.terminal_color_11 = colors.accent_200
    g.terminal_color_12 = colors.accent_400
    g.terminal_color_13 = colors.accent_300
    g.terminal_color_14 = colors.accent_200
    g.terminal_color_15 = colors.base_100
  end
end

return M

