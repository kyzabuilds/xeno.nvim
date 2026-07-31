local M = {}

local syntax = require("xeno.highlights.base.syntax")
local editor = require("xeno.highlights.base.editor")
local plugins = require("xeno.highlights.plugins")
local filetypes = require("xeno.highlights.filetypes")

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
  local filetype_definitions = {}
  local plugin_configs = config.highlights and config.highlights.plugins or {}
  local resolver = require("xeno.core.resolver")

  for plugin_name, plugin_fn in pairs(plugins) do
    local plugin_config = plugin_configs[plugin_name]

    -- Resolve color references in plugin config if provided
    if plugin_config then
      plugin_config = resolver.resolve_highlights(plugin_config, colors, nil)
    end

    local result = plugin_fn(colors, config, plugin_config)

    -- Separate highlights from filetype definitions (functions)
    local highlights = {}
    if result then
      for k, v in pairs(result) do
        if type(v) == "function" then
          filetype_definitions[k] = v
        else
          highlights[k] = v
        end
      end
    end

    table.insert(plugin_results, highlights)
  end

  return merge_highlights(unpack(plugin_results)), filetype_definitions
end

-- Generate all highlights in one call
function M.generate_base_highlights(colors, config)
  local plugin_highlights, filetype_definitions = M.generate_plugin_highlights(colors, config)

  local base_highlights =
    merge_highlights(syntax.generate_syntax_highlights(colors), editor.generate_editor_highlights(colors, config), plugin_highlights, filetypes.generate(colors))

  return base_highlights, filetype_definitions
end

-- Export plugin highlights for backward compatibility
for plugin_name, plugin_fn in pairs(plugins) do
  M[plugin_name] = plugin_fn
end

return M
