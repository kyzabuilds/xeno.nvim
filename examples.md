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
  - [Standard Themes](#standard-themes)
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
- **Custom colors**: `'@my_purple'`, `'@accent_red'`
- **Palette colors**: 
  - `'@base.50'` - `'@base.950'`
  - `'@accent.50'` - `'@accent.950'`
- **Direct hex values**: `'#8b5cf6'`
- **Standard colors**: `'white'`, `'black'`, `'red'`, etc.

### Shading System

**Available shade levels**: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950

**Fallback behavior**: When no shade level is specified (e.g., `@my_color`), it automatically falls back to the 500 level (`@my_color.500`).

## Theme Showcases

Themes are categorized by complexity:
- **Minimal Themes**: Simple color schemes with basic base and accent colors, minimal highlight customizations, and no custom colors or plugin integrations.
- **Standard Themes**: Moderate complexity with custom colors, basic plugin integrations, and a balanced set of highlight customizations.
- **Extensive Themes**: Highly detailed themes with extensive custom colors, plugin integrations, and comprehensive highlight configurations.

### Minimal Themes

Minimal themes focus on simplicity, using only base and accent colors with basic editor and syntax highlights.

<details>
  <summary><strong>Dusk</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Base       | #2E3440  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #2E3440; border: 1px solid #000; vertical-align: middle;"></span> |
  | Accent     | #88C0D0  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #88C0D0; border: 1px solid #000; vertical-align: middle;"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('dusk', {
  base = '#2E3440', -- Dark nordic background
  accent = '#88C0D0', -- Soft cyan accent
  highlights = {
    editor = {
      Normal = { bg = '@base.900', fg = '@base.300' },
      Comment = { fg = '@base.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@base.400' },
      String = { fg = '@accent.400' },
      Number = { fg = '@accent.400' },
      Type = { fg = '@accent.500' },
      Function = { fg = '@accent.500' },
    },
  },
})
  ```
</details>

<details>
  <summary><strong>Dawn</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Base       | #F5E8D3  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #F5E8D3; border: 1px solid #000; vertical-align: middle;"></span> |
  | Accent     | #D08770  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #D08770; border: 1px solid #000; vertical-align: middle;"></span> |

  ```lua
local xeno = require('xeno')

xeno.theme('dawn', {
  base = '#F5E8D3', -- Light creamy background
  accent = '#D08770', -- Warm coral accent
  highlights = {
    editor = {
      Normal = { bg = '@base.50', fg = '@base.900' },
      Comment = { fg = '@base.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@base.800' },
      String = { fg = '@accent.400' },
      Number = { fg = '@accent.400' },
      Type = { fg = '@accent.500' },
      Function = { fg = '@accent.500' },
    },
  },
})
  ```
</details>

### Standard Themes

Standard themes include custom colors, basic plugin integrations, and a moderate set of highlight customizations for a balanced appearance.

<details>
  <summary><strong>Forest</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Pine       | #3D5528  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #3D5528; border: 1px solid #000; vertical-align: middle;"></span> |
  | Moss       | #6A9955  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #6A9955; border: 1px solid #000; vertical-align: middle;"></span> |
  | Fern       | #A8C977  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #A8C977; border: 1px solid #000; vertical-align: middle;"></span> |
  | Base       | #2F2F2F  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #2F2F2F; border: 1px solid #000; vertical-align: middle;"></span> |
  | Accent     | #6A9955  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #6A9955; border: 1px solid #000; vertical-align: middle;"></span> |

  ```lua
local xeno = require('xeno')

-- Define custom colors
xeno.color('pine', '#3D5528')
xeno.color('moss', '#6A9955')
xeno.color('fern', '#A8C977')

xeno.theme('forest', {
  contrast = 0.2,
  base = '#2F2F2F', -- Dark gray background
  accent = '#6A9955', -- Mossy green accent
  highlights = {
    editor = {
      Normal = { bg = '@base.900', fg = '@base.300' },
      Comment = { fg = '@pine.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@base.400' },
      String = { fg = '@fern.400' },
      Quote = { fg = '@fern.400' },
      Character = { fg = '@fern.400' },
      Conditional = { fg = '@moss.500' },
      Tag = { fg = '@moss.500' },
      Repeat = { fg = '@moss.500' },
      Statement = { fg = '@moss.500' },
      Number = { fg = '@fern.400' },
      Float = { fg = '@fern.400' },
      Boolean = { fg = '@fern.400' },
      Type = { fg = '@moss.500' },
      Function = { fg = '@moss.600' },
      Constant = { fg = '@base.400' },
      Special = { fg = '@base.500' },
      Delimiter = { fg = '@base.600' },
      Operator = { fg = '@base.500' },
      Error = { fg = '@pine.300' },
    },
    plugins = {
      ['nvim-telescope/telescope.nvim'] = {
        selection_bg = '@moss.600',
        match_fg = '@fern.400',
      },
      ['hrsh7th/nvim-cmp'] = {
        selected_bg = '@base.600',
        match_fg = '@moss.500',
        kind_fg = '@base.500',
      },
    },
  },
})
  ```
</details>

<details>
  <summary><strong>Ocean</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | DeepSea    | #1B263B  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #1B263B; border: 1px solid #000; vertical-align: middle;"></span> |
  | Aqua       | #4EC9B0  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #4EC9B0; border: 1px solid #000; vertical-align: middle;"></span> |
  | Wave       | #66D9EF  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #66D9EF; border: 1px solid #000; vertical-align: middle;"></span> |
  | Base       | #2C3E50  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #2C3E50; border: 1px solid #000; vertical-align: middle;"></span> |
  | Accent     | #4EC9B0  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #4EC9B0; border: 1px solid #000; vertical-align: middle;"></span> |

  ```lua
local xeno = require('xeno')

-- Define custom colors
xeno.color('deepsea', '#1B263B')
xeno.color('aqua', '#4EC9B0')
xeno.color('wave', '#66D9EF')

xeno.theme('ocean', {
  contrast = 0.15,
  base = '#2C3E50', -- Dark blue-gray background
  accent = '#4EC9B0', -- Aqua accent
  highlights = {
    editor = {
      Normal = { bg = '@base.900', fg = '@base.300' },
      Comment = { fg = '@deepsea.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@base.400' },
      String = { fg = '@wave.400' },
      Quote = { fg = '@wave.400' },
      Character = { fg = '@wave.400' },
      Conditional = { fg = '@aqua.500' },
      Tag = { fg = '@aqua.500' },
      Repeat = { fg = '@aqua.500' },
      Statement = { fg = '@aqua.500' },
      Number = { fg = '@wave.400' },
      Float = { fg = '@wave.400' },
      Boolean = { fg = '@wave.400' },
      Type = { fg = '@aqua.500' },
      Function = { fg = '@aqua.600' },
      Constant = { fg = '@base.400' },
      Special = { fg = '@base.500' },
      Delimiter = { fg = '@base.600' },
      Operator = { fg = '@base.500' },
      Error = { fg = '@deepsea.300' },
    },
    plugins = {
      ['nvim-telescope/telescope.nvim'] = {
        selection_bg = '@aqua.600',
        match_fg = '@wave.400',
      },
      ['hrsh7th/nvim-cmp'] = {
        selected_bg = '@base.600',
        match_fg = '@aqua.500',
        kind_fg = '@base.500',
      },
    },
  },
})
  ```
</details>

### Extensive Themes

Extensive themes feature comprehensive color palettes, detailed highlight configurations, and advanced plugin integrations for a rich appearance.

<details>
  <summary><strong>Summer Night</strong></summary>

  | Color Name | Hex Code | Preview |
  |------------|----------|---------|
  | Camellia   | #FA5F8B  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #FA5F8B; border: 1px solid #000; vertical-align: middle;"></span> |
  | Coral      | #F06C6F  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #F06C6F; border: 1px solid #000; vertical-align: middle;"></span> |
  | Ember      | #E17954  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #E17954; border: 1px solid #000; vertical-align: middle;"></span> |
  | Topaz      | #D08447  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #D08447; border: 1px solid #000; vertical-align: middle;"></span> |
  | Bamboo     | #D3AB58  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #D3AB58; border: 1px solid #000; vertical-align: middle;"></span> |
  | Arcadia    | #00AB9A  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #00AB9A; border: 1px solid #000; vertical-align: middle;"></span> |
  | Bluebird   | #00A9B9  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #00A9B9; border: 1px solid #000; vertical-align: middle;"></span> |
  | Malibu     | #00A3D2  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #00A3D2; border: 1px solid #000; vertical-align: middle;"></span> |

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
  base = '#353A44', -- Dark background
  accent = '#00A6BC', -- Bluebird accent
  red = '#FA5F8B',
  green = '#00AB9A',
  yellow = '#D3AB58',
  blue = '#00A3D2',
  purple = '#FA5F8B',
  orange = '#E17954',
  highlights = {
    editor = {
      Normal = { bg = '@base.900', fg = '@base.400' },
      Comment = { fg = '@base.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@base.400' },
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
      Special = { fg = '@base.400' },
      SpecialChar = { fg = '@base.500' },
      Delimiter = { fg = '@base.400' },
      Operator = { fg = '@base.500' },
      SpecialKey = { fg = '@base.400' },
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
      ['@variable'] = { fg = '@base.300' },
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
        selected_bg = '@base.600',
        match_fg = '@malibu.500',
        kind_fg = '@base.500',
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
  | RedStone       | #E07070  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #E07070; border: 1px solid #000; vertical-align: middle;"></span> |
  | MartinaOlive   | #909040  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #909040; border: 1px solid #000; vertical-align: middle;"></span> |
  | BrightNori     | #206020  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #206020; border: 1px solid #000; vertical-align: middle;"></span> |
  | PictonBlue     | #569CD6  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #569CD6; border: 1px solid #000; vertical-align: middle;"></span> |
  | Base           | #101010  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #101010; border: 1px solid #000; vertical-align: middle;"></span> |
  | Accent         | #3D537A  | <span style="display: inline-block; width: 20px; height: 20px; background-color: #3D537A; border: 1px solid #000; vertical-align: middle;"></span> |

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
  base = '#101010', -- Dark background
  accent = '#3D537A', -- Blue accent
  red = '#E58E89',
  green = '#00FF00',
  yellow = '#F7C95C',
  blue = '#93DDFA',
  purple = '#E58AC9',
  orange = '#FFA94D',
  highlights = {
    editor = {
      Normal = { bg = '@base.900', fg = '@base' },
      Comment = { fg = '@bright_nori.600', italic = true },
    },
    syntax = {
      Identifier = { fg = '@base.400' },
      Title = { fg = '@base.400' },
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
      Constant = { fg = '@base.400' },
      Special = { fg = '@base.500' },
      SpecialChar = { fg = '@base.500' },
      Delimiter = { fg = '@base.600' },
      Operator = { fg = '@base.500' },
      SpecialKey = { fg = '@base.500' },
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
      ['@variable'] = { fg = '@base.500' },
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
        selected_bg = '@base.600',
        match_fg = '@picton_blue.500',
        kind_fg = '@base.500',
      },
    },
  },
})
  ```
</details>

