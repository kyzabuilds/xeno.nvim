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
--- @return any The resolved value
function M.resolve_value(value, colors)
  if not M.is_color_reference(value) then
    return value
  end

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
end

--- Recursively resolve all color references in a table
--- @param tbl table The table to resolve
--- @param colors table The color palette
--- @return table The resolved table
function M.resolve_highlights(tbl, colors)
  if type(tbl) ~= "table" then
    return tbl
  end

  local resolved = {}

  for key, value in pairs(tbl) do
    if type(value) == "table" then
      -- Recursively resolve nested tables
      resolved[key] = M.resolve_highlights(value, colors)
    else
      -- Resolve individual values
      resolved[key] = M.resolve_value(value, colors)
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
  end

  return true
end

return M
