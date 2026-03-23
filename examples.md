# Theme Examples

This document showcases example themes for the Xeno styling plugin, demonstrating how to create and customize themes with custom colors, highlights, and plugin integrations. Themes are categorized by complexity: Minimal, Standard, and Extensive. Use the table of contents below to navigate the available sections and themes.

## Table of Contents

- [Custom Highlights](#custom-highlights)
  - [Creating Custom Colors](#creating-custom-colors)
  - [Custom Plugin Highlights](#custom-plugin-highlights)
  - [Color References](#color-references)
  - [Shading System](#shading-system)
- [Theme Showcases](#theme-showcases)
  - [Extensive Themes](#extensive-themes)

## Custom Highlights

### Creating Custom Colors

Define custom colors that can be used throughout your theme. Xeno automatically generates shades from `.50` to `.950` for each custom color.

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
- **Direct hex values**: `'#8b5cf6'`
- **Standard colors**: `'white'`, `'black'`, `'red'`, etc.

### Shading System

**Available shade levels**: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950

**Fallback behavior**: When no shade level is specified (e.g., `@my_color`), it automatically falls back to the 500 level (`@my_color.500`).

**Foreground behavior**: `foreground` is optional. If you omit it, Xeno derives `@foreground.*` from the `background` seed and keeps explicit `foreground` as an override when you need it.

## Theme Showcases

Themes are categorized by complexity:
- **Minimal Themes**: Simple color schemes with basic foreground, background, and accent colors, minimal highlight customizations, and no custom colors or plugin integrations.
- **Standard Themes**: Moderate complexity with custom colors, basic plugin integrations, and a balanced set of highlight customizations.
- **Extensive Themes**: Highly detailed themes with extensive custom colors, plugin integrations, and comprehensive highlight configurations.

### Minimal Themes

Minimal themes focus on simplicity, using only foreground, background, and accent colors with basic editor and syntax highlights.

### Extensive Themes

Extensive themes feature comprehensive color palettes, detailed highlight configurations, and advanced plugin integrations for a rich appearance.

<details>
  <summary><strong>Summer Night</strong></summary>
  Source: https://github.com/jackw01/summer-night-vscode-theme


  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Camellia   | #FA5F8B  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #FA5F8B"></span> |
  | Coral      | #F06C6F  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #F06C6F"></span> |
  | Ember      | #E17954  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #E17954"></span> |
  | Topaz      | #D08447  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #D08447"></span> |
  | Bamboo     | #D3AB58  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #D3AB58"></span> |
  | Arcadia    | #00AB9A  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #00AB9A"></span> |
  | Bluebird   | #00A9B9  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #00A9B9"></span> |
  | Malibu     | #00A3D2  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #00A3D2"></span> |

  ```lua
local xeno = require('xeno')

-- Define custom colors
xeno.color('camellia', '#FA5F8B')
xeno.color('coral', '#F06C6F')
xeno.color('ember', '#E17954')
xeno.color('topaz', '#D08447')
xeno.color('bamboo', '#D3AB58')
xeno.color('arcadia', '#00AB9A')
xeno.color('bluebird', '#00A9B9')
xeno.color('malibu', '#00A3D2')

xeno.theme('summer-night', {
  contrast = 0.1,
  variation = -0.3,
  foreground = '#F8F8F2', -- Primary text seed
  background = '#353A44', -- Dark background
  accent = '#00A6BC', -- Bluebird accent
  red = '#FA5F8B',
  green = '#00AB9A',
  yellow = '#D3AB58',
  blue = '#00A3D2',
  purple = '#FA5F8B',
  orange = '#E17954',
  highlights = {
    editor = {
      Normal = { bg = '@background.900', fg = '@foreground.400' },
      Comment = { fg = '@background.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@foreground.400' },
      Title = { fg = '@bamboo' },
      String = { fg = '@bamboo.400' },
      Quote = { fg = '@camellia' },
      Character = { fg = '@camellia' },
      Conditional = { fg = '@camellia.300' },
      Tag = { fg = '@topaz' },
      Repeat = { fg = '@camellia.300' },
      Statement = { fg = '@topaz' },
      Return = { fg = '@camellia.300' },
      Label = { fg = '@topaz' },
      Exception = { fg = '@topaz' },
      Include = { fg = '@topaz' },
      PreCondit = { fg = '@topaz' },
      Define = { fg = '@topaz' },
      Macro = { fg = '@camellia.300' },
      PreProc = { fg = '@topaz' },
      StorageClass = { fg = '@topaz' },
      Typedef = { fg = '@topaz.300' },
      Number = { fg = '@coral.300' },
      Float = { fg = '@ember.400' },
      Boolean = { fg = '@ember.400' },
      Todo = { fg = '@bamboo' },
      Type = { fg = '@malibu' },
      Function = { fg = '@malibu.500' },
      Method = { fg = '@ember.400' },
      Constant = { fg = '@ember.400' },
      Special = { fg = '@foreground.400' },
      SpecialChar = { fg = '@background.500' },
      Delimiter = { fg = '@foreground.400' },
      Operator = { fg = '@background.500' },
      SpecialKey = { fg = '@foreground.400' },
      Error = { fg = '@coral' },
      SpecialComment = { fg = '@arcadia.600' },
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
      ['@constant.builtin'] = { link = 'Constant' },
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
      ['@function.macro'] = { fg = '@coral.300' },
      ['@keyword.return'] = { link = 'Return' },
      ['@keyword.operator'] = { link = 'Macro' },
      ['@keyword.repeat'] = { link = 'Repeat' },
      ['@keyword.conditional'] = { link = 'Conditional' },
      ['@keyword.conditional.ternary'] = { link = 'Delimiter' },
      ['@lsp.type'] = { link = 'Delimiter' },
      ['@lsp.type.method'] = { link = 'Method' },
      ['@lsp.typemod.function'] = { link = 'Function' },
      ['@exception'] = { link = 'Exception' },
      ['@variable'] = { fg = '@foreground.300' },
      ['@variable.member'] = { fg = '@topaz.500' },
      ['@variable.parameter'] = { fg = '@ember.400' },
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
      ['@tag.attribute'] = { link = 'Tag' },
      ['@tag.delimiter'] = { link = 'Delimiter' },
      ['@constructor.lua'] = { link = 'Delimiter' },
    },
    plugins = {
      ['nvim-telescope/telescope.nvim'] = {
        selection_bg = '@bluebird.600',
        match_fg = '@camellia.400',
      },
      ['hrsh7th/nvim-cmp'] = {
        selected_bg = '@background.600',
        match_fg = '@malibu.500',
        kind_fg = '@background.500',
      },
    },
  },
})
  ```
</details>

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
