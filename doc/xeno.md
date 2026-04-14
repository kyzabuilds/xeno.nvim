# xeno.nvim

Minimalist colorscheme generator for Neovim.

**Author:** kyza0d
**License:** Same terms as Vim itself

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Configuration](#configuration)
5. [API Reference](#api-reference)
6. [Custom Colors](#custom-colors)
7. [Highlights](#highlights)
8. [Namespace Support](#namespace-support)
9. [Export](#export)
10. [Plugin Integration](#plugin-integration)
11. [Terminal Integration](#terminal-integration)
12. [Troubleshooting](#troubleshooting)

## Introduction

xeno.nvim generates a complete colorscheme from three color seeds:

- **Foreground seed** (optional, 50-400 shades) — Derived from background when omitted
- **Background seed** (500-950 shades) — Required, defines your main surfaces
- **Accent seed** (50-600 shades) — Required, defines your accent colors

**Key Features:**

- **Automatic light/dark mode** — Adapts seamlessly to `vim.o.background` changes
- **Background-derived foreground** — Foreground defaults to background's hue/chroma, fully overridable
- **Custom colors** — Define unlimited custom color families with `xeno.color()`
- **Extensive theming API** — Granular control over every highlight group
- **Plugin support** — Built-in configuration for 26+ popular plugins
- **Namespace theming** — Create per-window theme variants
- **Export capabilities** — Generate standalone colorscheme files
- **Terminal integration** — Automatic terminal color setup (Ghostty supported)
- **Advanced color control** — Adjust variation, chroma, and contrast

## Installation

### Using lazy.nvim

```lua
{
  'kyza0d/xeno.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('xeno').setup({
      background = '#1E1E1E',
      accent = '#8CBE8C',
    })
    vim.cmd('colorscheme xeno')
  end,
}
```

### Using mini.deps

```lua
local MiniDeps = require('mini.deps')
MiniDeps.add('kyza0d/xeno.nvim')

require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme xeno')
```

## Quick Start

### Setup Method (Immediate Use)

Use `xeno.setup()` to load a colorscheme immediately:

```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme xeno')
```

### Theme Method (Generate Files)

Use `xeno.theme()` to generate reusable colorscheme files:

```lua
require('xeno').theme('my-theme', {
  background = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme my-theme')
```

## Configuration

### Core Color Options

| Option | Type | Required | Description |
|--------|------|----------|-------------|
| `background` | string (hex) | Yes | Background seed color. Defines all background shades. |
| `accent` | string (hex) | Yes | Accent seed color. Defines all accent shades. |
| `foreground` | string (hex) | No | Foreground override. When omitted, derives from background. |

### Palette Adjustments

| Option | Type | Range | Default | Description |
|--------|------|-------|---------|-------------|
| `variation` | number | 0.0–1.0 | 0.0 | Compresses foreground shades toward midpoint, reducing contrast between shade levels. Useful for softer text rendering. |
| `chroma` | number | -1.0–1.0 | 0.0 | Scales color saturation. -1.0 = grayscale, 0.0 = normal, 1.0 = double saturation. Affects all color families. |
| `lightness` | number | -1.0–1.0 | 0.0 | Shifts palette brightness toward black/white. -1.0 darkens every family, 0.0 keeps the native scale, 1.0 brightens every family. |
| `contrast` | number | -1.0–1.0 | 0.0 | Adjusts overall brightness contrast around a midpoint. |

### Semantic Color Overrides

Define custom semantic colors for common UI elements:

```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
  red = '#E86671',
  green = '#A9DC76',
  yellow = '#E7C547',
  orange = '#FFA94D',
  blue = '#7AA2F7',
  purple = '#A37EE5',
  cyan = '#78DCE8',
})
```

### UI Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `transparent` | boolean | false | Enable transparent background. |
| `decorations.borders` | boolean | true | Enable border decorations for UI elements. |

### Integrations

Terminal integration options:

```lua
require('xeno').setup({
  integrations = {
    ghostty = {
      enabled = true,          -- Enable Ghostty terminal integration
      update_config = true,    -- Auto-update Ghostty config file
    },
  },
})
```

## API Reference

### `xeno.setup(config)`

Initialize xeno and apply colorscheme immediately.

**Parameters:**
- `config` (table) — Configuration options (background, accent, etc.)

**Returns:** nil

**Example:**
```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
  lightness = 0.1,
  contrast = 0.1,
})
vim.cmd('colorscheme xeno')
```

### `xeno.config(config)`

Set global configuration merged into subsequent `xeno.theme()` calls. Useful with lazy.nvim opts.

**Parameters:**
- `config` (table) — Configuration to merge globally

**Returns:** nil

**Example:**
```lua
require('xeno').config({
  transparent = true,
  integrations = { ghostty = { enabled = true } },
})
```

### `xeno.theme(name, config)`

Generate a standalone colorscheme file.

**Parameters:**
- `name` (string) — Colorscheme name (e.g., 'my-theme')
- `config` (table) — Theme-specific configuration

**Returns:** nil

**Example:**
```lua
require('xeno').theme('forest', {
  background = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme forest')
```

### `xeno.get_colors()`

Returns the current color palette table (same as `xeno.colors`).

**Returns:** table of generated colors

**Example:**
```lua
local colors = require('xeno').get_colors()
print(colors.foreground_50)   -- Lightest foreground
print(colors.background_950)  -- Darkest background
print(colors.accent_500)      -- Mid-tone accent
```

### `xeno.colors`

Direct access to generated color table (available after `xeno.setup()`).

**Contains:**
- `foreground_50` through `foreground_400` — Foreground shades
- `background_500` through `background_950` — Background shades
- `accent_50` through `accent_600` — Accent shades
- Semantic colors: `red`, `green`, `yellow`, `orange`, `blue`, `purple`, `cyan`
- Custom colors from `xeno.color()` — e.g., `my_purple_50` through `my_purple_600`

**Example:**
```lua
require('xeno').setup({ background = '#1E1E1E', accent = '#8CBE8C' })

-- Access colors directly
local fg = require('xeno').colors.foreground_50
local bg = require('xeno').colors.background_950

-- Or via metatable shorthand
local accent = require('xeno').accent_500
```

## Custom Colors

### `xeno.color(name, hex_value)`

Define a custom color family that generates shades 50–600, usable in highlights.

**Parameters:**
- `name` (string) — Color family name (alphanumeric + underscores)
- `hex_value` (string) — Hex color value (e.g., '#8b5cf6')

**Returns:** xeno module (allows chaining)

**Example:**
```lua
local xeno = require('xeno')

xeno.color('my_purple', '#8b5cf6')
xeno.color('my_pink', '#ec4899')

xeno.setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
})

-- Now use @my_purple.50 through @my_purple.600 in highlights
-- and @my_pink.50 through @my_pink.600
```

**Method Chaining:**
```lua
require('xeno')
  .color('purple', '#8b5cf6')
  .color('pink', '#ec4899')
  .setup({ background = '#1E1E1E', accent = '#8CBE8C' })
```

## Highlights

### Highlight Overrides

Customize highlights in three categories:

```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
  highlights = {
    editor = {
      -- Editor UI highlights (Normal, LineNr, CursorLine, etc.)
      Normal = { bg = '@background.950', fg = '@foreground.50' },
      LineNr = { fg = '@foreground.300' },
    },
    syntax = {
      -- Syntax highlights (Comment, String, Function, etc.)
      Comment = { fg = '@foreground.300', italic = true },
      String = { fg = '@accent.500' },
      Function = { fg = '@blue.400' },
    },
    plugins = {
      -- Plugin-specific highlights by plugin name
      ["nvim-telescope/telescope.nvim"] = {
        TelescopeNormal = { bg = '@background.900' },
      },
    },
  },
})
```

### Color Reference Syntax

Use `@family.shade` in highlight definitions:

```lua
-- Palette families
'@foreground.50'      -- Foreground shades: 50, 100, 200, 300, 400
'@background.950'     -- Background shades: 500, 600, 700, 800, 900, 950
'@accent.300'         -- Accent shades: 50, 100, 200, 300, 400, 500, 600

-- Semantic colors (shorthand, no shade needed)
'@red'                -- Resolves to red semantic color
'@blue'               -- Resolves to blue semantic color

-- Custom colors (from xeno.color())
'@my_purple.100'      -- Custom color shades: 50–600
'@my_pink.500'

-- Direct hex
'#8b5cf6'

-- Vim standard colors
'red', 'blue', 'white', etc.
```

### Plugin Configuration

Configure 26+ supported plugins via highlights.plugins:

```lua
require('xeno').setup({
  highlights = {
    plugins = {
      ["nvim-telescope/telescope.nvim"] = {
        bg = "@background.950",
        fg = "@foreground.50",
        border = "@accent.600",
      },
      ["akinsho/bufferline.nvim"] = {
        selected_bg = "@background.700",
        visible_bg = "@background.900",
        separator = "@background.600",
      },
      ["nvim-tree/nvim-tree.lua"] = {
        bg = "@background.800",
        fg = "@foreground.200",
        folder_fg = "@accent.300",
      },
    },
  },
})
```

Supported plugins: telescope, fzf-lua, nvim-cmp, blink.cmp, nvim-navic, todo-comments, indent-blankline, indentmini, neo-tree, nvim-tree, gitsigns, bufferline, toggleterm, trouble, snacks, neogit, render-markdown, diffview, dropbar, glance, grug-far, markview, which-key, nvim-scrollbar, avante, octo.

## Namespace Support

Create per-window theme variants with namespaces.

### `xeno.namespace(name, highlights_override)`

Create a namespace with custom highlight overrides.

**Parameters:**
- `name` (string) — Namespace identifier
- `highlights_override` (table, optional) — Highlight overrides for this namespace

**Returns:** namespace ID

**Example:**
```lua
require('xeno').setup({ background = '#1E1E1E', accent = '#8CBE8C' })

-- Create a focused namespace with dimmed non-active highlights
require('xeno').namespace('focused', {
  editor = {
    Normal = { bg = '@background.850' },
    Comment = { fg = '@foreground.250' },
  }
})
```

### `xeno.set_window_namespace(win_id, namespace_name)`

Apply a namespace to a specific window.

**Parameters:**
- `win_id` (number, optional) — Window ID (0 = current window)
- `namespace_name` (string) — Namespace identifier

**Returns:** namespace ID or nil on error

**Example:**
```lua
-- Apply namespace to current window
require('xeno').set_window_namespace(0, 'focused')

-- Apply to specific window
require('xeno').set_window_namespace(vim.fn.win_getid(1, 0), 'focused')
```

## Export

### `xeno.export(config)`

Export the current theme as a standalone Lua colorscheme file.

**Parameters:**
- `config` (table, optional) — Export configuration
  - `format` (string) — Export format, currently 'lua' only
  - `dir` (string) — Output directory (supports ~ expansion, default: ~/.config/nvim/colors/)

**Returns:** table with export metadata (path, filename, format, size, color/highlight counts)

**Example:**
```lua
require('xeno').setup({ background = '#1E1E1E', accent = '#8CBE8C' })

-- Export to default directory
local result = require('xeno').export()
print('Exported to:', result.path)

-- Export to custom directory
local result = require('xeno').export({
  format = 'lua',
  dir = '~/.config/nvim/colors/',
})
```

## Terminal Integration

### Automatic Terminal Colors

xeno automatically configures terminal colors during `xeno.setup()`, syncing with your colorscheme.

### Ghostty Integration

Enable Ghostty terminal configuration auto-update:

```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
  integrations = {
    ghostty = {
      enabled = true,          -- Enable integration
      update_config = true,    -- Auto-write to Ghostty config
    },
  },
})
```

## Troubleshooting

### Colors not applying

**Solution:**
- Ensure you call `vim.cmd('colorscheme xeno')` after `xeno.setup()`
- Enable true color support: `:set termguicolors`
- Check that terminal supports 24-bit color

### Color references not working

**Common mistakes:**
- Using invalid shade numbers (e.g., `@foreground.500` doesn't exist)
- Forgetting the `@` prefix (must be `@background.700`, not `background.700`)
- Using wrong family names (typo in `foreground`/`background`/`accent`)

**Valid shade ranges:**
- `foreground`: 50, 100, 200, 300, 400
- `background`: 500, 600, 700, 800, 900, 950
- `accent`: 50, 100, 200, 300, 400, 500, 600
- Custom colors from `xeno.color()`: 50, 100, 200, 300, 400, 500, 600

### Theme file not found

**Solution:**
- Call `xeno.theme('name', config)` before loading the generated colorscheme
- Check that the colorscheme file was created in `~/.config/nvim/colors/`
- Verify the colorscheme name matches what you passed to `xeno.theme()`

### Ghostty config not updating

**Check:**
- `integrations.ghostty.update_config` is set to `true`
- Ghostty config file exists at default location
- No permission issues writing to Ghostty config directory

### Deprecated function warnings

**Note:**
- `xeno.new_theme()` is deprecated. Use `xeno.theme()` instead.
