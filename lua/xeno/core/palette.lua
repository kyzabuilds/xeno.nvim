local M = {}
local utils = require("xeno.core.utils")
local fmt = string.format

-- OKLCH Lightness Scales
-- OKLCH lightness is perceptually linear, providing uniform color scale generation
-- Foreground/background families consume different slices of this shared scale.
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
    [50] = 0.14,     -- Very dark (for accents/highlights)
    [100] = 0.18,    -- Dark
    [200] = 0.24,    -- Dark
    [300] = 0.26,    -- Dark (for text)
    [400] = 0.34,    -- Medium-dark
    [500] = 0.50,    -- Neutral (same)
    [600] = 0.62,    -- Medium-light
    [700] = 0.70,    -- Light
    [800] = 0.82,    -- Light
    [900] = 0.93,    -- Very light (for backgrounds)
    [950] = 0.97,    -- Lightest
  },
}

local FAMILY_LEVELS = {
  foreground = { 50, 100, 200, 300, 400 },
  background = { 500, 600, 700, 800, 900, 950 },
  accent = { 50, 100, 200, 300, 400, 500, 600 },
}

local TEXT_BACKGROUND_LEVELS = { 800, 900, 950 }
local FOREGROUND_CONTRAST_MIN = {
  [50] = 9.0,
  [100] = 8.8,
  [200] = 8.0,
  [300] = 6.0,
  [400] = 4.5,
}
local FOREGROUND_HIERARCHY_STEP = 0.015

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

local DEFAULT_BACKGROUND = "#030303"
local DEFAULT_ACCENT = "#7AA2F7"

-- Helper functions
local function clamp(value, min, max)
  return math.min(max, math.max(min, value))
end

local function get_theme_variant()
  return utils.get_variant() == 2 and "light" or "dark"
end

local function adjust_lightness_for_contrast(base_lightness, contrast, theme)
  local adjusted_L = base_lightness

  if contrast and contrast ~= 0 then
    local mid_point = theme == "dark" and 0.45 or 0.55
    local distance = base_lightness - mid_point
    local multiplier = 1 + (contrast * 0.5)
    adjusted_L = clamp(mid_point + (distance * multiplier), 0.02, 0.98)
  end

  return adjusted_L
end

local function collect_text_backgrounds(background_scale)
  local backgrounds = {}

  for _, level in ipairs(TEXT_BACKGROUND_LEVELS) do
    if background_scale[level] then
      table.insert(backgrounds, background_scale[level])
    end
  end

  return backgrounds
end

local function has_required_contrast(candidate, background_colors, minimum_ratio)
  for _, background_color in ipairs(background_colors) do
    local ratio = utils.contrast_ratio(candidate, background_color)
    if not ratio or ratio < minimum_ratio then
      return false
    end
  end

  return true
end

local function resolve_foreground_lightness(theme, base_lightness, chroma, hue, background_colors, minimum_ratio, previous_lightness)
  local lower_bound
  local upper_bound

  if theme == "dark" then
    lower_bound = base_lightness
    upper_bound = previous_lightness and math.min(0.98, previous_lightness - FOREGROUND_HIERARCHY_STEP) or 0.98

    if lower_bound > upper_bound then
      lower_bound = upper_bound
    end

    local lower_candidate = utils.oklch2hex(lower_bound, chroma, hue)
    if has_required_contrast(lower_candidate, background_colors, minimum_ratio) then
      return lower_bound
    end

    local upper_candidate = utils.oklch2hex(upper_bound, chroma, hue)
    if not has_required_contrast(upper_candidate, background_colors, minimum_ratio) then
      return upper_bound
    end

    for _ = 1, 18 do
      local midpoint = (lower_bound + upper_bound) / 2
      local midpoint_candidate = utils.oklch2hex(midpoint, chroma, hue)

      if has_required_contrast(midpoint_candidate, background_colors, minimum_ratio) then
        upper_bound = midpoint
      else
        lower_bound = midpoint
      end
    end

    return upper_bound
  end

  lower_bound = previous_lightness and math.max(0.02, previous_lightness + FOREGROUND_HIERARCHY_STEP) or 0.02
  upper_bound = base_lightness

  if upper_bound < lower_bound then
    upper_bound = lower_bound
  end

  local upper_candidate = utils.oklch2hex(upper_bound, chroma, hue)
  if has_required_contrast(upper_candidate, background_colors, minimum_ratio) then
    return upper_bound
  end

  local lower_candidate = utils.oklch2hex(lower_bound, chroma, hue)
  if not has_required_contrast(lower_candidate, background_colors, minimum_ratio) then
    return lower_bound
  end

  for _ = 1, 18 do
    local midpoint = (lower_bound + upper_bound) / 2
    local midpoint_candidate = utils.oklch2hex(midpoint, chroma, hue)

    if has_required_contrast(midpoint_candidate, background_colors, minimum_ratio) then
      lower_bound = midpoint
    else
      upper_bound = midpoint
    end
  end

  return lower_bound
end



-- OKLCH color scale generator
-- OKLCH lightness is perceptually linear, providing uniform color scales
local function generate_color_scale_oklch(color, options, levels)
  options = options or {}
  levels = levels or FAMILY_LEVELS.accent
  local theme = get_theme_variant()
  local lightness_scale = OKLCH_LIGHTNESS_SCALES[theme]
  local scale = {}

  -- Convert input color to OKLCH (preserves hue and chroma)
  local L_input, C_input, H = utils.hex2oklch(color)
  if not L_input then
    -- Fallback to white/black if conversion fails
    return {}
  end

  for _, level in ipairs(levels) do
    local base_lightness = lightness_scale[level]
    local adjusted_L = adjust_lightness_for_contrast(base_lightness, options.contrast, theme)

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
local function generate_color_scale(color, options, levels)
  return generate_color_scale_oklch(color, options, levels)
end

local function generate_foreground_scale(color, background_scale, options)
  options = options or {}
  local variation = options.variation or 0

  local theme = get_theme_variant()
  local lightness_scale = OKLCH_LIGHTNESS_SCALES[theme]
  local scale = {}
  local background_colors = collect_text_backgrounds(background_scale)
  local L_input, C_input, H = utils.hex2oklch(color)

  if not L_input then
    return {}
  end

  local foreground_contrast = -(options.contrast or 0) * 0.35
  local previous_lightness = nil

  for _, level in ipairs(FAMILY_LEVELS.foreground) do
    local base_L = lightness_scale[level]
    -- Apply variation
    local mid_point = theme == "dark" and 0.45 or 0.55
    local distance = base_L - mid_point
    local multiplier = 1 - (variation * 1.5)
    local adjusted_L = clamp(mid_point + (distance * multiplier), 0.005, 0.98)
    
    local base_lightness = adjust_lightness_for_contrast(adjusted_L, foreground_contrast, theme)
    
    local resolved_lightness = resolve_foreground_lightness(
      theme,
      base_lightness,
      C_input,
      H,
      background_colors,
      FOREGROUND_CONTRAST_MIN[level],
      previous_lightness
    )

    scale[level] = utils.oklch2hex(resolved_lightness, C_input, H)
    previous_lightness = resolved_lightness
  end

  return scale
end

local function resolve_foreground_seed(config, background_color)
  if config.foreground ~= nil then
    local L = utils.hex2oklch(config.foreground)
    if L then
      return config.foreground
    end
  end

  return background_color
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
  local background_color = config.background or DEFAULT_BACKGROUND
  local accent_color = config.accent or DEFAULT_ACCENT
  local contrast = config.contrast or 0

  -- Validate background color
  local L, C, H = utils.hex2oklch(background_color)
  if not L then
    background_color = DEFAULT_BACKGROUND
  end

  -- Validate accent color
  L, C, H = utils.hex2oklch(accent_color)
  if not L then
    accent_color = DEFAULT_ACCENT
  end

  -- Foreground defaults to the background seed so its shades stay coupled to
  -- the active surface hue/chroma. An explicit foreground keeps override behavior.
  local foreground_color = resolve_foreground_seed(config, background_color)

  -- Generate scales with shared options
  local scale_options = {
    standard = { contrast = contrast, variation = config.variation },
  }

  -- Generate all color scales
  local background_scale = generate_color_scale(background_color, scale_options.standard, FAMILY_LEVELS.background)
  local foreground_scale = generate_foreground_scale(foreground_color, background_scale, scale_options.standard)
  local accent_scale = generate_color_scale(accent_color, scale_options.standard, FAMILY_LEVELS.accent)

  local scales = {
    { scale = foreground_scale, prefix = "foreground" },
    { scale = background_scale, prefix = "background" },
    { scale = accent_scale, prefix = "accent" },
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
      local custom_scale = generate_color_scale(hex_value, scale_options.standard, FAMILY_LEVELS.accent)
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
