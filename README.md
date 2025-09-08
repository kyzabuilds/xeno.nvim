<img title="xeno banner" alt="xeno banner" src="./media/banner.png">

<p align='center'>
  Colorscheme generator that creates minimalist themes using two colors.<br/>
  Explore <a href="examples.md">theme examples</a> and <a href="plugins.md">supported plugins</a>.
</p>

## Installation

**lazy.nvim**
```lua
{
  'kyza0d/xeno.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('xeno').new_theme('my-theme', {
      base = '#1E1E1E',
      accent = '#8CBE8C',
    })
    vim.cmd('colorscheme my-theme')
  end,
}
```

**mini.deps**
```lua
local MiniDeps = require('mini.deps')
MiniDeps.add('kyza0d/xeno.nvim')

require('xeno').new_theme('my-theme', {
  base = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme my-theme')
```

## Features

- **Minimal Configuration**: Generate complete themes with just two colors
- **Automatic Palette Generation**: Creates 9 shades for each color automatically
- **Custom Highlights**: Override any highlight group with flexible color references
- **Plugin Support**: Built-in support for popular Neovim plugins
- **Color References**: Use `@base.500` or `@accent.200` syntax for dynamic color mapping
- **Terminal Integration**: Automatically configures terminal colors

## Plugin Configuration

Customize plugin themes using high-level options:

```lua
require('xeno').new_theme('my-theme', {
  base = '#1a1a1a',
  accent = '#7aa2f7',
  highlights = {
    plugins = {
      ["nvim-telescope/telescope.nvim"] = {
        bg = "@base.950",
        fg = "@base.50", 
        border = "@accent.500",
      },
      ["akinsho/bufferline.nvim"] = {
        selected_bg = "@base.700",
        visible_bg = "@base.900",
        separator = "@base.600",
      },
      ["nvim-tree/nvim-tree.lua"] = {
        bg = "@base.800",
        fg = "@base.200",
        folder_fg = "@accent.300",
      },
    },
  },
})
```

This provides intuitive controls over plugin appearance while maintaining full compatibility with granular highlight overrides.

## Customization

xeno.nvim supports extensive customization through the `highlights` parameter. See [examples.md](examples.md) for detailed configuration examples and color combinations.
