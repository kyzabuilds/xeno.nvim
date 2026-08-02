local defaults = {}

defaults.config = {
  foreground = nil,
  background = nil,
  accent = nil,

  variation = 0.0,
  chroma = 0.0,
  lightness = 0.0,
  contrast = 0.0,

  -- Opt-in accessibility floor. nil = off (historical behavior). When set to a
  -- WCAG ratio in [1.0, 21.0], generated text colors are pushed until they meet
  -- it. Composes with `contrast` rather than replacing it.
  min_contrast = nil,

  transparent = false,

  -- UI decorations
  decorations = {
    borders = true,
  },

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
    plugins = {
      ["ibhagwan/fzf-lua"] = {
        bg = nil,
        fg = nil,
        border = nil,
        prompt_fg = nil,
        pointer_fg = nil,
        statusline_bg = nil,
        statusline_fg = nil,
        statusline_nc_bg = nil,
        statusline_nc_fg = nil,
        statusline1_fg = nil,
        statusline2_fg = nil,
        statusline3_fg = nil,
      },
    },
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
