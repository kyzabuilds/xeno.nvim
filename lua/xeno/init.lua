local utils = require("xeno.core.utils")
local defaults = require("xeno.config.defaults")
local highlight_generator = require("xeno.highlights")
local palette = require("xeno.core.palette")
local terminal = require("xeno.integrations.terminal")
local theme = require("xeno.theme.apply")
local fallback = require("xeno.core.fallback")
local generator = require("xeno.core.generator")
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

  -- Generate highlights
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

  -- Apply highlights and setup autocmds
  theme.apply_highlights(highlights, config)
  theme.setup_autocmds(user_config)
end

-- Generate new colorscheme files
function xeno.new_theme(name, config)
  generator.new_theme(name, config, xeno._global_config)
end

return xeno
