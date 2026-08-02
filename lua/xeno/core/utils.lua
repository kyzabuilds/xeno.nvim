local utils = {}
local fmt = string.format

-- Constants for theme variants
local THEME_DARK = 1
local THEME_LIGHT = 2

-- Simple debug logging utility
local function log_warn(message)
  vim.notify(fmt("xeno.nvim utils: %s", message), vim.log.levels.WARN)
end

--- Get the current theme variant.
--- @param variant? string Optional explicit variant ("light" or "dark").
--- @return number Returns THEME_LIGHT (2) for light, THEME_DARK (1) for dark.
utils.get_variant = function(variant)
  if variant then
    return variant == "light" and THEME_LIGHT or THEME_DARK
  end
  -- Neovim's 'background' option indicates the theme type
  return vim.o.background == "light" and THEME_LIGHT or THEME_DARK
end

--- Merge tables deeply. Creates a new table.
--- @param method string Merge strategy ("error", "force", "keep").
--- @param t1 table The base table.
--- @param t2 table The table to merge into t1.
--- @return table The new merged table.
utils.extend = function(method, t1, t2)
  return vim.tbl_deep_extend(method or "force", {}, vim.deepcopy(t1 or {}), vim.deepcopy(t2 or {}))
end

-- Accepted bounds for the `min_contrast` option. 1.0 is "no contrast at all"
-- (identical colors) and 21.0 is the WCAG maximum (pure black on pure white).
utils.MIN_CONTRAST_LOWER = 1.0
utils.MIN_CONTRAST_UPPER = 21.0

--- Validate the optional `min_contrast` option.
--- Non-numeric input is ignored (feature stays off); out-of-range numbers are
--- clamped into [1.0, 21.0]. Both cases warn, matching the rest of this module.
--- @param value any Raw config value.
--- @return number? ratio A usable ratio, or nil when the option is unset/invalid.
utils.normalize_min_contrast = function(value)
  if value == nil then
    return nil
  end

  -- The `value ~= value` guard rejects NaN, which would silently poison every
  -- downstream comparison in the contrast search.
  if type(value) ~= "number" or value ~= value then
    log_warn(fmt("min_contrast: expected a number in [%.1f, %.1f], got %s. Ignoring.", utils.MIN_CONTRAST_LOWER, utils.MIN_CONTRAST_UPPER, vim.inspect(value)))
    return nil
  end

  if value < utils.MIN_CONTRAST_LOWER or value > utils.MIN_CONTRAST_UPPER then
    local clamped = math.min(utils.MIN_CONTRAST_UPPER, math.max(utils.MIN_CONTRAST_LOWER, value))
    log_warn(fmt("min_contrast: %s is outside [%.1f, %.1f]. Clamping to %.1f.", value, utils.MIN_CONTRAST_LOWER, utils.MIN_CONTRAST_UPPER, clamped))
    return clamped
  end

  return value
end

--- Theme knobs live under a `properties` table in the public API. Lift them into
--- flat top-level config fields so downstream palette code reads them uniformly.
--- Flat fields stay supported as a fallback for backward compatibility.
--- @param config table The config to normalize in place.
--- @return table config The same table, with knobs flattened.
utils.normalize_properties = function(config)
  if type(config) ~= "table" then
    return config
  end

  if type(config.properties) == "table" then
    for _, key in ipairs({ "contrast", "chroma", "lightness", "variation" }) do
      if config.properties[key] ~= nil then
        config[key] = config.properties[key]
      end
    end
  end

  -- `min_contrast` is a top-level setup option, not a `properties` knob: the
  -- knobs are relative nudges, this is an absolute floor. Validated here rather
  -- than at read time so a bad value warns once, at the config boundary.
  config.min_contrast = utils.normalize_min_contrast(config.min_contrast)

  return config
end

--- Convert a hex color string to RGB values.
--- @param hex string The hex color string (e.g., "#RRGGBB", "RRGGBB", "#RGB", "RGB").
--- @return number? r Red component (0-255) or nil on failure.
--- @return number? g Green component (0-255) or nil on failure.
--- @return number? b Blue component (0-255) or nil on failure.
utils.hex2rgb = function(hex)
  if type(hex) ~= "string" then
    return nil, nil, nil
  end

  local r_hex, g_hex, b_hex
  -- Try to match 6-digit hex (e.g., #RRGGBB or RRGGBB)
  local six_digit_match = { hex:match("^#?(%x%x)(%x%x)(%x%x)$") }
  if #six_digit_match == 3 then
    r_hex, g_hex, b_hex = six_digit_match[1], six_digit_match[2], six_digit_match[3]
  else
    -- Try to match 3-digit shorthand hex (e.g., #RGB or RGB)
    local three_digit_match = { hex:match("^#?(%x)(%x)(%x)$") }
    if #three_digit_match == 3 then
      local r_short, g_short, b_short = three_digit_match[1], three_digit_match[2], three_digit_match[3]
      r_hex = fmt("%s%s", r_short, r_short)
      g_hex = fmt("%s%s", g_short, g_short)
      b_hex = fmt("%s%s", b_short, b_short)
    else
      log_warn(fmt("hex2rgb: Invalid hex format: %s", hex))
      return nil, nil, nil -- Invalid hex format
    end
  end

  local r, g, b = tonumber(r_hex, 16), tonumber(g_hex, 16), tonumber(b_hex, 16)
  if not r or not g or not b then
    -- This case should ideally not be reached if regex matched valid hex chars
    log_warn(fmt("hex2rgb: Failed to convert hex components to numbers: %s", hex))
    return nil, nil, nil
  end

  return r, g, b
end

--- Convert RGB values to a hex color string.
--- @param r number Red component (0-255).
--- @param g number Green component (0-255).
--- @param b number Blue component (0-255).
--- @return string Hex color string (e.g., "#RRGGBB"). Defaults to "#000000" if components are nil.
utils.rgb2hex = function(r, g, b)
  if r == nil or g == nil or b == nil then
    log_warn("rgb2hex: Received nil RGB component. Defaulting to black.")
    return "#000000"
  end
  -- Ensure values are integers before formatting
  return fmt("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b))
end

--- Clamp RGB values to the valid range of 0-255.
--- @param r number Red component.
--- @param g number Green component.
--- @param b number Blue component.
--- @return number r_clamped Clamped red component (0-255).
--- @return number g_clamped Clamped green component (0-255).
--- @return number b_clamped Clamped blue component (0-255).
utils.rgb_clamp = function(r, g, b)
  if r == nil or g == nil or b == nil then
    log_warn("rgb_clamp: Received nil RGB component for clamping. Defaulting to 0,0,0.")
    return 0, 0, 0
  end
  r = math.min(255, math.max(0, r))
  g = math.min(255, math.max(0, g))
  b = math.min(255, math.max(0, b))
  return r, g, b
end

--- Blend a color with a background color based on opacity.
--- This is a simplified version that focuses on reliable color blending.
--- @param fg_color string The foreground hex color (e.g., "#RRGGBB")
--- @param opacity number From 0.0 (fully transparent) to 1.0 (fully opaque)
--- @param bg_color? string Optional background hex color. If not provided, derives from Normal background
--- @param colors? table Optional colors table to derive background from
--- @return string The blended hex color string
utils.opaque = function(fg_color, opacity, bg_color, colors)
  colors = colors or require("xeno").colors
  local resolver = require("xeno.core.resolver")

  -- Resolve @color.level references, with on-demand scale generation for custom
  -- colors that aren't in xeno.colors yet (e.g. registered after setup()).
  -- Uses current vim.o.background so light/dark variant is always correct.
  local function resolve_with_custom_fallback(ref)
    local resolved = resolver.resolve_value(ref, colors)
    if not resolver.is_color_reference(resolved) then
      return resolved
    end
    -- Resolution failed — check if it's a registered custom color family
    local family = ref:match("^@([%w_]+)%.") or ref:match("^@([%w_]+)$")
    local xeno_mod = require("xeno")
    local custom_hex = xeno_mod._custom_colors and xeno_mod._custom_colors[family]
    if custom_hex then
      local cfg = xeno_mod._global_config or {}
      -- Reuse the already-generated background surfaces so this on-demand scale
      -- gets the same contrast floor as one built during generate_palette().
      local background_scale = {
        [800] = colors.background_800,
        [900] = colors.background_900,
        [950] = colors.background_950,
      }
      local scale = require("xeno.core.palette").generate_custom_scale(custom_hex, family, {
        contrast     = cfg.contrast,
        chroma       = cfg.chroma or 0,
        lightness    = cfg.lightness or 0,
        variation    = cfg.variation,
        min_contrast = cfg.min_contrast,
      }, background_scale)
      for k, v in pairs(scale) do
        colors[k] = v
      end
      resolved = resolver.resolve_value(ref, colors)
    end
    return resolved
  end

  if type(fg_color) == "string" and resolver.is_color_reference(fg_color) then
    local resolved = resolve_with_custom_fallback(fg_color)
    if resolver.is_color_reference(resolved) then
      log_warn(fmt("utils.opaque: Could not resolve color reference '%s'", fg_color))
      return "#000000"
    end
    fg_color = resolved
  end
  if type(bg_color) == "string" and resolver.is_color_reference(bg_color) then
    local resolved = resolve_with_custom_fallback(bg_color)
    if not resolver.is_color_reference(resolved) then
      bg_color = resolved
    end
    -- on failure, fall through to normal bg derivation
  end

  -- Validate inputs
  if type(fg_color) ~= "string" then
    log_warn("utils.opaque: fg_color must be a hex string")
    return "#000000"
  end

  if type(opacity) ~= "number" or opacity < 0 or opacity > 1 then
    log_warn("utils.opaque: opacity must be a number between 0.0 and 1.0")
    opacity = 0.5
  end

  -- Get foreground RGB values
  local r_fg, g_fg, b_fg = utils.hex2rgb(fg_color)
  if not r_fg then
    log_warn(fmt("utils.opaque: Invalid foreground color: %s", fg_color))
    return fg_color
  end

  -- Get background RGB values
  local r_bg, g_bg, b_bg

  if bg_color then
    -- Use provided background color
    r_bg, g_bg, b_bg = utils.hex2rgb(bg_color)
    if not r_bg then
      log_warn(fmt("utils.opaque: Invalid background color: %s. Using theme default.", bg_color))
      bg_color = nil
    end
  end

  if not bg_color then
    -- Try to derive from colors table first (preferred method)
    if colors and colors.background_950 then
      r_bg, g_bg, b_bg = utils.hex2rgb(colors.background_950)
    end

    -- Fallback: try to get Normal background color from applied highlights
    if not r_bg then
      local ok, normal_hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal", link = false })
      if ok and normal_hl and normal_hl.bg then
        local bg_hex = fmt("#%06x", normal_hl.bg)
        r_bg, g_bg, b_bg = utils.hex2rgb(bg_hex)
      end
    end

    -- Final fallback to theme-appropriate background
    if not r_bg then
      if utils.get_variant() == THEME_LIGHT then
        r_bg, g_bg, b_bg = 255, 255, 255 -- White for light themes
      else
        r_bg, g_bg, b_bg = 17, 17, 17 -- Very dark gray for dark themes
      end
    end
  end

  -- Simple linear interpolation between background and foreground
  local r = r_bg + (r_fg - r_bg) * opacity
  local g = g_bg + (g_fg - g_bg) * opacity
  local b = b_bg + (b_fg - b_bg) * opacity

  -- Apply a subtle minimum opacity boost for very low values to ensure visibility
  -- This helps maintain legibility without complex contrast calculations
  if opacity < 0.15 and opacity > 0 then
    local boost = 0.15 - opacity
    r = r + (r_fg - r_bg) * boost * 0.5
    g = g + (g_fg - g_bg) * boost * 0.5
    b = b + (b_fg - b_bg) * boost * 0.5
  end

  -- Clamp and convert to hex
  r, g, b = utils.rgb_clamp(r, g, b)
  local result = utils.rgb2hex(r, g, b)

  -- Register the opaque color if export mode is active
  local ok, opaque_registry = pcall(require, "xeno.core.opaque_registry")
  if ok and opaque_registry.is_export_mode() then
    -- Find the color name for the fg_color by searching the colors table
    local fg_color_name = nil
    if colors then
      for name, hex in pairs(colors) do
        if type(hex) == "string" and hex:upper() == fg_color:upper() then
          fg_color_name = name
          break
        end
      end
    end
    local registered_name = opaque_registry.register_opaque_call(fg_color, opacity, bg_color, result, colors, nil, fg_color_name)
    if registered_name then
      return "@" .. registered_name
    end
  end

  return result
end

--- Adjust the lightness of a hex color.
--- @param hex string The hex color string.
--- @param amount number The amount to adjust lightness by (e.g., 20 for lighter, -20 for darker).
---                    RGB components are directly incremented/decremented by this amount.
--- @return string The new hex color string, or the original hex if input was invalid.
utils.adjust_lightness = function(hex, amount)
  local r, g, b = utils.hex2rgb(hex)
  if not r then
    return hex -- Return original if invalid hex
  end

  r = r + amount
  g = g + amount
  b = b + amount

  r, g, b = utils.rgb_clamp(r, g, b)
  return utils.rgb2hex(r, g, b)
end


-- OKLCH Color Space Conversion Functions
-- Reference: Part 3 of OKLCH_MIGRATION_ANALYSIS.md
-- OKLCH is a perceptually uniform color space ideal for generating color palettes

--- Apply inverse sRGB gamma correction (normalize RGB to linear RGB).
--- @param r number Red component in [0, 255].
--- @param g number Green component in [0, 255].
--- @param b number Blue component in [0, 255].
--- @return number Linear red [0, 1].
--- @return number Linear green [0, 1].
--- @return number Linear blue [0, 1].
utils.rgb2linear_rgb = function(r, g, b)
  -- Normalize to [0, 1]
  local norm_r = r / 255
  local norm_g = g / 255
  local norm_b = b / 255

  -- Apply inverse sRGB companding function (EOTF)
  local function apply_inverse_gamma(value)
    if value <= 0.04045 then
      return value / 12.92
    else
      return math.pow((value + 0.055) / 1.055, 2.4)
    end
  end

  return apply_inverse_gamma(norm_r), apply_inverse_gamma(norm_g), apply_inverse_gamma(norm_b)
end

--- Calculate WCAG relative luminance for a hex color.
--- @param hex string Hex color string.
--- @return number? luminance Relative luminance in [0, 1], or nil on invalid input.
utils.relative_luminance = function(hex)
  local r, g, b = utils.hex2rgb(hex)
  if not r then
    return nil
  end

  r, g, b = utils.rgb2linear_rgb(r, g, b)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- Calculate WCAG contrast ratio between two hex colors.
--- @param first string Hex color string.
--- @param second string Hex color string.
--- @return number? ratio Contrast ratio, or nil when either color is invalid.
utils.contrast_ratio = function(first, second)
  local first_luminance = utils.relative_luminance(first)
  local second_luminance = utils.relative_luminance(second)

  if first_luminance == nil or second_luminance == nil then
    return nil
  end

  local lighter = math.max(first_luminance, second_luminance)
  local darker = math.min(first_luminance, second_luminance)
  return (lighter + 0.05) / (darker + 0.05)
end

--- Convert linear RGB to OKLab color space.
--- Uses matrix transformations with cube roots.
--- @param r number Linear red [0, 1].
--- @param g number Linear green [0, 1].
--- @param b number Linear blue [0, 1].
--- @return number L OKLab lightness [0, 1].
--- @return number a OKLab a component (green-red axis).
--- @return number b OKLab b component (blue-yellow axis).
utils.linear_rgb2oklab = function(r, g, b)
  -- Step 1: Convert linear RGB to LMS cone response space
  local l = 0.3 * r + 0.622 * g + 0.078 * b
  local m = 0.23 * r + 0.692 * g + 0.078 * b
  local s = 0.24342268924547819 * r + 0.20476744424496821 * g + 0.55356137790893145 * b

  -- Step 2: Apply nonlinearity (cube root)
  local l_ = l > 0 and math.pow(l, 1 / 3) or 0
  local m_ = m > 0 and math.pow(m, 1 / 3) or 0
  local s_ = s > 0 and math.pow(s, 1 / 3) or 0

  -- Step 3: Linear combination to get OKLab values
  local L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_
  local a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_
  local b_out = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_

  return L, a, b_out
end

--- Convert OKLab to OKLCH (Cartesian to polar coordinates).
--- @param L number OKLab lightness [0, 1].
--- @param a number OKLab a component.
--- @param b number OKLab b component.
--- @return number L Lightness [0, 1].
--- @return number C Chroma [0, 0.4+].
--- @return number H Hue [0, 360) degrees.
utils.oklab2oklch = function(L, a, b)
  local C = math.sqrt(a * a + b * b)
  local H = math.atan2(b, a) * (180 / math.pi)
  if H < 0 then
    H = H + 360
  end
  return L, C, H
end

--- Convert OKLCH to OKLab (polar to Cartesian coordinates).
--- @param L number Lightness [0, 1].
--- @param C number Chroma [0, 0.4+].
--- @param H number Hue [0, 360) degrees.
--- @return number L Lightness [0, 1].
--- @return number a OKLab a component.
--- @return number b OKLab b component.
utils.oklch2oklab = function(L, C, H)
  local H_rad = H * (math.pi / 180)
  local a = C * math.cos(H_rad)
  local b = C * math.sin(H_rad)
  return L, a, b
end

--- Convert OKLab to linear RGB (inverse of linear_rgb2oklab).
--- @param L number OKLab lightness [0, 1].
--- @param a number OKLab a component.
--- @param b number OKLab b component.
--- @return number r Linear red [0, 1].
--- @return number g Linear green [0, 1].
--- @return number b_out Linear blue [0, 1].
utils.oklab2linear_rgb = function(L, a, b)
  -- Step 1: Reverse OKLab → LMS' (inverse linear combination)
  local l_ = L + 0.3963377774 * a + 0.2158037573 * b
  local m_ = L - 0.1055613458 * a - 0.0638541728 * b
  local s_ = L - 0.0894841775 * a - 1.2914855480 * b

  -- Step 2: Reverse nonlinearity (cube: reverse the cube root)
  local l = l_ * l_ * l_
  local m = m_ * m_ * m_
  local s = s_ * s_ * s_

  -- Step 3: Inverse matrix to get linear RGB (LMS → Linear RGB)
  -- This is the mathematical inverse of the RGB → LMS matrix
  local r = 11.0305154984 * l - 9.8661643235 * m - 0.1640638153 * s
  local g = -3.2551987873 * l + 4.4195499622 * m - 0.1640638153 * s
  local b_out = -3.6464231263 * l + 2.7037079562 * m + 1.9393184317 * s

  return r, g, b_out
end

--- Apply sRGB gamma correction (linear RGB to RGB).
--- @param value number Linear value [0, 1].
--- @return number Gamma-corrected value [0, 1].
utils.linear2rgb = function(value)
  -- Apply sRGB companding function
  if value <= 0.0031308 then
    return value * 12.92
  else
    return 1.055 * math.pow(value, 1 / 2.4) - 0.055
  end
end

--- Convert hex color to OKLCH color space.
--- Complete pipeline: Hex → RGB → Linear RGB → OKLab → OKLCH
--- @param hex string Hex color string (e.g., "#5B8DEF").
--- @return number? L Lightness [0, 1] or nil on failure.
--- @return number? C Chroma [0, 0.4+] or nil on failure.
--- @return number? H Hue [0, 360) or nil on failure.
utils.hex2oklch = function(hex)
  -- Hex → RGB
  local r, g, b = utils.hex2rgb(hex)
  if not r then
    return nil, nil, nil
  end

  -- RGB → Linear RGB
  r, g, b = utils.rgb2linear_rgb(r, g, b)

  -- Linear RGB → OKLab
  local L, a, b_lab = utils.linear_rgb2oklab(r, g, b)

  -- OKLab → OKLCH
  local C, H
  L, C, H = utils.oklab2oklch(L, a, b_lab)

  return L, C, H
end

--- Convert OKLCH lightness/chroma/hue to linear sRGB, without gamma correction
--- or gamut clamping. Used internally to probe whether a color is in gamut.
--- @param L number Lightness [0, 1].
--- @param C number Chroma [0, 0.4+].
--- @param H number Hue [0, 360) degrees.
--- @return number r Linear red (may be outside [0, 1] if out of gamut).
--- @return number g Linear green (may be outside [0, 1] if out of gamut).
--- @return number b Linear blue (may be outside [0, 1] if out of gamut).
local function oklch2linear_rgb(L, C, H)
  local Lab_L, a, b = utils.oklch2oklab(L, C, H)
  return utils.oklab2linear_rgb(Lab_L, a, b)
end

local GAMUT_EPSILON = 1e-4

local function in_srgb_gamut(r, g, b)
  return r >= -GAMUT_EPSILON
    and r <= 1 + GAMUT_EPSILON
    and g >= -GAMUT_EPSILON
    and g <= 1 + GAMUT_EPSILON
    and b >= -GAMUT_EPSILON
    and b <= 1 + GAMUT_EPSILON
end

--- Convert OKLCH color to hex string.
--- Complete pipeline: OKLCH → OKLab → Linear RGB → RGB → Hex
--- When the requested chroma falls outside the sRGB gamut at this lightness/hue,
--- chroma is reduced via binary search until it fits. This preserves lightness and
--- hue (unlike naive per-channel clamping, which can shift hue and mute colors
--- toward gray), so out-of-gamut requests render as the most saturated in-gamut
--- color available for that lightness/hue instead of a muddied clip.
--- @param L number Lightness [0, 1].
--- @param C number Chroma [0, 0.4+].
--- @param H number Hue [0, 360) degrees.
--- @return string Hex color string (e.g., "#5B8DEF").
utils.oklch2hex = function(L, C, H)
  local r, g, b = oklch2linear_rgb(L, C, H)

  if C > 0 and not in_srgb_gamut(r, g, b) then
    local lo, hi = 0, C
    for _ = 1, 20 do
      local mid = (lo + hi) / 2
      local mr, mg, mb = oklch2linear_rgb(L, mid, H)
      if in_srgb_gamut(mr, mg, mb) then
        lo = mid
      else
        hi = mid
      end
    end
    r, g, b = oklch2linear_rgb(L, lo, H)
  end

  -- Linear RGB → RGB (gamma correction)
  r = utils.linear2rgb(r)
  g = utils.linear2rgb(g)
  b = utils.linear2rgb(b)

  -- Normalize to [0, 255]
  r = r * 255
  g = g * 255
  b = b * 255

  -- Final clamp mops up floating-point residue from the gamut search above.
  r, g, b = utils.rgb_clamp(r, g, b)

  -- RGB → Hex
  return utils.rgb2hex(r, g, b)
end

return utils
