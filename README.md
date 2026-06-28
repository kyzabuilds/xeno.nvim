<img title="xeno banner" alt="xeno banner" src="./media/banner.png">

<p align='center'>
  <a href="examples.md">Examples</a> | <a href="plugins.md">Plugins</a>
</p>


## Key Features

- **Automatic Light/Dark Mode** - Seamlessly adapts to `vim.o.background` changes
- **Background-Derived Foreground** - Foreground shades default to the background seed's hue/chroma and can still be overridden explicitly
- **Custom Color Families** - Define custom colors with `xeno.color()` that generate full shade ranges (`.50` - `.600`)
- **Extensive Theming API** - Granular control over every highlight group with color references and plugin configurations
- **Export Capabilities** - Generate standalone colorscheme files with `xeno.export()`
- **Window Namespaces** - Apply different highlight variants to specific windows with `xeno.namespace()`
- **Plugin Integration** - Built-in support for 23 popular plugins
- **Terminal Integration** - Automatic Ghostty terminal color synchronization

## Preview

<img title="xeno-latte" alt="xeno-latte" src="./media/xeno-latte.png">

```lua
xeno.theme('xeno-latte', {
  background = '#14110f',
  accent = '#bf8f7f',
  properties = {
    variation = 0.9,
  },
})
```

<img title="xeno-sylvan" alt="xeno-sylvan" src="./media/xeno-sylvan.png">

```lua
xeno.theme('xeno-sylvan', {
  background = '#151615',
  accent = '#3b594e',
  properties = {
    contrast = -0.3,
    variation = 0.9,
  },
})
```

<img title="xeno-onyx" alt="xeno-onyx" src="./media/xeno-onyx.png">

```lua
xeno.theme('xeno-onyx', {
  background = '#161616',
  accent = '#dbdbdb',
  properties = {
    variation = 0.8,
  },
})
```

<img title="xeno-emerald" alt="xeno-emerald" src="./media/xeno-emerald.png">

```lua
xeno.theme('xeno-emerald', {
  background = '#1c3029',
  accent = '#49b27f',
  properties = {
    variation = 0.7,
    chroma = 0.1,
    lightness = 0.1,
  },
})
```


## Installation

**lazy.nvim**
```lua
{
  'kyzadev/xeno.nvim',
  config = function()
    local xeno = require('xeno')

    -- Method 1: Use xeno.setup() for direct configuration
    xeno.setup({
      background = '#1E1E1E',
      accent = '#8CBE8C',
    })

    -- Method 2: Use xeno.theme() to generate a named colorscheme
    -- xeno.theme('my-theme', {
    --   background = '#1E1E1E',
    --   accent = '#8CBE8C',
    -- })
    -- vim.cmd('colorscheme my-theme')
  end,
}
```

**mini.deps**
```lua
local MiniDeps = require('mini.deps')
MiniDeps.add('kyzadev/xeno.nvim')

local xeno = require('xeno')

-- Method 1: Use xeno.setup() for direct configuration
xeno.setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
})

-- Method 2: Use xeno.theme() to generate a named colorscheme
-- xeno.theme('my-theme', {
--   background = '#1E1E1E',
--   accent = '#8CBE8C',
-- })
-- vim.cmd('colorscheme my-theme')
```

## Configuration

### Basic Options

```lua
xeno.setup({
  background = '#1a1a1a',  -- Background seed color
  foreground = nil,        -- Foreground seed (derived from background if nil)
  accent = '#7aa2f7',      -- Accent color

  -- Color adjustments
  properties = {
    contrast = 0.0,    -- Contrast adjustment (-1.0 to 1.0)
    variation = 0.0,   -- Hue variation (-1.0 to 1.0)
    chroma = 0.0,      -- Saturation adjustment (-1.0 to 1.0)
    lightness = 0.0,   -- Lightness adjustment (-1.0 to 1.0)
  },

  transparent = false,  -- Transparent background

  -- Semantic colors (optional)
  red = nil,
  green = nil,
  yellow = nil,
  orange = nil,
  blue = nil,
  purple = nil,
  cyan = nil,

  -- UI decorations
  decorations = {
    borders = true,
  },

  -- Terminal integrations
  integrations = {
    ghostty = {
      enabled = true,
      update_config = true,
    },
  },
})
```

### Custom Colors

Define custom color families with full shade ranges:

```lua
local xeno = require('xeno')

-- Define custom colors (generates .50 through .600 shades)
xeno.color('my_purple', '#8b5cf6')
xeno.color('accent_red', '#ef4444')

xeno.setup({
  background = '#1a1a1a',
  accent = '#7aa2f7',
  highlights = {
    syntax = {
      String = { fg = '@my_purple.300' },
      Function = { fg = '@accent_red.500' },
    },
  },
})
```

### Plugin Configuration

Customize plugin themes using high-level options:

```lua
xeno.setup({
  background = '#1a1a1a',
  accent = '#7aa2f7',
  highlights = {
    plugins = {
      ["nvim-telescope/telescope.nvim"] = {
        bg = "@background.950",
        fg = "@foreground.50",
        border = "@accent.500",
      },
      ["akinsho/bufferline.nvim"] = {
        selected_bg = "@background.700",
        visible_bg = "@background.900",
        separator = "@background.600",
      },
    },
  },
})
```

See [plugins.md](plugins.md) for all available plugin configuration options.

### Advanced Features

**Export Colorschemes**

```lua
-- Export current theme as a standalone colorscheme file
xeno.export({
  name = 'my-theme',
  path = vim.fn.stdpath('config') .. '/colors',
})
```

**Window Namespaces**

Apply different highlight variants to specific windows:

```lua
-- Create a namespace with custom highlights
local ns_id = xeno.namespace('sidebar', {
  editor = {
    Normal = { bg = '@background.950' },
  },
})

-- Apply to a window
xeno.set_window_namespace(vim.api.nvim_get_current_win(), 'sidebar')
```

**Color Access**

```lua
-- Get the color table
local colors = xeno.get_colors()

-- Shorthand access
local bg = xeno.background_950
local fg = xeno.foreground_50

-- Use xeno.opaque() for transparency
xeno.opaque(color, alpha, bg, colors)
```

See [examples.md](examples.md) for detailed configuration examples and complete theme showcases.
