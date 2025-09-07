local defaults = {}

defaults.config = {
  variation = 0.0,
  contrast = 0.0,

  transparent = false,

  red = nil, -- #E86671 (dark) / #B71C1C (light)
  green = nil, -- #A9DC76 (dark) / #2E7D32 (light)
  yellow = nil, -- #E7C547 (dark) / #F57C00 (light)
  orange = nil, -- #FFA94D (dark) / #E65100 (light)
  blue = nil,
  purple = nil,
  cyan = nil,

  -- Add highlights configuration support
  highlights = {
    editor = {},
    syntax = {},
    plugins = {},
  },

  -- Terminal integrations
  integrations = {
    ghostty = {
      enabled = true,
      update_config = true,
    },
  },
}

return defaults
