<img title="xeno banner" alt="xeno banner" src="./media/banner.png">

<p align='center'>
  <a href="examples.md">Examples</a> | <a href="plugins.md">Plugins</a> | <a href="CONFIGURATION.md">Configuration</a> | <a href="API.md">API</a>
</p>


<p align='center'>
  <strong>Minimalist three-seed colorscheme generator with automatic light/dark mode support</strong><br/>
  Create complete themes from background and accent seeds, with foreground derived automatically unless overridden • Extensive theming API • Export capabilities<br/>
  Explore <a href="examples.md">examples</a> and <a href="plugins.md">plugins</a>
</p>

## Key Features

- **Automatic Light/Dark Mode** - Seamlessly adapts to `vim.o.background` changes
- **Background-Derived Foreground** - Foreground shades default to the background seed's hue/chroma and can still be overridden explicitly
- **Extensive Theming API** - Granular control over every highlight group
- **Export Capabilities** - Generate standalone colorscheme files
- **Plugin Integration** - Built-in support for 20+ popular plugins
- **Familiar Color System** - Familiar color scales with `50-950`

## Installation

**lazy.nvim**
```lua
{
  'kyza0d/xeno.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('xeno').theme('my-theme', {
      background = '#1E1E1E',
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

require('xeno').theme('my-theme', {
  background = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme my-theme')
```

## Plugin Configuration

Customize plugin themes using high-level options:

```lua
require('xeno').theme('my-theme', {
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
      ["nvim-tree/nvim-tree.lua"] = {
        bg = "@background.800",
        fg = "@foreground.200",
        folder_fg = "@accent.300",
      },
    },
  },
})
```

This provides intuitive controls over plugin appearance while maintaining full compatibility with granular highlight overrides.

## Customization

xeno.nvim supports extensive customization through the `highlights` parameter. See [examples.md](examples.md) for detailed configuration examples and color combinations.
