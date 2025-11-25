local M = {}
local utils = require("xeno.core.utils")
local fmt = string.format

-- OKLCH Lightness Scales
-- OKLCH lightness is perceptually linear, providing uniform color scale generation
-- NOTE: Both dark and light variants use the same scale direction:
-- Level 50 = lightest, Level 900 = darkest (consistent with Tailwind's naming)
local OKLCH_LIGHTNESS_SCALES = {
  dark = {
    [50] = 0.97,
    [100] = 0.93,
    [200] = 0.82,
    [300] = 0.70,
    [400] = 0.62,
    [500] = 0.50,
    [600] = 0.34,
    [700] = 0.26,
    [800] = 0.24,
    [900] = 0.18,
    [950] = 0.14,
  },
  light = {
    [50] = 0.93,     -- Light (was 0.03, inverted)
    [100] = 0.88,    -- Light (was 0.10, inverted)
    [200] = 0.82,    -- Light (was 0.20, inverted)
    [300] = 0.67,    -- Light-medium (was 0.35, inverted)
    [400] = 0.60,    -- Medium (was 0.42, inverted)
    [500] = 0.50,    -- Neutral (same)
    [600] = 0.42,    -- Medium-dark (was 0.60, inverted)
    [700] = 0.35,    -- Dark (was 0.67, inverted)
    [800] = 0.20,    -- Dark (was 0.80, inverted)
    [900] = 0.10,    -- Very dark (was 0.88, inverted)
    [950] = 0.03,    -- Darkest (was 0.93, inverted)
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



-- OKLCH color scale generator
-- OKLCH lightness is perceptually linear, providing uniform color scales
local function generate_color_scale_oklch(color, options)
  options = options or {}
  local theme = get_theme_variant()
  local lightness_scale = OKLCH_LIGHTNESS_SCALES[theme]
  local scale = {}

  -- Convert input color to OKLCH (preserves hue and chroma)
  local L_input, C_input, H = utils.hex2oklch(color)
  if not L_input then
    -- Fallback to white/black if conversion fails
    return {}
  end

  for level, base_lightness in pairs(lightness_scale) do
    -- Apply contrast adjustment if specified
    local adjusted_L = base_lightness
    if options.contrast and options.contrast ~= 0 then
      local mid_point = theme == "dark" and 0.45 or 0.55
      local distance = base_lightness - mid_point
      local multiplier = 1 + (options.contrast * 0.5)
      adjusted_L = clamp(mid_point + (distance * multiplier), 0.02, 0.98)
    end

    -- Use input color's chroma and hue, only adjust lightness
    -- OKLCH naturally handles all hues uniformly, no need for special cases
    scale[level] = utils.oklch2hex(adjusted_L, C_input, H)
  end

  return scale
end

-- Apply semantic color (OKLCH handles all hues naturally)
local function improve_semantic_color(color, theme)
  -- OKLCH handles all hues naturally, no workarounds needed
  -- Just return the color as-is
  return color
end

-- Rename the OKLCH generator to be the main generator
local function generate_color_scale(color, options)
  return generate_color_scale_oklch(color, options)
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

  -- Validate base color (check it converts to OKLCH properly)
  local L, C, H = utils.hex2oklch(base_color)
  if not L then
    base_color = DEFAULT_BASE
  end

  -- Validate accent color
  L, C, H = utils.hex2oklch(accent_color)
  if not L then
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

  -- Add semantic colors
  local semantic = SEMANTIC_COLORS[theme]
  for name, default_color in pairs(semantic) do
    local color = config[name] or default_color
    colors[name] = improve_semantic_color(color, theme)
  end

  return colors
end

return M
