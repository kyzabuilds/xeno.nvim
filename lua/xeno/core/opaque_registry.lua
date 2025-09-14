local M = {}

local fmt = string.format

-- Registry state
local registry = {
  colors = {}, -- Table to store registered opaque colors by variant
  export_mode = false, -- Whether we're currently in export mode
  name_counter = {}, -- Counter for name collisions
}

-- Clear the registry completely
function M.clear()
  registry.colors = {}
  registry.name_counter = {}
end

-- Enable or disable export mode (when enabled, opaque calls will be registered)
function M.set_export_mode(enabled)
  registry.export_mode = enabled
  if enabled then
    M.clear() -- Clear registry when entering export mode
  end
end

-- Check if export mode is active
function M.is_export_mode()
  return registry.export_mode
end

-- Generate a consistent name for an opaque color
function M.generate_opaque_name(base_color_name, opacity)
  if not base_color_name or not opacity then
    return nil
  end

  -- Convert opacity to 3-digit padded percentage (e.g., 0.05 -> "005", 0.55 -> "055", 1.0 -> "100")
  local opacity_padded = fmt("%03d", math.floor(opacity * 100 + 0.5))
  
  return fmt("%s_%s", base_color_name, opacity_padded)
end

-- Extract base color name from a color reference or hex value
local function extract_color_name(color_value, colors)
  if not color_value or type(color_value) ~= "string" then
    return "unknown"
  end

  -- If it's a hex color, try to find the corresponding name in the colors table
  if color_value:match("^#[0-9a-fA-F]+$") then
    for name, hex in pairs(colors or {}) do
      if type(hex) == "string" and hex:upper() == color_value:upper() then
        return name
      end
    end
    -- If no match found, create a name based on the hex value
    return fmt("color_%s", color_value:sub(2, 7):lower())
  end

  -- If it's already a color name, return it as-is (but sanitized)
  local sanitized = color_value:gsub("[^%w_]", "_")
  if not sanitized:match("^[%a_]") then
    sanitized = "_" .. sanitized
  end
  
  return sanitized
end

-- Register an opaque color call for the current variant
function M.register_opaque_call(fg_color, opacity, bg_color, result_hex, colors, variant)
  if not registry.export_mode then
    return
  end

  -- Use current background as variant if not specified
  variant = variant or vim.o.background or "dark"

  -- Initialize variant storage if needed
  if not registry.colors[variant] then
    registry.colors[variant] = {}
  end

  -- Extract the base color name
  local base_color_name = extract_color_name(fg_color, colors)
  
  -- Generate the opaque color name
  local opaque_name = M.generate_opaque_name(base_color_name, opacity)
  if not opaque_name then
    return
  end

  -- Check for name collisions and resolve them
  local final_name = opaque_name
  if registry.colors[variant][opaque_name] and registry.colors[variant][opaque_name].hex ~= result_hex then
    -- We have a collision with a different result - need to make the name unique
    registry.name_counter[opaque_name] = (registry.name_counter[opaque_name] or 0) + 1
    final_name = fmt("%s_%d", opaque_name, registry.name_counter[opaque_name])
  end

  -- Store the opaque color information
  registry.colors[variant][final_name] = {
    base_color = fg_color,
    opacity = opacity,
    bg_color = bg_color,
    hex = result_hex,
    variant = variant,
  }
end

-- Get all registered opaque colors for a specific variant
function M.get_opaque_colors(variant)
  variant = variant or vim.o.background or "dark"
  return registry.colors[variant] or {}
end

-- Get all registered opaque colors for all variants
function M.get_all_opaque_colors()
  return registry.colors
end

-- Get a specific opaque color by name and variant
function M.get_opaque_color(name, variant)
  variant = variant or vim.o.background or "dark"
  local variant_colors = registry.colors[variant]
  return variant_colors and variant_colors[name]
end

-- Check if an opaque color is registered
function M.has_opaque_color(name, variant)
  return M.get_opaque_color(name, variant) ~= nil
end

-- Get the count of registered opaque colors across all variants
function M.get_color_count()
  local total = 0
  for _, variant_colors in pairs(registry.colors) do
    for _ in pairs(variant_colors) do
      total = total + 1
    end
  end
  return total
end

-- Debug function to print all registered colors
function M.debug_print()
  print("Opaque Color Registry Debug:")
  print(fmt("Export mode: %s", tostring(registry.export_mode)))
  print(fmt("Total colors: %d", M.get_color_count()))
  
  for variant, colors in pairs(registry.colors) do
    print(fmt("\n%s variant:", variant))
    for name, info in pairs(colors) do
      print(fmt("  %s = %s (from %s @ %.2f opacity)", name, info.hex, info.base_color, info.opacity))
    end
  end
end

return M