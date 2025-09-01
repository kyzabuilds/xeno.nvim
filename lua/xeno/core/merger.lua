local M = {}
local utils = require("xeno.core.utils")

--- Deep merge highlight groups, with user overrides taking precedence
--- @param base table Base highlight group
--- @param override table Override highlight group
--- @return table Merged highlight group
function M.merge_highlight_group(base, override)
  if not base then
    return override or {}
  end
  if not override then
    return base
  end

  -- For highlight groups, we want to completely override specific attributes
  -- but preserve others that aren't specified in the override
  return utils.extend("force", base, override)
end

--- Merge all highlights with user overrides, supporting highlight references
--- @param base_highlights table Base highlights from generators
--- @param user_highlights table User highlight overrides
--- @param colors table Color palette for resolving references
--- @return table Merged highlights
function M.merge_all_highlights(base_highlights, user_highlights, colors)
  if not user_highlights or type(user_highlights) ~= "table" then
    return base_highlights or {}
  end

  local merged = vim.deepcopy(base_highlights or {})
  local resolver = require("xeno.core.resolver")

  -- Helper function to process highlight groups with reference resolution
  local function process_highlights(highlights_table, target_table)
    for group, attrs in pairs(highlights_table) do
      -- First resolve color references only
      local resolved_attrs = resolver.resolve_highlights(attrs, colors, nil)
      target_table[group] = M.merge_highlight_group(target_table[group], resolved_attrs)
    end
  end
  
  -- Helper function to resolve highlight references after all groups are merged
  local function resolve_highlight_references(target_table)
    local changed = true
    local max_iterations = 10 -- Prevent infinite loops
    local iterations = 0
    
    while changed and iterations < max_iterations do
      changed = false
      iterations = iterations + 1
      
      for group, attrs in pairs(target_table) do
        local new_attrs = {}
        local group_changed = false
        
        for attr_key, attr_value in pairs(attrs) do
          if resolver.is_highlight_reference(attr_value) then
            local resolved = resolver.resolve_highlight_reference(attr_value, attr_key, target_table)
            if resolved ~= attr_value then
              new_attrs[attr_key] = resolved
              group_changed = true
              changed = true
            else
              new_attrs[attr_key] = attr_value
            end
          else
            new_attrs[attr_key] = attr_value
          end
        end
        
        if group_changed then
          target_table[group] = new_attrs
        end
      end
    end
    
    if iterations >= max_iterations then
      vim.notify("xeno.nvim: Maximum iterations reached while resolving highlight references. Some references may be circular.", vim.log.levels.WARN)
    end
  end

  -- Process editor highlights
  if user_highlights.editor then
    process_highlights(user_highlights.editor, merged)
  end

  -- Process syntax highlights
  if user_highlights.syntax then
    process_highlights(user_highlights.syntax, merged)
  end

  -- Process plugin highlights
  if user_highlights.plugins then
    for plugin_path, plugin_highlights in pairs(user_highlights.plugins) do
      process_highlights(plugin_highlights, merged)
    end
  end
  
  -- After all merging is done, resolve highlight references
  resolve_highlight_references(merged)

  return merged
end

--- Extract and flatten user highlights for processing
--- @param config table The user configuration
--- @return table|nil Flattened highlights or nil if none
function M.extract_user_highlights(config)
  if not config or not config.highlights then
    return nil
  end

  return config.highlights
end

return M
