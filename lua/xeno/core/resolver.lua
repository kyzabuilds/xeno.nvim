local M = {}
local fmt = string.format

-- Cache for resolved colors to improve performance
local resolved_cache = {}

local function implicit_color_cache_key(reference, colors)
  return reference .. "::" .. tostring(colors)
end

local function get_palette_color(colors, key)
  if type(colors) ~= "table" then
    return nil
  end

  return rawget(colors, key)
end

local function find_closest_palette_level(colors, family, target)
  if type(colors) ~= "table" then
    return nil
  end

  target = target or 400
  local closest_level = nil
  local closest_distance = nil

  for key in pairs(colors) do
    local level = key:match("^" .. vim.pesc(family) .. "_(%d+)$")
    if level then
      local numeric_level = tonumber(level)
      local distance = math.abs(numeric_level - target)

      if closest_distance == nil or distance < closest_distance or (distance == closest_distance and numeric_level < closest_level) then
        closest_level = numeric_level
        closest_distance = distance
      end
    end
  end

  return closest_level
end

--- Clear the resolved colors cache
function M.clear_cache()
  resolved_cache = {}
end

--- Check if a value is a color reference (e.g., "@background.500" or "@my_color")
--- @param value any The value to check
--- @return boolean True if it's a color reference
function M.is_color_reference(value)
  return type(value) == "string"
    and (
      value:match("^@[%w_]+%.[%w_]+$") ~= nil -- @color.level
      or value:match("^@[%w_]+$") ~= nil -- @color (fallback to 500)
    )
end

--- Check if a value is a highlight reference (e.g., { from = "Normal" })
--- @param value any The value to check
--- @return boolean True if it's a highlight reference
function M.is_highlight_reference(value)
  return type(value) == "table" and value.from ~= nil
end

--- Resolve a highlight reference for a specific attribute
--- @param reference table The highlight reference { from = "GroupName" }
--- @param attribute string The attribute name (bg, fg, etc.)
--- @param highlights table The highlights table
--- @return any The resolved attribute value
function M.resolve_highlight_reference(reference, attribute, highlights)
  if not M.is_highlight_reference(reference) then
    return reference
  end

  local target_group = reference.from
  if not highlights[target_group] then
    vim.notify(fmt("xeno.nvim: Unknown highlight group reference '%s'", target_group), vim.log.levels.WARN)
    return reference
  end

  local target_attrs = highlights[target_group]
  if target_attrs[attribute] then
    return target_attrs[attribute]
  else
    vim.notify(fmt("xeno.nvim: Highlight group '%s' does not have attribute '%s'", target_group, attribute), vim.log.levels.WARN)
    return reference
  end
end

--- Extract color key from reference (e.g., "@background.500" -> "background_500", "@my_color" -> the closest available implicit level)
--- @param reference string The color reference
--- @param colors table|nil Optional color palette used to resolve implicit family aliases
--- @return string|nil The color key or nil if invalid
function M.extract_color_key(reference, colors)
  if not M.is_color_reference(reference) then
    return nil
  end

  -- Remove @
  local key = reference:sub(2)

  -- If it has a level (contains dot), replace . with _
  if key:match("%.") then
    key = key:gsub("%.", "_")
    -- Snap to nearest available level if the exact one doesn't exist
    if not get_palette_color(colors, key) then
      local family = key:match("^(.-)_%d+$")
      local requested_level = tonumber(key:match("_(%d+)$"))
      if family and requested_level then
        local closest_level = find_closest_palette_level(colors, family, requested_level)
        if closest_level then
          key = fmt("%s_%d", family, closest_level)
        end
      end
    end
  else
    local preferred_key = key .. "_400"
    if get_palette_color(colors, preferred_key) then
      return preferred_key
    end

    local closest_level = find_closest_palette_level(colors, key)
    if closest_level then
      return fmt("%s_%s", key, closest_level)
    end

    key = preferred_key
  end

  return key
end

--- Resolve a single color reference
--- @param value any The value to resolve (may be a reference or regular value)
--- @param colors table The color palette
--- @param highlights table|nil Optional highlights table for highlight references
--- @param attribute string|nil The highlight attribute being resolved
--- @return any The resolved value
function M.resolve_value(value, colors, highlights, attribute)
  if M.is_color_reference(value) then
    -- Link targets can validly be highlight groups like "@variable"; don't
    -- reinterpret them as palette aliases.
    if attribute == "link" then
      return value
    end

    local color_key = M.extract_color_key(value, colors)
    if not color_key then
      vim.notify(fmt("xeno.nvim: Invalid color reference '%s'", value), vim.log.levels.WARN)
      return value
    end

    local cache_key = M.is_color_reference(value) and not value:match("%.") and implicit_color_cache_key(value, colors) or value

    -- Check cache first
    if resolved_cache[cache_key] then
      return resolved_cache[cache_key]
    end

    local resolved_color = get_palette_color(colors, color_key)
    if not resolved_color then
      vim.notify(fmt("xeno.nvim: Unknown color reference '%s'", value), vim.log.levels.WARN)
      return value
    end

    -- Cache the resolved color
    resolved_cache[cache_key] = resolved_color
    return resolved_color
  elseif M.is_highlight_reference(value) and highlights then
    -- Handle { from = "GroupName" } references - this should not be resolved here
    -- as we need context about which attribute (bg/fg/etc.) is being set
    return value
  elseif type(value) == "string" and value:match("^#[0-9a-fA-F]+$") == nil then
    -- Handle direct semantic color names (e.g., 'green', 'red', 'blue')
    -- But only if it's not already a hex color and looks like a semantic color
    local semantic_colors = { "red", "green", "blue", "yellow", "orange", "purple", "cyan", "magenta", "white", "black", "gray", "grey" }
    local is_semantic_name = false
    for _, semantic in ipairs(semantic_colors) do
      if value == semantic then
        is_semantic_name = true
        break
      end
    end

    if is_semantic_name then
      -- Check cache first
      if resolved_cache[value] then
        return resolved_cache[value]
      end

      local resolved_color = get_palette_color(colors, value)
      if resolved_color then
        -- Cache the resolved color
        resolved_cache[value] = resolved_color
        return resolved_color
      else
        -- Semantic color not found in palette, log warning and use fallback
        vim.notify(fmt("xeno.nvim: Semantic color '%s' not found in palette during resolution", value), vim.log.levels.WARN)
        -- Don't return the original value as it would cause #000000 fallback later
        -- Instead, try to find it in fallback colors
        local fallback = require("xeno.core.fallback")
        local fallback_colors = fallback.create_safe_color_table({})
        local fallback_value = fallback_colors[value]
        resolved_cache[value] = fallback_value
        return fallback_value
      end
    end
  end

  return value
end

--- Recursively resolve all color and highlight references in a table
--- @param tbl table The table to resolve
--- @param colors table The color palette
--- @param highlights table|nil Optional highlights table for highlight references
--- @return table The resolved table
function M.resolve_highlights(tbl, colors, highlights)
  if type(tbl) ~= "table" then
    return tbl
  end

  local resolved = {}

  for key, value in pairs(tbl) do
    if type(value) == "table" and not M.is_highlight_reference(value) then
      -- Recursively resolve nested tables (but not highlight references)
      resolved[key] = M.resolve_highlights(value, colors, highlights)
    elseif M.is_highlight_reference(value) and highlights then
      -- Resolve highlight reference with attribute context
      resolved[key] = M.resolve_highlight_reference(value, key, highlights)
    else
      -- Resolve color references
      resolved[key] = M.resolve_value(value, colors, highlights, key)
    end
  end

  return resolved
end

--- Validate highlight configuration structure
--- @param highlights table The highlights configuration
--- @return boolean True if valid
function M.validate_highlights(highlights)
  if type(highlights) ~= "table" then
    return false
  end

  local valid_categories = {
    editor = true,
    syntax = true,
    plugins = true,
  }

  for category, groups in pairs(highlights) do
    if not valid_categories[category] then
      vim.notify(
        fmt("xeno.nvim: Unknown highlight category '%s'. Valid categories: editor, syntax, plugins", category),
        vim.log.levels.WARN
      )
      return false
    end

    if type(groups) ~= "table" then
      vim.notify(fmt("xeno.nvim: Highlight category '%s' must be a table", category), vim.log.levels.WARN)
      return false
    end

    -- Validate plugin configurations
    if category == "plugins" then
      for plugin_name, plugin_config in pairs(groups) do
        if type(plugin_config) ~= "table" then
          vim.notify(fmt("xeno.nvim: Plugin config for '%s' must be a table", plugin_name), vim.log.levels.WARN)
          return false
        end
      end
    end
  end

  return true
end

return M
