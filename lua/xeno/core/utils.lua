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

--- Blend a color with the 'Normal' background color based on opacity.
--- @param color_source string Either a hex color (e.g., "#RRGGBB") or a highlight group name.
--- @param opacity number From 0.0 (fully transparent, shows Normal background) to 1.0 (fully opaque, shows input color).
--- @return string The new hex color string. Returns input color (if hex and resolvable) or black on critical failure.
utils.opaque = function(color_source, opacity)
  assert(color_source ~= nil, "utils.opaque: color_source must be provided (hex string or highlight group name).")
  assert(
    type(opacity) == "number" and opacity >= 0 and opacity <= 1,
    "utils.opaque: Opacity must be a number between 0.0 and 1.0."
  )

  local r_fg, g_fg, b_fg

  if type(color_source) == "string" then
    if color_source:sub(1, 1) == "#" or not color_source:match("%s") then -- Heuristic: if it starts with # or has no spaces, likely a hex or direct color name
      r_fg, g_fg, b_fg = utils.hex2rgb(color_source)
    end

    if not (r_fg and g_fg and b_fg) then -- If not resolved as hex, assume it's a highlight group name
      local ok_hl, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = color_source, link = false, rgb = true })
      if ok_hl and hl_def and hl_def.foreground then
        local fg_hex = fmt("#%06x", hl_def.foreground)
        r_fg, g_fg, b_fg = utils.hex2rgb(fg_hex)
      else
        if not ok_hl then
          log_warn(fmt("utils.opaque: Error getting highlight group '%s': %s", color_source, tostring(hl_def))) -- hl_def is error message here
        elseif not hl_def then
          log_warn(fmt("utils.opaque: Highlight group '%s' not found.", color_source))
        elseif not hl_def.foreground then
          log_warn(
            fmt("utils.opaque: Highlight group '%s' has no foreground color. Cannot apply opacity.", color_source)
          )
        end
      end
    end
  else
    log_warn(fmt("utils.opaque: color_source must be a string. Got %s", type(color_source)))
  end

  if not (r_fg and g_fg and b_fg) then
    log_warn(
      fmt(
        "utils.opaque: Could not parse foreground color from source: %s. Using black as fallback for foreground.",
        vim.inspect(color_source)
      )
    )
    r_fg, g_fg, b_fg = 0, 0, 0 -- Fallback for foreground to black
  end

  -- Get RGB for the 'Normal' background color
  local r_bg, g_bg, b_bg
  local ok_normal_hl, normal_hl_def = pcall(vim.api.nvim_get_hl, 0, { name = "Normal", link = false, rgb = true })

  if ok_normal_hl and normal_hl_def and normal_hl_def.background then
    local normal_bg_hex = fmt("#%06x", normal_hl_def.background)
    r_bg, g_bg, b_bg = utils.hex2rgb(normal_bg_hex)
  end

  if not (r_bg and g_bg and b_bg) then
    if vim.o.background == "light" then
      r_bg, g_bg, b_bg = 255, 255, 255 -- White for light themes
    else
      r_bg, g_bg, b_bg = 0, 0, 0 -- Black for dark themes
    end
  end

  -- Blend the colors: alpha * FG + (1 - alpha) * BG
  local r_new = opacity * r_fg + (1 - opacity) * r_bg
  local g_new = opacity * g_fg + (1 - opacity) * g_bg
  local b_new = opacity * b_fg + (1 - opacity) * b_bg

  -- Clamp and convert to hex
  r_new, g_new, b_new = utils.rgb_clamp(r_new, g_new, b_new)
  return utils.rgb2hex(r_new, g_new, b_new)
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

--- Convert a hex color string to HSL values.
--- @param hex string The hex color string.
--- @return number? h Hue (0-360) or nil on failure.
--- @return number? s Saturation (0-1) or nil on failure.
--- @return number? l Lightness (0-1) or nil on failure.
utils.hex2hsl = function(hex)
  local r_orig, g_orig, b_orig = utils.hex2rgb(hex)
  if not r_orig then
    return nil, nil, nil
  end

  local r, g, b = r_orig / 255, g_orig / 255, b_orig / 255

  local min_val = math.min(r, g, b)
  local max_val = math.max(r, g, b)
  local delta = max_val - min_val

  local h, s, l
  l = (max_val + min_val) / 2

  if delta == 0 then
    h = 0
    s = 0 -- Achromatic
  else
    s = l > 0.5 and delta / (2 - max_val - min_val) or delta / (max_val + min_val)
    if max_val == r then
      h = (g - b) / delta + (g < b and 6 or 0)
    elseif max_val == g then
      h = (b - r) / delta + 2
    else -- max_val == b
      h = (r - g) / delta + 4
    end
    h = h / 6 -- Normalize to [0,1)
    h = h * 360 -- Convert to degrees
    if h < 0 then
      h = h + 360
    end -- Ensure hue is positive [0, 360)
  end
  return h, s, l
end

--- Helper function for HSL to RGB conversion.
local function hue_to_rgb_component(p, q, t)
  if t < 0 then
    t = t + 1
  end
  if t > 1 then
    t = t - 1
  end
  if t < 1 / 6 then
    return p + (q - p) * 6 * t
  end
  if t < 1 / 2 then
    return q
  end
  if t < 2 / 3 then
    return p + (q - p) * (2 / 3 - t) * 6
  end
  return p
end

--- Convert HSL values to RGB values.
--- @param h number Hue (0-360).
--- @param s number Saturation (0-1).
--- @param l number Lightness (0-1).
--- @return number r Red component (0-255).
--- @return number g Green component (0-255).
--- @return number b Blue component (0-255).
utils.hsl2rgb = function(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- Achromatic
  else
    h = h / 360 -- Normalize h to be in [0,1) for calculations
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue_to_rgb_component(p, q, h + 1 / 3)
    g = hue_to_rgb_component(p, q, h)
    b = hue_to_rgb_component(p, q, h - 1 / 3)
  end
  return r * 255, g * 255, b * 255
end

--- Convert HSL values to a hex color string.
--- @param h number Hue (0-360).
--- @param s number Saturation (0-1).
--- @param l number Lightness (0-1).
--- @return string Hex color string.
utils.hsl2hex = function(h, s, l)
  local r, g, b = utils.hsl2rgb(h, s, l)
  return utils.rgb2hex(r, g, b)
end

return utils
