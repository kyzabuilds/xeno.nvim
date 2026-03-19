# xeno.nvim

Minimalist colorscheme generator for Neovim.

**Author:** kyza0d  
**License:** Same terms as Vim itself

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Configuration](#configuration)
5. [API Reference](#api-reference)
6. [Examples](#examples)
7. [Integrations](#integrations)
8. [Troubleshooting](#troubleshooting)

## Introduction

xeno.nvim builds a complete theme from a background seed, an accent seed, and an optional foreground override:

- `foreground` (50-400, derived from `background` when omitted)
- `background` (500-950)
- `accent` (50-600)

**Key Features:**
- Background-derived foreground palette with optional explicit override
- Custom highlight overrides with `@color.shade` references
- Built-in support for popular Neovim plugins
- Terminal color integration including Ghostty support
- Namespace support for per-window theming

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

## Usage

### Basic Setup

```lua
require('xeno').setup({
  foreground = '#F8F8F2', -- Primary text seed
  background = '#1E1E1E', -- Primary surface seed
  accent = '#8CBE8C',     -- Accent seed
})
vim.cmd('colorscheme xeno')
```

### Generate Theme Files

```lua
require('xeno').theme('my-dark-theme', {
  background = '#1E1E1E',
  accent = '#8CBE8C',
})

vim.cmd('colorscheme my-dark-theme')
```

## Configuration

### Configuration Options

| Option | Type | Description | Default |
|--------|------|-------------|---------|
| `foreground` | string | Optional foreground override (hex). When omitted, foreground shades derive from `background`. | — |
| `background` | string | Background seed color (hex) | — |
| `accent` | string | Accent seed color (hex) | — |
| `variation` | number | Color variation amount (0.0 to 1.0) | 0.0 |
| `contrast` | number | Contrast adjustment (-1.0 to 1.0) | 0.0 |
| `transparent` | boolean | Enable transparent background | false |

### Semantic Colors

Optional semantic overrides:
- `red`
- `green`
- `yellow`
- `orange`
- `blue`
- `purple`
- `cyan`

### Highlights

The `highlights` table supports:
- `editor`
- `syntax`
- `plugins`

### Integrations

The `integrations` table supports:
- `ghostty.enabled` (boolean)
- `ghostty.update_config` (boolean)

### Example Configuration

```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
  variation = 0.1,
  contrast = 0.05,
  transparent = false,

  red = '#E86671',
  blue = '#7AA2F7',

  highlights = {
    editor = {
      Normal = { bg = '@background.950', fg = '@foreground.50' },
    },
    syntax = {
      Comment = { fg = '@foreground.300', italic = true },
      String = { fg = '@accent.500' },
    },
    plugins = {
      NvimTree = {
        NvimTreeNormal = { bg = '@background.900' },
      },
    },
  },
})
```

### Color Reference Syntax

Use `@foreground.XXX`, `@background.XXX`, and `@accent.XXX`:

| Family | Valid shades |
|--------|--------------|
| `foreground` | `50, 100, 200, 300, 400` |
| `background` | `500, 600, 700, 800, 900, 950` |
| `accent` | `50, 100, 200, 300, 400, 500, 600` |

### Plugin Configuration

```lua
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
}
```

## API Reference

### `xeno.setup({config})`

Initialize xeno with configuration.

### `xeno.theme({name}, {config})`

Generate a colorscheme file.

### `xeno.config({config})`

Set global configuration used by `xeno.theme()`.

### `xeno.namespace({name}, {highlights})`

Create a namespaced theme variant.

### `xeno.set_window_namespace({win_id}, {namespace_name})`

Apply a namespace to a window.

### `xeno.colors`

Generated color table after `xeno.setup()`.

Contains:
- `foreground_50` through `foreground_400`
- `background_500` through `background_950`
- `accent_50` through `accent_600`
- semantic colors (`red`, `green`, `yellow`, `orange`, `blue`, `purple`, `cyan`)

## Examples

### Dark Theme

```lua
require('xeno').setup({
  background = '#1E1E1E',
  accent = '#8CBE8C',
})
```

### Light Theme

```lua
require('xeno').setup({
  foreground = '#1E1E1E',
  background = '#FFFFFF',
  accent = '#2E7D32',
})
```

### High Contrast

```lua
require('xeno').setup({
  foreground = '#FFFFFF',
  background = '#000000',
  accent = '#7AA2F7',
  contrast = 0.3,
})
```

### Generate Multiple Themes

```lua
local xeno = require('xeno')

xeno.config({
  transparent = true,
  integrations = { ghostty = { enabled = true } },
})

xeno.theme('forest', { foreground = '#F8F8F2', background = '#1E1E1E', accent = '#8CBE8C' })
xeno.theme('ocean',  { foreground = '#F8F8F2', background = '#1E1E1E', accent = '#7AA2F7' })
xeno.theme('sunset', { foreground = '#F8F8F2', background = '#1E1E1E', accent = '#FF7A93' })
```

## Integrations

### Terminal Integration

xeno configures terminal colors during `xeno.setup()`.

### Ghostty Integration

```lua
require('xeno').setup({
  foreground = '#F8F8F2',
  background = '#1E1E1E',
  accent = '#8CBE8C',
  integrations = {
    ghostty = {
      enabled = true,
      update_config = true,
    },
  },
})
```

## Troubleshooting

**Colors not applying:**
- Call `vim.cmd('colorscheme xeno')` after `xeno.setup()`
- Ensure true color is enabled: `:set termguicolors`

**Invalid color references:**
- Use `@family.shade` form (example: `@background.700`)
- Core family shade ranges:
  - `foreground`: 50-400
  - `background`: 500-950
  - `accent`: 50-600

**Theme file not found:**
- Call `xeno.theme()` before loading generated theme
