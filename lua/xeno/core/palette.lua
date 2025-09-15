local M = {}
local utils = require("xeno.core.utils")
local fmt = string.format

-- Configuration constants
local LIGHTNESS_SCALES = {
  dark = {
    [50] = 0.960,
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
  },
  light = {
    [50] = 0.030,
    [100] = 0.100,
    [200] = 0.200,
    [300] = 0.350,
    [400] = 0.400,
    [500] = 0.520,
    [600] = 0.720,
    [700] = 0.805,
    [800] = 0.860,
    [900] = 0.885,
    [950] = 0.910,
  },
}

local SEMANTIC_COLORS = {
  dark = {
    red = "#E86671",
    green = "#A9DC76",
    yellow = "#E7C547",
    orange = "#FFA94D",
    blue = "#66B2FF",
    purple = "#A37EE5",
    cyan = "#78DCE8",
  },
  light = {
    red = "#B71C1C",
    green = "#2E7D32",
    yellow = "#F57C00",
    orange = "#E65100",
    blue = "#1565C0",
    purple = "#6A1B9A",
    cyan = "#0097A7",
  },
}

local DEFAULT_BASE = "#030303"
local DEFAULT_ACCENT = "#7AA2F7"

-- Helper functions
local function clamp(value, min, max)
  return math.min(max, math.max(min, value))
end

local function get_theme_variant()
  return utils.get_variant() == 1 and "dark" or "light"
end

local function parse_color(color, fallback)
  local h, s, l = utils.hex2hsl(color)
  if not h or not s or not l then
    if fallback then
      h, s, l = utils.hex2hsl(fallback)
    end
    h, s, l = h or 0, s or 0, l or 0.5
  end
  return h, s, l
end

local function validate_base_color(h, s, l, theme)
  if l < 0.01 then
    return utils.hsl2hex(h, s, theme == "dark" and 0.05 or 0.03)
  elseif l > 0.99 then
    return utils.hsl2hex(h, s, theme == "dark" and 0.97 or 0.95)
  end
  return utils.hsl2hex(h, s, l)
end

-- Core transformation functions
local function apply_contrast(lightness, contrast, theme)
  local mid_point = theme == "dark" and 0.45 or 0.55
  local distance = lightness - mid_point
  local multiplier = 1 + (contrast * 0.5)
  return clamp(mid_point + (distance * multiplier), 0.02, 0.98)
end

local function apply_variation(level, lightness, saturation, variation)
  -- Only apply variation for syntax colors
  if variation == 0 then
    return saturation, lightness
  end

  local normalized = 1 + variation
  local distance = math.abs(level - 500) / 450

  -- Vary saturation based on distance from middle
  local sat_multiplier = 1 + (distance * normalized * 0.6)
  local new_sat = clamp(saturation * sat_multiplier, 0, 1)

  -- Vary lightness to create spread
  local light_offset = distance * normalized * 0.15 * (level > 500 and 1 or -1)
  local new_light = clamp(lightness + light_offset, 0.02, 0.98)

  return new_sat, new_light
end

-- Check if a color hue is problematic in light mode
local function is_problematic_hue(hue)
  -- Cyan range: ~180-210 degrees
  if hue >= 180 and hue <= 210 then
    return true
  end
  -- Yellow range: ~45-65 degrees
  if hue >= 45 and hue <= 65 then
    return true
  end
  -- Green range: ~90-130 degrees
  if hue >= 90 and hue <= 130 then
    return true
  end
  return false
end

-- Apply light mode contrast improvement for problematic colors
local function improve_light_contrast(hue, saturation, lightness, level)
  if not is_problematic_hue(hue) then
    return saturation, lightness
  end

  -- For problematic colors in light mode, make them darker and more saturated
  -- Focus adjustment on the mid-range levels (400-600) that are most commonly used
  if level >= 400 and level <= 600 then
    -- Reduce lightness significantly for better contrast
    local lightness_reduction = 0.15 + (level - 400) * 0.0005 -- Stronger reduction for higher levels
    lightness = math.max(0.15, lightness - lightness_reduction)

    -- Increase saturation to maintain color identity
    local saturation_boost = math.min(0.15, (1 - saturation) * 0.3)
    saturation = math.min(1.0, saturation + saturation_boost)
  end

  return saturation, lightness
end

-- Apply light mode contrast improvement to semantic colors
local function improve_semantic_color(color, theme)
  if theme ~= "light" then
    return color
  end

  local h, s, l = parse_color(color)
  if not h or not is_problematic_hue(h) then
    return color
  end

  -- Apply similar improvements as level 500 in color scales
  local lightness_reduction = 0.15
  l = math.max(0.15, l - lightness_reduction)

  local saturation_boost = math.min(0.15, (1 - s) * 0.3)
  s = math.min(1.0, s + saturation_boost)

  return utils.hsl2hex(h, s, l)
end

-- Main color scale generator
local function generate_color_scale(color, options)
  options = options or {}
  local h, s, l = parse_color(color)
  local theme = get_theme_variant()
  local lightness_scale = LIGHTNESS_SCALES[theme]
  local scale = {}

  for level, base_lightness in pairs(lightness_scale) do
    -- Apply contrast adjustment
    local adjusted_lightness = apply_contrast(base_lightness, options.contrast or 0, theme)

    -- Apply variation if specified (for syntax colors)
    local final_sat, final_light = s, adjusted_lightness
    if options.with_variation then
      final_sat, final_light = apply_variation(level, adjusted_lightness, s, options.variation or 0)
    end

    -- Apply light mode contrast improvement for problematic colors
    if theme == "light" then
      final_sat, final_light = improve_light_contrast(h, final_sat, final_light, level)
    end

    scale[level] = utils.hsl2hex(h, final_sat, final_light)
  end

  return scale
end

-- Scale generators for different purposes
local function add_scale_to_colors(colors, scale, prefix)
  for level, color in pairs(scale) do
    colors[fmt("%s_%s", prefix, level)] = color
  end
end

function M.generate_palette(config)
  local theme = get_theme_variant()

  -- Parse and validate colors
  local base_color = config.base or config.background or DEFAULT_BASE
  local accent_color = config.accent or DEFAULT_ACCENT
  local variation = config.variation or 0
  local contrast = config.contrast or 0

  -- Validate base color
  local base_h, base_s, base_l = parse_color(base_color, DEFAULT_BASE)
  base_color = validate_base_color(base_h, base_s, base_l, theme)

  -- Validate accent color
  local accent_h, accent_s, accent_l = parse_color(accent_color, DEFAULT_ACCENT)
  if not accent_h then
    accent_color = DEFAULT_ACCENT
  end

  -- Generate scales with shared options
  local scale_options = {
    standard = { contrast = contrast, with_variation = false },
    syntax = { contrast = contrast, with_variation = true, variation = variation },
  }

  -- Generate all color scales
  local scales = {
    { scale = generate_color_scale(base_color, scale_options.standard), prefix = "base" },
    { scale = generate_color_scale(accent_color, scale_options.standard), prefix = "accent" },
    { scale = generate_color_scale(base_color, scale_options.syntax), prefix = "syntax_base" },
    { scale = generate_color_scale(accent_color, scale_options.syntax), prefix = "syntax_accent" },
  }

  -- Build final color palette
  local colors = {}

  -- Add all scales
  for _, scale_data in ipairs(scales) do
    add_scale_to_colors(colors, scale_data.scale, scale_data.prefix)
  end

  -- Add custom color scales (optionally filtered)
  if config._custom_colors then
    local custom_colors_to_include = config._custom_colors

    -- If filtering is specified, only include requested custom colors
    if config._filtered_custom_colors then
      custom_colors_to_include = {}
      for name, _ in pairs(config._filtered_custom_colors) do
        if config._custom_colors[name] then
          custom_colors_to_include[name] = config._custom_colors[name]
        end
      end
    end

    for name, hex_value in pairs(custom_colors_to_include) do
      local custom_scale = generate_color_scale(hex_value, scale_options.standard)
      add_scale_to_colors(colors, custom_scale, name)
    end
  end

  -- Add semantic colors with contrast improvements
  local semantic = SEMANTIC_COLORS[theme]
  for name, default_color in pairs(semantic) do
    local color = config[name] or default_color
    colors[name] = improve_semantic_color(color, theme)
  end

  return colors
end

return M
