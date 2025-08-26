local M = {}

local syntax = require("xeno.highlights.base.syntax")
local window = require("xeno.highlights.base.window")
local plugins = require("xeno.highlights.plugins")

-- Utility function to merge multiple highlight tables
local function merge_highlights(...)
  local result = {}
  for _, highlight_table in ipairs({ ... }) do
    if type(highlight_table) == "table" then
      for group, attrs in pairs(highlight_table) do
        result[group] = attrs
      end
    end
  end
  return result
end

-- Generate highlights from all plugins
function M.generate_plugin_highlights(colors)
  local plugin_results = {}
  for plugin_name, plugin_fn in pairs(plugins) do
    table.insert(plugin_results, plugin_fn(colors))
  end
  return merge_highlights(unpack(plugin_results))
end

-- Generate all highlights in one call
function M.generate_base_highlights(colors)
  return merge_highlights(
    syntax.generate_syntax_highlights(colors),
    window.generate_window_highlights(colors),
    M.generate_plugin_highlights(colors)
  )
end

-- Export plugin highlights for backward compatibility
for plugin_name, plugin_fn in pairs(plugins) do
  M[plugin_name] = plugin_fn
end

return M
