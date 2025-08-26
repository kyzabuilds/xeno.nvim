local M = {}
local utils = require("xeno.core.utils")
local fmt = string.format

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

  local function apply_contrast(lightness, contrast_factor)
    local mid_point = 0.5
    local distance_from_mid = lightness - mid_point
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

    local saturation_variation = 1 + (variation_factor * 0.5)
    base_saturation = base_saturation * saturation_variation

    return math.min(1, math.max(0, base_saturation))
  end

  for level, target_lightness in pairs(lightness) do
    local adjusted_lightness
    if level == 500 then
      adjusted_lightness = apply_contrast(target_lightness, contrast or 0)
    else
      local diff_from_mid = target_lightness - 0.45
      local varied_lightness = 0.45 + (diff_from_mid * (variation or 1.0))
      adjusted_lightness = apply_contrast(varied_lightness, contrast or 0)
    end

    adjusted_lightness = math.min(0.98, math.max(0.02, adjusted_lightness))

    local adjusted_s = adjust_saturation(level, s, variation or 1.0)
    scale[level] = utils.hsl2hex(h, adjusted_s, adjusted_lightness)
  end

  return scale
end

function M.generate_palette(config)
  local base_color = config.base or config.background or "#030303"
  local accent_color = config.accent or "#7AA2F7"
  local variation = 1.0 + (config.variation or 0.0)
  local contrast = config.contrast or 0

  local base_h, base_s, base_l = utils.hex2hsl(base_color)
  if not base_h or not base_s or not base_l then
    vim.notify(fmt("xeno.nvim: Invalid base color '%s', using fallback", tostring(base_color)), vim.log.levels.WARN)
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
    accent_color = "#7AA2F7"
  end

  local base_scale = generate_color_scale(base_color, variation, contrast)
  local accent_scale = generate_color_scale(accent_color, variation, contrast)

  local colors = {}

  for level, color in pairs(base_scale) do
    colors[fmt("base_%s", level)] = color
  end

  for level, color in pairs(accent_scale) do
    colors[fmt("accent_%s", level)] = color
  end

  colors.red = config.red or "#E86671"
  colors.green = config.green or "#A9DC76"
  colors.yellow = config.yellow or "#E7C547"
  colors.orange = config.orange or "#FFA94D"
  colors.blue = config.blue or "#66B2FF"
  colors.purple = config.purple or "#A37EE5"
  colors.cyan = config.cyan or "#78DCE8"

  return colors
end

return M
