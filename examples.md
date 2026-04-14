# Theme Examples

This document showcases example themes for the Xeno styling plugin, demonstrating how to create and customize themes with custom colors, highlights, and plugin integrations. Themes are categorized by complexity: Minimal, Standard, and Extensive. Use the table of contents below to navigate the available sections and themes.

## Table of Contents

- [Custom Highlights](#custom-highlights)
  - [Creating Custom Colors](#creating-custom-colors)
  - [Custom Plugin Highlights](#custom-plugin-highlights)
  - [Color References](#color-references)
  - [Shading System](#shading-system)
- [Theme Showcases](#theme-showcases)
  - [Minimal Themes](#minimal-themes)
  - [Extensive Themes](#extensive-themes)

## Custom Highlights

### Creating Custom Colors

Define custom colors that can be used throughout your theme. Custom colors use the same family layout as `accent`, so Xeno generates `.50` through `.600` for each one.

```lua
local xeno = require('xeno')

xeno.color('my_purple', '#8b5cf6') -- Generates @my_purple.50 - @my_purple.600

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
        selected_bg = '@background.600',
        match_fg = '@my_purple.500',
        kind_fg = '@background.500'
      }
    },
  }
})
```

### Color References

You can reference colors in multiple ways:
- **Custom colors**: `'@my_purple'`, `'@accent_red'`
- **Palette colors**:
  - `'@foreground.50'` - `'@foreground.400'`
  - `'@background.500'` - `'@background.950'`
  - `'@accent.50'` - `'@accent.600'`
- **Semantic colors**: `'green'`, `'red'`, `'blue'`, `'yellow'`, `'orange'`, `'purple'`, `'cyan'`
- **Direct hex values**: `'#8b5cf6'`
- **Standard colors**: `'white'`, `'black'`, `'red'`, etc.

### Shading System

Xeno does not expose one universal `50-950` ramp for every color family. Each family has its own valid slots:

- **`foreground`**: `50, 100, 200, 300, 400`
- **`background`**: `500, 600, 700, 800, 900, 950`
- **`accent`**: `50, 100, 200, 300, 400, 500, 600`
- **Custom colors from `xeno.color()`**: `50, 100, 200, 300, 400, 500, 600`

Shade numbers are semantic positions inside a family, not a guarantee that the same number means the same absolute brightness across families.

- In dark themes, `foreground.50` is the strongest/lightest text and `background.950` is the deepest surface.
- In light themes, those roles stay the same semantically, but the actual luminance flips: foreground shades become darker and background shades become lighter.
- Lower `foreground` numbers mean higher text emphasis. Higher `background` numbers mean deeper surface emphasis.

`foreground` is optional. When omitted, Xeno derives the foreground family from the `background` seed so text keeps the same hue/chroma character as the surfaces. If you pass an explicit `foreground`, that seed is used instead.

When you omit the shade in a reference, Xeno resolves it to `.500`. That makes `@accent`, `@my_purple`, and similar references shorthand for `@accent.500` and `@my_purple.500`.

The generated foreground family is also contrast-aware: Xeno adjusts the foreground scale so `foreground.50` through `foreground.400` remain legible against the text surfaces (`background.800`, `background.900`, and `background.950`).

To understand the design system behind these scales in more detail, read https://www.ui-lab.app/design-system/colors.

## Theme Showcases

Themes are categorized by complexity:
- **Minimal Themes**: Simple color schemes with basic foreground, background, and accent colors, minimal highlight customizations, and no custom colors or plugin integrations.
- **Standard Themes**: Moderate complexity with custom colors, basic plugin integrations, and a balanced set of highlight customizations.
- **Extensive Themes**: Highly detailed themes with extensive custom colors, plugin integrations, and comprehensive highlight configurations.

### Minimal Themes

Minimal themes focus on simplicity, using only foreground, background, and accent colors with basic editor and syntax highlights.

<details>
  <summary><strong>Xeno Latte</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Background | #14110f  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #14110f"></span> |
  | Accent     | #bf8f7f  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #bf8f7f"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('xeno-latte', {
  background = '#14110f',
  accent = '#bf8f7f',
  variation = 0.9,
})
  ```
</details>

<details>
  <summary><strong>Xeno Phantom</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Background | #0c0b0f  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #0c0b0f"></span> |
  | Accent     | #BAA8C0  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #BAA8C0"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('xeno-phantom', {
  background = '#0c0b0f',
  accent = '#BAA8C0',
  contrast = -0.3,
  variation = 0.9,
})
  ```
</details>

<details>
  <summary><strong>Xeno Sylvan</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Background | #151615  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #151615"></span> |
  | Accent     | #3b594e  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #3b594e"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('xeno-sylvan', {
  background = '#151615',
  accent = '#3b594e',
  contrast = -0.3,
  variation = 0.9,
})
  ```
</details>

<details>
  <summary><strong>Xeno Onyx</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Background | #161616  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #161616"></span> |
  | Accent     | #dbdbdb  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #dbdbdb"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('xeno-onyx', {
  background = '#161616',
  accent = '#dbdbdb',
  variation = 0.8,
})
  ```
</details>

<details>
  <summary><strong>Xeno Emerald</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Background | #1c3029  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #1c3029"></span> |
  | Accent     | #49b27f  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #49b27f"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('xeno-emerald', {
  background = '#1c3029',
  accent = '#49b27f',
  variation = 0.7,
  chroma = 0.1,
  lightness = 0.1,
})
  ```
</details>

### Extensive Themes

<details>
  <summary><strong>Byte</strong></summary>

  | Color Name     | Hex Code | Preview |
  |----------------|----------|---------|
  | Background     | #101010  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #101010"></span> |
  | RedStone       | #E07070  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #E07070"></span> |
  | MartinaOlive   | #909040  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #909040"></span> |
  | BrightNori     | #206020  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #206020"></span> |
  | PictonBlue     | #569CD6  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #569CD6"></span> |
  | Accent         | #3D537A  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #3D537A"></span> |

  ```lua
local xeno = require('xeno')

-- Define custom colors
xeno.color('red_stone', '#E07070')
xeno.color('martina_olive', '#909040')
xeno.color('bright_nori', '#206020')
xeno.color('picton_blue', '#569CD6')

xeno.theme('byte', {
  contrast = 0.25,
  variation = -0.4,
  foreground = '#F8F8F2', -- Primary text seed
  background = '#101010', -- Dark background
  accent = '#3D537A', -- Blue accent
  red = '#E58E89',
  green = '#00FF00',
  yellow = '#F7C95C',
  blue = '#93DDFA',
  purple = '#E58AC9',
  orange = '#FFA94D',
  highlights = {
    editor = {
      Normal = { bg = '@background.900', fg = '@foreground.100' },
      Comment = { fg = '@bright_nori.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@foreground.400' },
      Title = { fg = '@foreground.400' },
      String = { fg = '@red_stone.300' },
      Quote = { fg = '@red_stone.300' },
      Character = { fg = '@red_stone.300' },
      Conditional = { fg = '@martina_olive' },
      Tag = { fg = '@martina_olive' },
      Repeat = { fg = '@martina_olive' },
      Statement = { fg = '@martina_olive' },
      Return = { fg = '@martina_olive' },
      Label = { fg = '@martina_olive' },
      Exception = { fg = '@martina_olive' },
      Include = { fg = '@martina_olive' },
      PreCondit = { fg = '@martina_olive' },
      Define = { fg = '@martina_olive' },
      Macro = { fg = '@martina_olive' },
      PreProc = { fg = '@martina_olive' },
      StorageClass = { fg = '@martina_olive' },
      Typedef = { fg = '@martina_olive' },
      Number = { fg = 'green' },
      Float = { fg = 'green' },
      Boolean = { fg = 'green' },
      Todo = { fg = 'green' },
      Type = { fg = '@picton_blue.300' },
      Function = { fg = '@picton_blue.500' },
      Method = { fg = '@picton_blue.500' },
      Constant = { fg = '@foreground.400' },
      Special = { fg = '@background.500' },
      SpecialChar = { fg = '@background.500' },
      Delimiter = { fg = '@background.600' },
      Operator = { fg = '@background.500' },
      SpecialKey = { fg = '@background.500' },
      Error = { fg = '#E58E89' },
      SpecialComment = { fg = '@bright_nori.600' },
      ['@text.literal'] = { link = 'Comment' },
      ['@text.reference'] = { link = 'Identifier' },
      ['@text.title'] = { link = 'Title' },
      ['@text.uri'] = { link = 'Underlined' },
      ['@text.underline'] = { link = 'Underlined' },
      ['@text.todo'] = { link = 'Todo' },
      ['@comment'] = { link = 'Comment' },
      ['@punctuation'] = { link = 'Delimiter' },
      ['@punctuation.bracket'] = { link = 'Delimiter' },
      ['@constant'] = { link = 'Constant' },
      ['@constant.macro'] = { link = 'Define' },
      ['@define'] = { link = 'Define' },
      ['@macro'] = { link = 'Macro' },
      ['@string'] = { link = 'String' },
      ['@string.escape'] = { link = 'SpecialChar' },
      ['@string.special'] = { link = 'SpecialChar' },
      ['@string.regexp'] = { link = 'SpecialChar' },
      ['@character'] = { link = 'Character' },
      ['@character.special'] = { link = 'SpecialChar' },
      ['@number'] = { link = 'Number' },
      ['@boolean'] = { link = 'Boolean' },
      ['@float'] = { link = 'Float' },
      ['@parameter'] = { link = 'Identifier' },
      ['@field'] = { link = 'Special' },
      ['@property'] = { link = 'Special' },
      ['@constructor'] = { link = 'Special' },
      ['@repeat'] = { link = 'Repeat' },
      ['@label'] = { link = 'Label' },
      ['@operator'] = { link = 'Operator' },
      ['@keyword'] = { link = 'Macro' },
      ['@function'] = { link = 'Function' },
      ['@keyword.return'] = { link = 'Return' },
      ['@keyword.operator'] = { link = 'Macro' },
      ['@keyword.repeat'] = { link = 'Repeat' },
      ['@keyword.conditional'] = { link = 'Conditional' },
      ['@lsp.type.method'] = { link = 'Method' },
      ['@lsp.typemod.function'] = { link = 'Function' },
      ['@exception'] = { link = 'Exception' },
      ['@variable'] = { fg = '@background.500' },
      ['@type'] = { link = 'Type' },
      ['@type.definition'] = { link = 'Typedef' },
      ['@type.builtin'] = { link = 'Special' },
      ['@storageclass'] = { link = 'StorageClass' },
      ['@structure'] = { link = 'Structure' },
      ['@namespace'] = { link = 'Identifier' },
      ['@include'] = { link = 'Include' },
      ['@preproc'] = { link = 'PreProc' },
      ['@debug'] = { link = 'Debug' },
      ['@tag'] = { link = 'Tag' },
      ['@tag.delimiter'] = { link = 'Delimiter' },
      ['@constructor.lua'] = { link = 'Delimiter' },
    },
    plugins = {
      ['nvim-telescope/telescope.nvim'] = {
        selection_bg = '@picton_blue.600',
        match_fg = '@red_stone.400',
      },
      ['hrsh7th/nvim-cmp'] = {
        selected_bg = '@background.600',
        match_fg = '@picton_blue.500',
        kind_fg = '@background.500',
      },
    },
  },
})
  ```
</details>
