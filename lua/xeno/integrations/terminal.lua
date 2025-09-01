local M = {}
local utils = require("xeno.core.utils")

function M.setup_terminal_colors(colors)
  local is_dark_theme = utils.get_variant() == 1

  if is_dark_theme then
    vim.g.terminal_color_0 = colors.base_900
    vim.g.terminal_color_1 = colors.red
    vim.g.terminal_color_2 = colors.green
    vim.g.terminal_color_3 = colors.yellow
    vim.g.terminal_color_4 = colors.blue
    vim.g.terminal_color_5 = colors.purple
    vim.g.terminal_color_6 = colors.cyan
    vim.g.terminal_color_7 = colors.base_300

    vim.g.terminal_color_8 = colors.base_500
    vim.g.terminal_color_9 = colors.orange
    vim.g.terminal_color_10 = colors.accent_300
    vim.g.terminal_color_11 = colors.accent_200
    vim.g.terminal_color_12 = colors.accent_400
    vim.g.terminal_color_13 = colors.accent_300
    vim.g.terminal_color_14 = colors.accent_200
    vim.g.terminal_color_15 = colors.base_100
  else
    vim.g.terminal_color_0 = colors.base_300
    vim.g.terminal_color_1 = colors.red
    vim.g.terminal_color_2 = colors.green
    vim.g.terminal_color_3 = colors.yellow
    vim.g.terminal_color_4 = colors.blue
    vim.g.terminal_color_5 = colors.purple
    vim.g.terminal_color_6 = colors.cyan
    vim.g.terminal_color_7 = colors.base_900

    vim.g.terminal_color_8 = colors.base_500
    vim.g.terminal_color_9 = colors.orange
    vim.g.terminal_color_10 = colors.accent_300
    vim.g.terminal_color_11 = colors.accent_200
    vim.g.terminal_color_12 = colors.accent_400
    vim.g.terminal_color_13 = colors.accent_300
    vim.g.terminal_color_14 = colors.accent_200
    vim.g.terminal_color_15 = colors.base_100
  end
end

return M
