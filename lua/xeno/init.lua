local api, g, cmd, fn = vim.api, vim.g, vim.cmd, vim.fn

local utils = require("xeno.utils")

local defaults = require("xeno.defaults")
local plugin_highlights = require("xeno.plugins")
local highlight_generator = require("xeno.highlights")

local xeno = {}

-- Store global plugin configuration for new_theme function
xeno._global_config = {}

-- Set global configuration (for use with lazy.nvim opts)
function xeno.config(config)
  xeno._global_config = config or {}
end

local function create_safe_color_table(colors)
  local fallback_colors = {
    base_100 = "#f8f8f2",
    base_200 = "#e6e6e6",
    base_300 = "#cccccc",
    base_400 = "#999999",
    base_500 = "#666666",
    base_600 = "#444444",
    base_700 = "#333333",
    base_800 = "#222222",
    base_900 = "#111111",
    base_950 = "#080808",
    accent_100 = "#7aa2f7",
    accent_200 = "#6699ff",
    accent_300 = "#5588ee",
    accent_400 = "#4477dd",
    accent_500 = "#3366cc",
    accent_600 = "#2255bb",
    accent_700 = "#1144aa",
    accent_800 = "#003399",
    accent_900 = "#002288",
    accent_950 = "#001177",
    red = "#e86671",
    green = "#a9dc76",
    yellow = "#e7c547",
    orange = "#ffa94d",
    blue = "#66b2ff",
    purple = "#a37ee5",
    cyan = "#78dce8",
    bg = "#111111",
    bg_light = "#222222",
    bg_lighter = "#333333",
    bg_dark = "#111111",
    fg = "#cccccc",
    fg_light = "#f8f8f2",
    fg_lighter = "#e6e6e6",
    fg_dark = "#999999",
    accent = "#7aa2f7",
    accent_light = "#6699ff",
    accent_lighter = "#5588ee",
    accent_dark = "#3366cc",
    accent_darker = "#2255bb",
  }

  return setmetatable(colors or {}, {
    __index = function(_, key)
      local fallback = fallback_colors[key]
      if fallback then
        vim.notify(
          "xeno.nvim: Using fallback color for '" .. key .. "' - colorscheme may not be loaded properly",
          vim.log.levels.WARN
        )
        return fallback
      end
      vim.notify("xeno.nvim: Unknown color key '" .. key .. "' - using #000000", vim.log.levels.WARN)
      return "#000000"
    end,
  })
end

-- Initialize with default colors immediately for plugin access
local function initialize_default_colors()
  local default_config = {
    base = "#030303",
    accent = "#7AA2F7",
    variation = 0.0,
    contrast = 0,
  }

  local ok, colors = pcall(generate_palette, default_config)
  if ok then
    return create_safe_color_table(colors)
  else
    return create_safe_color_table({})
  end
end

xeno.colors = initialize_default_colors()

local function generate_color_scale(color, variation, contrast)
  local scale = {}
  local h, s, l = utils.hex2hsl(color)
  if not h or not s or not l then
    h, s, l = 0, 0, 0.5
  end

  local is_dark = utils.get_variant() == 1
  local lightness

  if is_dark then
    lightness = {
      [100] = 0.900,
      [200] = 0.750,
      [300] = 0.650,
      [400] = 0.600,
      [500] = 0.480,
      [600] = 0.280,
      [700] = 0.195,
      [800] = 0.140,
      [900] = 0.115,
      [950] = 0.090,
    }
  else
    lightness = {
      [100] = 0.950,
      [200] = 0.820,
      [300] = 0.760,
      [400] = 0.650,
      [500] = 0.450,
      [600] = 0.350,
      [700] = 0.250,
      [800] = 0.180,
      [900] = 0.040,
      [950] = 0.020,
    }
  end

  -- Apply contrast adjustment to lightness range
  local function apply_contrast(lightness, contrast_factor)
    local mid_point = 0.5
    local distance_from_mid = lightness - mid_point
    -- Positive contrast expands range, negative compresses toward middle
    local adjusted_distance = distance_from_mid * (1 + contrast_factor)
    return mid_point + adjusted_distance
  end

  local function adjust_saturation(level, orig_s, variation_factor)
    local extreme_light = (is_dark and level <= 100) or (not is_dark and level >= 900)
    local extreme_dark = (is_dark and level >= 900) or (not is_dark and level <= 100)

    local base_saturation
    if extreme_light then
      base_saturation = math.max(0, orig_s * 0.8)
    elseif extreme_dark then
      base_saturation = math.max(0, orig_s * 0.7)
    else
      base_saturation = orig_s
    end

    -- Apply variation to saturation - negative variation reduces saturation differences
    local saturation_variation = 1 + (variation_factor * 0.5) -- Scale variation effect
    base_saturation = base_saturation * saturation_variation

    return math.min(1, math.max(0, base_saturation))
  end

  for level, target_lightness in pairs(lightness) do
    local adjusted_lightness
    if level == 500 then
      -- Apply contrast to base level
      adjusted_lightness = apply_contrast(target_lightness, contrast or 0)
    else
      local diff_from_mid = target_lightness - 0.45
      -- Apply both variation and contrast
      local varied_lightness = 0.45 + (diff_from_mid * (variation or 1.0))
      adjusted_lightness = apply_contrast(varied_lightness, contrast or 0)
    end

    adjusted_lightness = math.min(0.98, math.max(0.02, adjusted_lightness))

    local adjusted_s = adjust_saturation(level, s, variation or 1.0)
    scale[level] = utils.hsl2hex(h, adjusted_s, adjusted_lightness)
  end

  return scale
end

local function generate_palette(config)
  local base_color = config.base or config.background or "#030303"
  local accent_color = config.accent or "#7AA2F7"
  local variation = 1.0 + (config.variation or 0.0)
  local contrast = config.contrast or 0

  local base_h, base_s, base_l = utils.hex2hsl(base_color)
  if not base_h or not base_s or not base_l then
    vim.notify("xeno.nvim: Invalid base color '" .. tostring(base_color) .. "', using fallback", vim.log.levels.WARN)
    base_h, base_s, base_l = 0, 0, 0.15
    base_color = "#030303"
  end

  if base_l < 0.05 then
    base_color = utils.hsl2hex(base_h, base_s, 0.15)
  elseif base_l > 0.95 then
    base_color = utils.hsl2hex(base_h, base_s, 0.85)
  end

  local accent_h, accent_s, accent_l = utils.hex2hsl(accent_color)
  if not accent_h or not accent_s or not accent_l then
    vim.notify(
      "xeno.nvim: Invalid accent color '" .. tostring(accent_color) .. "', using fallback",
      vim.log.levels.WARN
    )
    accent_color = "#7AA2F7"
  end

  local base_scale = generate_color_scale(base_color, variation, contrast)
  local accent_scale = generate_color_scale(accent_color, variation, contrast)

  local colors = {}

  for level, color in pairs(base_scale) do
    colors["base_" .. level] = color
  end

  for level, color in pairs(accent_scale) do
    colors["accent_" .. level] = color
  end

  -- Add semantic colors with fallbacks
  colors.red = config.red or "#E86671"
  colors.green = config.green or "#A9DC76"
  colors.yellow = config.yellow or "#E7C547"
  colors.orange = config.orange or "#FFA94D"
  colors.blue = config.blue or "#66B2FF"
  colors.purple = config.purple or "#A37EE5"
  colors.cyan = config.cyan or "#78DCE8"

  -- Create API-friendly aliases using scale system
  local is_dark = utils.get_variant() == 1

  if is_dark then
    -- Dark theme: bg uses darker scales, fg uses lighter scales
    colors.bg = colors.base_900 -- Primary background
    colors.bg_light = colors.base_800
    colors.bg_lighter = colors.base_700
    colors.bg_dark = colors.base_900

    colors.fg = colors.base_300 -- Primary foreground
    colors.fg_light = colors.base_100
    colors.fg_lighter = colors.base_200
    colors.fg_dark = colors.base_400
  else
    -- Light theme: bg uses lighter scales, fg uses darker scales
    colors.bg = colors.base_100 -- Primary background
    colors.bg_light = colors.base_100
    colors.bg_lighter = colors.base_200
    colors.bg_dark = colors.base_300

    colors.fg = colors.base_700 -- Primary foreground
    colors.fg_light = colors.base_600
    colors.fg_lighter = colors.base_500
    colors.fg_dark = colors.base_900
  end

  -- Accent color aliases
  colors.accent = colors.accent_500 -- Main accent color
  colors.accent_light = colors.accent_400
  colors.accent_lighter = colors.accent_300
  colors.accent_dark = colors.accent_600
  colors.accent_darker = colors.accent_700

  return colors
end

function xeno.setup(user_config)
  g.colors_name = "xeno"

  local config = utils.extend("force", defaults.config, user_config or {})

  if config.background and not config.base then
    config.base = config.background
  end

  local ok, colors = pcall(generate_palette, config)
  if not ok then
    vim.notify(
      "xeno.nvim: Error generating color palette: " .. tostring(colors) .. ". Using fallback colors.",
      vim.log.levels.ERROR
    )
    colors = {}
  end

  xeno.colors = create_safe_color_table(colors)

  local is_dark_theme = utils.get_variant() == 1

  if is_dark_theme then
    g.terminal_color_0 = colors.base_900 -- Normal BG (dark)
    g.terminal_color_1 = colors.red
    g.terminal_color_2 = colors.green
    g.terminal_color_3 = colors.yellow
    g.terminal_color_4 = colors.blue
    g.terminal_color_5 = colors.purple
    g.terminal_color_6 = colors.cyan
    g.terminal_color_7 = colors.base_300 -- Normal FG

    g.terminal_color_8 = colors.base_500 -- Medium Grey
    g.terminal_color_9 = colors.orange -- Bright Red
    g.terminal_color_10 = colors.accent_300 -- Bright Green (using accent)
    g.terminal_color_11 = colors.accent_200 -- Bright Yellow (using accent)
    g.terminal_color_12 = colors.accent_400 -- Bright Blue (using accent)
    g.terminal_color_13 = colors.accent_300 -- Bright Magenta (using accent)
    g.terminal_color_14 = colors.accent_200 -- Bright Cyan (using accent)
    g.terminal_color_15 = colors.base_100 -- Brightest FG
  else -- Light Theme
    g.terminal_color_0 = colors.base_300 -- Dark FG (becomes "black" in terminal)
    g.terminal_color_1 = colors.red
    g.terminal_color_2 = colors.green
    g.terminal_color_3 = colors.yellow
    g.terminal_color_4 = colors.blue
    g.terminal_color_5 = colors.purple
    g.terminal_color_6 = colors.cyan
    g.terminal_color_7 = colors.base_900 -- Normal BG (light)

    g.terminal_color_8 = colors.base_500 -- Medium Grey (lighter than FG for contrast)
    g.terminal_color_9 = colors.orange -- Bright Red
    g.terminal_color_10 = colors.accent_300 -- Bright Green (using darker/more saturated accent for light bg)
    g.terminal_color_11 = colors.accent_200 -- Bright Yellow (using darker/more saturated accent)
    g.terminal_color_12 = colors.accent_400 -- Bright Blue (using darker/more saturated accent)
    g.terminal_color_13 = colors.accent_300 -- Bright Magenta (using darker/more saturated accent)
    g.terminal_color_14 = colors.accent_200 -- Bright Cyan (using darker/more saturated accent)
    g.terminal_color_15 = colors.base_100 -- Darkest FG (becomes "bright white" high contrast text)
  end

  local ok_highlights, highlights = pcall(highlight_generator.generate_base_highlights, xeno.colors)
  if not ok_highlights then
    vim.notify(
      "xeno.nvim: Error generating highlights: " .. tostring(highlights) .. ". Using minimal fallback highlights.",
      vim.log.levels.ERROR
    )
    highlights = {
      Normal = { bg = xeno.colors.bg, fg = xeno.colors.fg },
      Comment = { fg = xeno.colors.base_600, italic = true },
      Error = { fg = xeno.colors.red },
    }
  end

  if config.transparent then
    if highlights.Normal then
      highlights.Normal.bg = "NONE"
    end
    if highlights.NormalNC then
      highlights.NormalNC.bg = "NONE"
    end
    if highlights.WinBar then
      highlights.WinBar.bg = "NONE"
    end
    if highlights.WinBarNC then
      highlights.WinBarNC.bg = "NONE"
    end
  end

  for _, plugin_name in ipairs(config.plugins or {}) do
    local plugin_fn = plugin_highlights[plugin_name]
    if plugin_fn then
      local ok_plugin, plugin_hl = pcall(plugin_fn, xeno.colors)
      if ok_plugin and plugin_hl then
        for group, attrs in pairs(plugin_hl) do
          highlights[group] = attrs
        end
      else
        vim.notify(
          "xeno.nvim: Error loading highlights for plugin '" .. plugin_name .. "': " .. tostring(plugin_hl),
          vim.log.levels.WARN
        )
      end
    end
  end

  cmd("highlight clear")
  if fn.exists("syntax_on") then
    cmd("syntax reset")
  end

  for group, attrs in pairs(highlights) do
    if attrs.clear then
      api.nvim_cmd({ cmd = "highlight", args = { "clear", group } }, {})
    end

    attrs.clear = nil

    api.nvim_set_hl(0, group, attrs)
  end

  local xeno_augroup = api.nvim_create_augroup("xeno.nvim", { clear = true })

  api.nvim_create_autocmd({ "ColorScheme" }, {
    callback = function()
      if g.colors_name == "xeno" then
        xeno.setup(user_config)
      end
    end,
    group = xeno_augroup,
  })

  api.nvim_create_autocmd({ "ColorSchemePre" }, {
    callback = function()
      api.nvim_cmd({ cmd = "highlight", args = { "clear" } }, {})
    end,
    group = xeno_augroup,
  })
end

-- Get current colors for plugin integration
function xeno.get_colors()
  return xeno.colors
end

-- Get full palette with all color scales
function xeno.get_palette()
  local palette = {}

  -- Copy all current colors
  for key, value in pairs(xeno.colors) do
    palette[key] = value
  end

  return palette
end

-- Color manipulation utilities for plugins
function xeno.lighten(color, amount)
  return utils.lighten_color(color, amount or 0.1)
end

function xeno.darken(color, amount)
  return utils.darken_color(color, amount or 0.1)
end

function xeno.alpha(color, alpha_value)
  return utils.add_alpha(color, alpha_value or 0.5)
end

-- Get a specific color from the current palette
function xeno.get_color(color_name)
  return xeno.colors[color_name]
end

function xeno.new_theme(name, config)
  local colorscheme_dir = fn.stdpath("config") .. "/colors"
  local colorscheme_path = colorscheme_dir .. "/" .. name .. ".lua"

  fn.mkdir(colorscheme_dir, "p")

  -- Merge global config with theme-specific config
  local user_config = utils.extend("force", xeno._global_config, config or {})

  local content = string.format(
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
    print("Failed to create colorscheme file: " .. colorscheme_path)
  end
end

return xeno
