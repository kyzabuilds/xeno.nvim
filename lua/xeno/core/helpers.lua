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
  local defaults = config.defaults
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

return M
