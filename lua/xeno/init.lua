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

local xeno = {}

-- Store global plugin configuration for new_theme function
xeno._global_config = {}

-- Set global configuration (for use with lazy.nvim opts)
function xeno.config(config)
  xeno._global_config = config or {}
end

-- Initialize with default colors immediately for plugin access
xeno.colors = fallback.initialize_default_colors()

function xeno.setup(user_config)
  vim.g.colors_name = "xeno"

  -- Clear resolver cache for fresh setup
  resolver.clear_cache()

  local config = utils.extend("force", defaults.config, user_config or {})

  if config.background and not config.base then
    config.base = config.background
  end

  local ok, colors = pcall(palette.generate_palette, config)
  if not ok then
    vim.notify(fmt("xeno.nvim: Error generating color palette: %s. Using fallback colors.", tostring(colors)), vim.log.levels.ERROR)
    colors = {}
  end

  xeno.colors = fallback.create_safe_color_table(colors)

  -- Setup terminal colors (includes Ghostty integration)
  terminal.setup_terminal_colors(xeno.colors, config)

  -- Generate base highlights
  local ok_highlights, highlights = pcall(highlight_generator.generate_base_highlights, xeno.colors, config)
  if not ok_highlights then
    vim.notify(
      fmt("xeno.nvim: Error generating highlights: %s. Using minimal fallback highlights.", tostring(highlights)),
      vim.log.levels.ERROR
    )
    highlights = {
      Normal = { bg = xeno.colors.bg, fg = xeno.colors.fg },
      Comment = { fg = xeno.colors.base_600, italic = true },
      Error = { fg = xeno.colors.red },
    }
  end

  -- Process user highlight overrides if present
  if config.highlights then
    -- Validate the highlight structure
    if resolver.validate_highlights(config.highlights) then
      -- Merge user highlights with base highlights (includes reference resolution)
      highlights = merger.merge_all_highlights(highlights, config.highlights, xeno.colors)
    end
  end

  -- Apply highlights and setup autocmds
  theme.apply_highlights(highlights, config)
  theme.setup_autocmds(user_config)
end

-- Generate new colorscheme files
function xeno.theme(name, config)
  -- Merge global config with theme-specific config
  local merged_config = utils.extend("force", xeno._global_config, config or {})
  generator.theme(name, merged_config, xeno._global_config)
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

-- Expose namespace utilities
xeno.namespace_utils = namespace

return xeno
