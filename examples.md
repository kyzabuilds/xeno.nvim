# Theme Examples

## Custom Highlights

### Creating Custom Colors

Define custom colors that can be used throughout your theme:

```lua
local xeno = require('xeno')

xeno.color('my_purple', '#8b5cf6') -- Generates @my_purple.50 - @my_purple.950 

xeno.setup({
  -- your theme config
})
```

### Custom Plugin Highlights

Configure plugin themes using high-level configuration options. For a complete list of all available plugin configurations, see [plugins.md](plugins.md).

```lua
xeno.setup({
  highlights = {
    plugins = {
      ['nvim-telescope/telescope.nvim'] = {
        selection_bg = '@my_purple',
        match_fg = '@accent'
      },
      ['hrsh7th/nvim-cmp'] = {
        selected_bg = '@base.600',
        match_fg = '@my_purple.500',
        kind_fg = '@base.500'
      }
    },
  }
})
```

### Color References

You can reference colors in multiple ways:
- Custom colors: `'@my_purple'`, `'@accent_red'`
- Palette colors: 
  - `'@base.50'` - `'@base.950'`
  - `'@accent.50'`- `'@accent.950'`
- Direct hex values: `'#8b5cf6'`
- Standard colors: `'white'`, `'black'`, `'red'`, etc.

### Shading System

**Available shade levels:** 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950

**Fallback behavior:** When no shade level is specified (e.g., `@my_color`), it automatically falls back to the 500 level (`@my_color.500`).

