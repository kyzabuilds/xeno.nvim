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

--- Merge all highlights with user overrides
--- @param base_highlights table Base highlights from generators
--- @param user_highlights table User highlight overrides
--- @return table Merged highlights
function M.merge_all_highlights(base_highlights, user_highlights)
  if not user_highlights or type(user_highlights) ~= "table" then
    return base_highlights or {}
  end

  local merged = vim.deepcopy(base_highlights or {})

  -- Process editor highlights
  if user_highlights.editor then
    for group, attrs in pairs(user_highlights.editor) do
      merged[group] = M.merge_highlight_group(merged[group], attrs)
    end
  end

  -- Process syntax highlights
  if user_highlights.syntax then
    for group, attrs in pairs(user_highlights.syntax) do
      merged[group] = M.merge_highlight_group(merged[group], attrs)
    end
  end

  -- Process plugin highlights
  if user_highlights.plugins then
    for plugin_path, plugin_highlights in pairs(user_highlights.plugins) do
      for group, attrs in pairs(plugin_highlights) do
        merged[group] = M.merge_highlight_group(merged[group], attrs)
      end
    end
  end

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
