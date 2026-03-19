local M = {}
local fmt = string.format

local fallback_colors = {
  foreground_50 = "#f8f8f2",
  foreground_100 = "#e6e6e6",
  foreground_200 = "#cccccc",
  foreground_300 = "#999999",
  foreground_400 = "#666666",
  background_500 = "#444444",
  background_600 = "#333333",
  background_700 = "#222222",
  background_800 = "#1a1a1a",
  background_900 = "#111111",
  background_950 = "#080808",
  accent_50 = "#8cb2ff",
  accent_100 = "#7aa2f7",
  accent_200 = "#6699ff",
  accent_300 = "#5588ee",
  accent_400 = "#4477dd",
  accent_500 = "#3366cc",
  accent_600 = "#2255bb",
  red = "#e86671",
  green = "#a9dc76",
  yellow = "#e7c547",
  orange = "#ffa94d",
  blue = "#66b2ff",
  purple = "#a37ee5",
  cyan = "#78dce8",
}

function M.create_safe_color_table(colors)
  return setmetatable(colors or {}, {
    __index = function(_, key)
      local fallback = fallback_colors[key]
      if fallback then
        vim.notify(
          fmt("xeno.nvim: Using fallback color for '%s' - colorscheme may not be loaded properly", key),
          vim.log.levels.WARN
        )
        return fallback
      end
      vim.notify(fmt("xeno.nvim: Unknown color key '%s' - using #000000", key), vim.log.levels.WARN)
      return "#000000"
    end,
  })
end

function M.initialize_default_colors()
  local palette = require("xeno.core.palette")
  local default_config = {
    foreground = nil,
    background = "#030303",
    accent = "#7AA2F7",
    contrast = 0,
  }

  local ok, colors = pcall(palette.generate_palette, default_config)
  if ok then
    return M.create_safe_color_table(colors)
  else
    return M.create_safe_color_table({})
  end
end

return M
