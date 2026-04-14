local utils = require("xeno.core.utils")
local defaults = require("xeno.config.defaults")
local highlight_generator = require("xeno.highlights")
local palette = require("xeno.core.palette")
local terminal = require("xeno.integrations.terminal")
local theme = require("xeno.theme.apply")
local fallback = require("xeno.core.fallback")
local generator = require("xeno.core.generator")
local resolver = require("xeno.core.resolver")
local merger = require("xeno.core.merger")
local namespace = require("xeno.core.namespace")

local fmt = string.format

-- Store custom colors defined by users
local custom_colors = {}

local xeno = {}

-- Expose plugin registry and filetype configuration
xeno.hl = require("xeno.highlights.plugins")
xeno.ft = {}

-- Store global plugin configuration for new_theme function
xeno._global_config = {}

-- Set global configuration (for use with lazy.nvim opts)
function xeno.config(config)
  xeno._global_config = config or {}
end

-- Define a custom color that can be referenced in highlights
function xeno.color(name, hex_value)
  -- Validate name is a valid identifier
  if type(name) ~= "string" or not name:match("^[%a_][%w_]*$") then
    vim.notify(
      fmt("xeno.nvim: Invalid color name '%s'. Use alphanumeric characters and underscores only.", tostring(name)),
      vim.log.levels.ERROR
    )
    return xeno
  end

  -- Validate hex_value is a valid hex color
  if type(hex_value) ~= "string" then
    vim.notify(fmt("xeno.nvim: Invalid color hex value '%s' for '%s'. Must be a string.", tostring(hex_value), name), vim.log.levels.ERROR)
    return xeno
  end

  local L, C, H = utils.hex2oklch(hex_value)
  if not L then
    vim.notify(fmt("xeno.nvim: Invalid color hex value '%s' for '%s'. Must be a valid hex color.", hex_value, name), vim.log.levels.ERROR)
    return xeno
  end

  -- Store the custom color
  custom_colors[name] = hex_value

  -- Clear resolver cache since we've added a new color
  resolver.clear_cache()

  return xeno -- Allow chaining
end

-- Initialize with default colors immediately for plugin access
xeno.colors = fallback.initialize_default_colors()

function xeno.setup(user_config)
  vim.g.colors_name = "xeno"

  -- Clear resolver cache for fresh setup
  resolver.clear_cache()

  local config = utils.extend("force", defaults.config, user_config or {})

  -- Store the merged config globally for export functionality
  xeno._global_config = config

  -- Add custom colors to config for palette generation (merge with any passed in config)
  local merged_custom_colors = {}
  if user_config and user_config._custom_colors then
    for name, hex in pairs(user_config._custom_colors) do
      merged_custom_colors[name] = hex
    end
  end
  for name, hex in pairs(custom_colors) do
    merged_custom_colors[name] = hex
  end
  config._custom_colors = merged_custom_colors

  local ok, colors = pcall(palette.generate_palette, config)
  if not ok then
    vim.notify(fmt("xeno.nvim: Error generating color palette: %s. Using fallback colors.", tostring(colors)), vim.log.levels.ERROR)
    colors = {}
  end

  xeno.colors = fallback.create_safe_color_table(colors)

  -- Setup terminal colors (includes Ghostty integration)
  terminal.setup_terminal_colors(xeno.colors, config)

  -- Generate base highlights
  local ok_highlights, highlights, filetype_definitions = pcall(highlight_generator.generate_base_highlights, xeno.colors, config)
  if not ok_highlights then
    vim.notify(
      fmt("xeno.nvim: Error generating highlights: %s. Using minimal fallback highlights.", tostring(highlights)),
      vim.log.levels.ERROR
    )
    highlights = {
      Normal = { bg = xeno.colors.background_950, fg = xeno.colors.foreground_50 },
      Comment = { fg = xeno.colors.foreground_400, italic = true },
      Error = { fg = xeno.colors.red },
    }
  else
    -- Merge any filetype definitions returned from highlights generation
    if filetype_definitions then
      for ft, def in pairs(filetype_definitions) do
        xeno.ft[ft] = def
      end
    end
  end

  -- Process user highlight overrides if present
  if config.highlights then
    -- Validate the highlight structure
    if resolver.validate_highlights(config.highlights) then
      -- Merge user highlights with base highlights (includes reference resolution)
      highlights = merger.merge_all_highlights(highlights, config.highlights, xeno.colors)
    end
  end

  -- Store highlights for export functionality
  xeno._generated_highlights = highlights

  -- Apply highlights and setup autocmds
  theme.apply_highlights(highlights, config)
  theme.setup_autocmds(user_config)

  -- Setup filetype-specific window highlights
  require("xeno.theme.ft").setup(xeno.ft, xeno.colors, config)
end

-- Generate new colorscheme files
function xeno.theme(name, config)
  if config and config.base ~= nil then
    vim.notify("[xeno.nvim] 'base' is deprecated, please use 'background'", vim.log.levels.WARN)
    if config.background == nil then
      config.background = config.base
    end
  end

  -- Merge global config with theme-specific config
  local merged_config = utils.extend("force", xeno._global_config, config or {})

  -- Add custom colors to config
  merged_config._custom_colors = custom_colors

  generator.theme(name, merged_config, xeno._global_config)
end

-- Deprecated: Use xeno.theme() instead
function xeno.new_theme(name, config)
  vim.notify(
    "xeno.nvim: xeno.new_theme() is deprecated. Please use xeno.theme() instead.",
    vim.log.levels.WARN
  )
  return xeno.theme(name, config)
end

-- Create a namespaced variant of the theme
function xeno.namespace(namespace_name, highlights_override)
  local colors = xeno.colors
  if not colors then
    vim.notify("xeno.nvim: Please call setup() before creating namespaces", vim.log.levels.ERROR)
    return
  end

  -- Start with base highlights (use global config merged with defaults)
  local config = utils.extend("force", defaults.config, xeno._global_config)
  local base_highlights = highlight_generator.generate_base_highlights(colors, config)

  -- Apply overrides if provided
  local final_highlights = base_highlights
  if highlights_override then
    if resolver.validate_highlights(highlights_override) then
      final_highlights = merger.merge_all_highlights(base_highlights, highlights_override, colors)
    end
  end

  -- Apply to namespace
  local ns_id = namespace.apply_to_namespace(namespace_name, final_highlights)
  return ns_id
end

-- Set window to use a specific namespace
function xeno.set_window_namespace(win_id, namespace_name)
  return namespace.set_window_namespace(win_id or 0, namespace_name)
end

-- Export current theme as standalone colorscheme
function xeno.export(config)
  local export_module = require("xeno.export")
  return export_module.export_theme(config)
end

-- Public palette accessor for external integrations/helpers.
function xeno.get_colors()
  return xeno.colors
end

-- Expose namespace utilities
xeno.namespace_utils = namespace

-- Expose utils.opaque for user themes
xeno.opaque = utils.opaque

-- Public color access: allow xeno.foreground_400 as shorthand for xeno.colors.foreground_400
setmetatable(xeno, {
  __index = function(tbl, key)
    local value = rawget(tbl, key)
    if value ~= nil then
      return value
    end

    local colors = rawget(tbl, "colors")
    if colors and type(colors) == "table" then
      return colors[key]
    end

    return nil
  end,
})

return xeno
