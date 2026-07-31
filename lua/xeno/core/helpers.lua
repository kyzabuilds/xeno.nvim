local M = {}
local utils = require("xeno.core.utils")

--- Apply default properties to every highlight in a configuration table
--- If the table has a 'defaults' property, those properties will be applied
--- to every other highlight group in the table
--- @param config table The highlight configuration table that may contain a 'defaults' key
--- @return table The processed configuration with defaults applied to all highlights
M.default = function(config)
  if not config or type(config) ~= "table" then
    return config or {}
  end

  -- Check if there's a defaults property
  local defaults = config.Defaults
  if not defaults or type(defaults) ~= "table" then
    return config
  end

  local result = {}

  -- Process each highlight group in the config
  for key, value in pairs(config) do
    if key ~= "defaults" and type(value) == "table" then
      -- Merge defaults with the highlight group, giving priority to existing properties
      result[key] = utils.extend("keep", value, defaults)
    else
      -- Copy non-highlight properties as-is (including 'defaults' for reference)
      result[key] = value
    end
  end

  return result
end

--- Conditionally add border styles to highlight groups
--- If borders are explicitly disabled in config, removes border properties
--- Otherwise adds underline and sp properties for borders
--- @param base_highlight table The base highlight configuration
--- @param config table The theme configuration containing decorations.borders setting
--- @return table The processed highlight with or without border properties
M.with_borders = function(base_highlight, config)
  -- If borders are explicitly disabled, return the base highlight without border properties
  if config and config.decorations and config.decorations.borders == false then
    local result = vim.tbl_deep_extend("force", {}, base_highlight)
    result.underline = nil
    result.sp = nil
    return result
  end

  -- Default: add border properties
  local result = vim.tbl_deep_extend("force", {}, base_highlight)
  result.underline = true
  result.sp = result.sp or "#4a4a4a"
  return result
end

return M
