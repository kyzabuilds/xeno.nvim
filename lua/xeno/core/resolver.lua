local M = {}
local fmt = string.format

-- Cache for resolved colors to improve performance
local resolved_cache = {}

--- Clear the resolved colors cache
function M.clear_cache()
  resolved_cache = {}
end

--- Check if a value is a color reference (e.g., "@base.500")
--- @param value any The value to check
--- @return boolean True if it's a color reference
function M.is_color_reference(value)
  return type(value) == "string" and value:match("^@[%w_]+%.[%w_]+$") ~= nil
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

--- Extract color key from reference (e.g., "@base.500" -> "base_500")
--- @param reference string The color reference
--- @return string|nil The color key or nil if invalid
function M.extract_color_key(reference)
  if not M.is_color_reference(reference) then
    return nil
  end

  -- Remove @ and replace . with _
  local key = reference:sub(2):gsub("%.", "_")
  return key
end

--- Resolve a single color reference
--- @param value any The value to resolve (may be a reference or regular value)
--- @param colors table The color palette
--- @param highlights table|nil Optional highlights table for highlight references
--- @return any The resolved value
function M.resolve_value(value, colors, highlights)
  if M.is_color_reference(value) then
    -- Check cache first
    if resolved_cache[value] then
      return resolved_cache[value]
    end

    local color_key = M.extract_color_key(value)
    if not color_key then
      vim.notify(fmt("xeno.nvim: Invalid color reference '%s'", value), vim.log.levels.WARN)
      return value
    end

    local resolved_color = colors[color_key]
    if not resolved_color then
      vim.notify(fmt("xeno.nvim: Unknown color reference '%s'", value), vim.log.levels.WARN)
      return value
    end

    -- Cache the resolved color
    resolved_cache[value] = resolved_color
    return resolved_color
  elseif M.is_highlight_reference(value) and highlights then
    -- Handle { from = "GroupName" } references - this should not be resolved here
    -- as we need context about which attribute (bg/fg/etc.) is being set
    return value
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
      resolved[key] = M.resolve_value(value, colors, highlights)
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
          vim.notify(
            fmt("xeno.nvim: Plugin config for '%s' must be a table", plugin_name),
            vim.log.levels.WARN
          )
          return false
        end
      end
    end
  end

  return true
end

return M
