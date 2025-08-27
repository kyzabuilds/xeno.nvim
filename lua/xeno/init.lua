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
    vim.notify(
      fmt("xeno.nvim: Error generating color palette: %s. Using fallback colors.", tostring(colors)),
      vim.log.levels.ERROR
    )
    colors = {}
  end

  xeno.colors = fallback.create_safe_color_table(colors)

  -- Setup terminal colors
  terminal.setup_terminal_colors(xeno.colors)

  -- Generate base highlights
  local ok_highlights, highlights = pcall(highlight_generator.generate_base_highlights, xeno.colors)
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
      -- Resolve color references in user highlights
      local resolved_user_highlights = resolver.resolve_highlights(config.highlights, xeno.colors)

      -- Merge user highlights with base highlights
      highlights = merger.merge_all_highlights(highlights, resolved_user_highlights)
    end
  end

  -- Apply highlights and setup autocmds
  theme.apply_highlights(highlights, config)
  theme.setup_autocmds(user_config)
end

-- Generate new colorscheme files
function xeno.new_theme(name, config)
  -- Merge global config with theme-specific config
  local merged_config = utils.extend("force", xeno._global_config, config or {})
  generator.new_theme(name, merged_config, xeno._global_config)
end

return xeno
