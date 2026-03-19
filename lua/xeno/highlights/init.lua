local M = {}

local syntax = require("xeno.highlights.base.syntax")
local editor = require("xeno.highlights.base.editor")
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
function M.generate_plugin_highlights(colors, config)
  local plugin_results = {}
  local plugin_configs = config.highlights and config.highlights.plugins or {}
  local resolver = require("xeno.core.resolver")

  for plugin_name, plugin_fn in pairs(plugins) do
    local plugin_config = plugin_configs[plugin_name]

    -- Resolve color references in plugin config if provided
    if plugin_config then
      plugin_config = resolver.resolve_highlights(plugin_config, colors, nil)
    end

    table.insert(plugin_results, plugin_fn(colors, config, plugin_config))
  end

  return merge_highlights(unpack(plugin_results))
end

-- Generate all highlights in one call
function M.generate_base_highlights(colors, config)
  return merge_highlights(
    syntax.generate_syntax_highlights(colors),
    editor.generate_editor_highlights(colors, config),
    M.generate_plugin_highlights(colors, config)
  )
end

-- Export plugin highlights for backward compatibility
for plugin_name, plugin_fn in pairs(plugins) do
  M[plugin_name] = plugin_fn
end

return M
