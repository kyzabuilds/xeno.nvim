# Plugin Support

xeno.nvim provides built-in highlight support for popular Neovim plugins. Each plugin's highlights are carefully crafted to integrate seamlessly with your custom theme colors.

## Table of Contents

- [Telescope](#telescope) - `nvim-telescope/telescope.nvim`
- [FZF-Lua](#fzf-lua) - `ibhagwan/fzf-lua`
- [Nvim-CMP](#nvim-cmp) - `hrsh7th/nvim-cmp`
- [Blink.cmp](#blinkcmp) - `Saghen/blink.cmp`
- [Nvim-Navic](#nvim-navic) - `SmiteshP/nvim-navic`
- [Todo Comments](#todo-comments) - `folke/todo-comments.nvim`
- [Indent Blankline](#indent-blankline) - `lukas-reineke/indent-blankline.nvim`
- [Indentmini](#indentmini) - `nvimdev/indentmini.nvim`
- [Neo-tree](#neo-tree) - `nvim-neo-tree/neo-tree.nvim`
- [Nvim-tree](#nvim-tree) - `nvim-tree/nvim-tree.lua`
- [Gitsigns](#gitsigns) - `lewis6991/gitsigns.nvim`
- [Bufferline](#bufferline) - `akinsho/bufferline.nvim`
- [Toggleterm](#toggleterm) - `akinsho/toggleterm.nvim`
- [Trouble](#trouble) - `folke/trouble.nvim`
- [Snacks](#snacks) - `folke/snacks.nvim`
- [Neogit](#neogit) - `NeogitOrg/neogit`
- [Render Markdown](#render-markdown) - `MeanderingProgrammer/render-markdown.nvim`
- [Diffview](#diffview) - `sindrets/diffview.nvim`
- [Dropbar](#dropbar) - `Bekaboo/dropbar.nvim`
- [Glance](#glance) - `DNLHC/glance.nvim`
- [Grug-far](#grug-far) - `MagicDuck/grug-far.nvim`
- [Markview](#markview) - `OXY2DEV/markview.nvim`
- [Which-key](#which-key) - `folke/which-key.nvim`
- [Nvim-scrollbar](#nvim-scrollbar) - `petertriho/nvim-scrollbar`
- [Avante](#avante) - `yetone/avante.nvim`
- [Octo](#octo) - `pwntester/octo.nvim`

## Telescope

https://github.com/nvim-telescope/telescope.nvim

### Configuration Options

Configure Telescope highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["nvim-telescope/telescope.nvim"] = {
      bg = colors.background_900,  -- Background color
      fg = colors.foreground_100,  -- Foreground text color
      border = colors.background_800, -- Border color
    }
  }
})
```

### Highlight Groups
- `TelescopeNormal` - Main window background and text
- `TelescopeBorder` - Window border
- `TelescopeTitle` - Window title
- `TelescopePromptPrefix` - Input prompt prefix
- `TelescopePromptCounter` - Result counter
- `TelescopeSelection` - Selected item background
- `TelescopeSelectionCaret` - Selection indicator

## FZF-Lua

https://github.com/ibhagwan/fzf-lua

### Configuration Options

Configure FZF-Lua highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["ibhagwan/fzf-lua"] = {
      bg = colors.background_950,     -- Background color
      fg = colors.foreground_300,     -- Foreground text color
      border = colors.background_800, -- Border color
      prompt_fg = colors.accent_200,  -- Prompt text color
      pointer_fg = colors.accent_200, -- Pointer color
      statusline_bg = colors.background_950,    -- Statusline background
      statusline_fg = colors.foreground_100,     -- Statusline foreground
      statusline_nc_bg = colors.background_900,  -- Inactive statusline background
      statusline_nc_fg = colors.foreground_300,  -- Inactive statusline foreground
      statusline1_fg = colors.accent_500, -- Statusline segment 1
      statusline2_fg = colors.foreground_100, -- Statusline segment 2
      statusline3_fg = colors.foreground_300, -- Statusline segment 3
    }
  }
})
```

### Highlight Groups
- `FzfLuaNormal` - Main interface background and text
- `FzfLuaBorder` - Window borders
- `FzfLuaTitle` - Window titles
- `FzfLuaHeaderText` - Header text
- `FzfLuaFzfGutter` - Fzf gutter area
- `FzfLuaFzfSeparator` - Fzf separators
- `FzfLuaFzfPrompt` - Fzf prompt
- `FzfLuaFzfPointer` - Fzf pointer/cursor
- `FzfLuaSearch` - Search highlights
- `FzfLuaBufFlagCurl` - Buffer flag indicators (legacy alias, kept for backward compatibility)
- `FzfLuaStatusLine1/2/3` - Consolidated statusline segments
- Various preview, scroll, and help elements

## Nvim-CMP

https://github.com/hrsh7th/nvim-cmp

### Configuration Options

Configure nvim-cmp highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["hrsh7th/nvim-cmp"] = {
      match_fg = colors.accent_200,  -- Matched text color
      kind_fg = colors.foreground_100, -- Completion kind color
      menu_fg = colors.foreground_200, -- Menu text color
      item_fg = colors.foreground_100, -- Item text color
    }
  }
})
```

### Highlight Groups
- `CmpItemAbbrMatch` - Matched characters in completion items
- `CmpItemAbbrMatchFuzzy` - Fuzzy matched characters
- `CmpItemKind` - Completion item kind icons
- `CmpItemMenu` - Completion menu source
- `CmpItemAbbr` - Completion item text
- `CmpItemAbbrDeprecated` - Deprecated items with strikethrough

## Blink.cmp

https://github.com/Saghen/blink.cmp

### Configuration Options

Configure blink.cmp highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["Saghen/blink.cmp"] = {
      label_fg = colors.foreground_300,  -- Label text color
      match_fg = colors.accent_300,      -- Matched text color
      kind_fg = colors.foreground_300,   -- Kind icon color
      source_fg = colors.foreground_300, -- Source text color
    }
  }
})
```

### Highlight Groups
- `BlinkCmpMenu` - Main completion menu
- `BlinkCmpMenuBorder` - Menu borders
- `BlinkCmpMenuSelection` - Selected item
- `BlinkCmpDoc` - Documentation window
- `BlinkCmpDocBorder` - Documentation borders
- `BlinkCmpSignatureHelp` - Signature help window
- `BlinkCmpScrollBar*` - Scrollbar elements
- `BlinkCmpGhostText` - Ghost text preview
- `BlinkCmpLabel*` - Various label states
- `BlinkCmpKind*` - Completion kind highlights

## Nvim-Navic

https://github.com/SmiteshP/nvim-navic

### Configuration Options

Configure nvim-navic highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["SmiteshP/nvim-navic"] = {
      text_fg = colors.foreground_200,      -- Text color
      separator_fg = colors.foreground_200, -- Separator color
      icon_fg = colors.accent_500,    -- Icon color
    }
  }
})
```

### Highlight Groups
- `NavicText` - Breadcrumb text
- `NavicSeparator` - Breadcrumb separators
- `NavicIconsFile` - File icons
- `NavicIconsModule` - Module icons
- `NavicIconsNamespace` - Namespace icons
- `NavicIconsPackage` - Package icons
- `NavicIconsClass` - Class icons
- `NavicIconsMethod` - Method icons
- `NavicIconsProperty` - Property icons
- `NavicIconsField` - Field icons
- `NavicIconsConstructor` - Constructor icons
- `NavicIconsFunction` - Function icons

## Todo Comments

https://github.com/folke/todo-comments.nvim

### Configuration Options

Configure todo-comments highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["folke/todo-comments.nvim"] = {
      note_fg = colors.accent_500,  -- NOTE comment color
      warn_fg = colors.yellow,      -- WARN comment color
      fix_fg = colors.red,          -- FIX comment color
      bg = colors.background_800,   -- Background color
    }
  }
})
```

### Highlight Groups
- `TodoBgNOTE` - NOTE background highlight
- `TodoSignNOTE` - NOTE sign column
- `TodoFgNOTE` - NOTE foreground
- `TodoBgWARN` - WARN background highlight
- `TodoSignWARN` - WARN sign column
- `TodoFgWARN` - WARN foreground
- `TodoBgFIX` - FIX background highlight
- `TodoSignFIX` - FIX sign column
- `TodoFgFIX` - FIX foreground

## Indent Blankline

https://github.com/lukas-reineke/indent-blankline.nvim

### Configuration Options

Configure indent-blankline highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["lukas-reineke/indent-blankline.nvim"] = {
      scope_fg = utils.opaque(colors.foreground_400, 0.70),  -- Scope line color
      indent_fg = utils.opaque(colors.foreground_400, 0.30), -- Indent line color
    }
  }
})
```

### Highlight Groups
- `IblScope` - Current scope indentation
- `IblIndent` - Regular indentation lines
- `IblChar` - Indentation characters

## Indentmini

https://github.com/nvimdev/indentmini.nvim

### Configuration Options

Configure indentmini highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["nvimdev/indentmini.nvim"] = {
      line_fg = utils.opaque(colors.foreground_400, 0.30),    -- Regular indent line color
      current_fg = utils.opaque(colors.foreground_400, 0.70), -- Current indent line color
    }
  }
})
```

### Highlight Groups
- `IndentLine` - Regular indentation lines
- `IndentLineCurrent` - Current scope indentation line

## Neo-tree

https://github.com/nvim-neo-tree/neo-tree.nvim

### Configuration Options

Configure neo-tree highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["nvim-neo-tree/neo-tree.nvim"] = {
      bg = colors.background_900,        -- Background color
      fg = colors.foreground_200,        -- Foreground color
      root_fg = colors.accent_500,       -- Root directory color
      directory_fg = colors.foreground_200, -- Directory color
      git_add_fg = colors.green,         -- Git added color
      git_modified_fg = colors.yellow,   -- Git modified color
      git_deleted_fg = colors.red,       -- Git deleted color
    }
  }
})
```

### Highlight Groups
- `NeoTreeRootName` - Root directory name
- `NeoTreeNormal` - Main window background and text
- `NeoTreeNormalNC` - Non-current window
- `NeoTreeEndOfBuffer` - End of buffer area
- `NeoTreeStatusLine` - Status line
- `NeoTreeWinSeparator` - Window separator
- `NeoTreeTab*` - Tab-related highlights
- `NeoTreeCursorLine` - Current line highlight
- `NeoTreeIndentMarker` - Indentation guides
- `NeoTreeDirectoryName` - Directory names
- `NeoTreeDirectoryIcon` - Directory icons
- `NeoTreeDotFile` - Hidden files
- `NeoTreeGit*` - Git status highlights

## Nvim-tree

https://github.com/nvim-tree/nvim-tree.lua

### Configuration Options

Configure nvim-tree highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["nvim-tree/nvim-tree.lua"] = {
      bg = colors.background_900,        -- Background color
      fg = colors.foreground_100,        -- Foreground color
      root_fg = colors.accent_500,       -- Root folder color
      folder_fg = colors.foreground_100, -- Folder color
      git_add_fg = colors.green,         -- Git added color
      git_modified_fg = colors.yellow,   -- Git modified color
      git_deleted_fg = colors.red,       -- Git deleted color
    }
  }
})
```

### Highlight Groups
- `NvimTreeRootFolder` - Root folder highlight
- `NvimTreeNormal` - Main window background and text
- `NvimTreeNormalNC` - Non-current window
- `NvimTreeNormalFloat` - Floating window
- `NvimTreeEndOfBuffer` - End of buffer area
- `NvimTreeStatusLine` - Status line
- `NvimTreeWinSeparator` - Window separator
- `NvimTreeCursorLine` - Current line highlight
- `NvimTreeIndentMarker` - Indentation guides
- `NvimTreeFolder*` - Folder-related highlights
- `NvimTreeFile*` - File-related highlights
- `NvimTreeGit*` - Comprehensive git status highlights
- `NvimTreeDiagnostic*` - LSP diagnostic highlights
- `NvimTreeBookmark*` - Bookmark highlights
- `NvimTreeModified*` - Modified file highlights

## Gitsigns

https://github.com/lewis6991/gitsigns.nvim

### Configuration Options

Configure gitsigns highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["lewis6991/gitsigns.nvim"] = {
      add_fg = utils.opaque(colors.green, 0.60),    -- Added lines color
      change_fg = utils.opaque(colors.yellow, 0.60), -- Changed lines color
      delete_fg = utils.opaque(colors.red, 0.60),   -- Deleted lines color
    }
  }
})
```

### Highlight Groups
- `GitSignsAdd/Change/Delete/Untracked` - Sign column indicators
- `GitSignsAddNr/ChangeNr/DeleteNr` - Number column indicators
- `GitSignsAddLn/ChangeLn/DeleteLn` - Line-level background highlights
- `GitSignsAddCul/ChangeCul/DeleteCul` - Current-line variants
- `GitSignsStaged*` - Staged-hunk variants of the above
- `GitSignsAddPreview/DeletePreview` - Hunk preview highlights
- `GitSignsAddInline/ChangeInline/DeleteInline` - Inline word-diff highlights
- `GitSignsDeleteVirtLn` - Virtual deleted-line text
- `GitSignsCurrentLineBlame` - Inline blame text

## Bufferline

https://github.com/akinsho/bufferline.nvim

### Configuration Options

Bufferline highlights automatically adapt to the light/dark variant. Configure overrides through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["akinsho/bufferline.nvim"] = {
      selected_bg = colors.background_900, -- Selected buffer background
      visible_bg = colors.background_950,  -- Visible buffer background
      separator = colors.background_900,   -- Separator color
    }
  }
})
```

### Highlight Groups
- `BufferLineFill` - Background fill
- `BufferLineBuffer*` - Buffer states (normal, visible, selected)
- `BufferLineNumbers*` - Buffer numbers
- `BufferLineCloseButton*` - Close button states
- `BufferLineSeparator*` - Various separators
- `BufferLineTab*` - Tab highlights
- `BufferLineDiagnostic*` - Diagnostic indicators
- `BufferLineModified*` - Modified buffer indicators
- `BufferLineIndicator*` - Selection indicators
- `BufferLinePick*` - Buffer picking mode

## Toggleterm

https://github.com/akinsho/toggleterm.nvim

### Configuration Options
Toggleterm uses predefined color schemes and doesn't expose configuration options.

### Highlight Groups
Within `toggleterm` buffers, xeno.nvim overrides the following built-in groups rather than exposing plugin-specific ones:
- `Normal` - Terminal background (pure black)
- `WinBar` - Winbar background (pure black)
- `StatusLine` - Active statusline
- `StatusLineNC` - Inactive statusline

## Trouble

https://github.com/folke/trouble.nvim

### Configuration Options

Configure trouble highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["folke/trouble.nvim"] = {
      bg = colors.background_950, -- Background color
      fg = colors.foreground_100, -- Foreground color
    }
  }
})
```

### Highlight Groups
- `TroubleNormal` - Main window background and text
- `TroubleFile` - File names
- `TroubleSignOther` - Other signs
- `TroubleInformation` - Information text

## Snacks

https://github.com/folke/snacks.nvim

### Configuration Options

Configure snacks.nvim highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["folke/snacks.nvim"] = {
      bg = colors.background_950,     -- Base UI background
      fg = colors.foreground_100,     -- Base UI foreground
      border = colors.background_800, -- Border color

      notifier_info_fg = colors.blue,             -- Info notification color
      notifier_warn_fg = colors.yellow,           -- Warning notification color
      notifier_error_fg = colors.red,             -- Error notification color
      notifier_debug_fg = colors.purple,          -- Debug notification color
      notifier_trace_fg = colors.foreground_400,  -- Trace notification color

      dashboard_bg = colors.background_950,       -- Dashboard background
      dashboard_header_fg = colors.accent_500,    -- Dashboard header color
      dashboard_desc_fg = colors.foreground_300,  -- Dashboard description color
      dashboard_key_fg = colors.accent_200,       -- Dashboard key color

      indent_fg = utils.opaque(colors.foreground_400, 0.30),       -- Indent line color
      indent_scope_fg = utils.opaque(colors.foreground_400, 0.70), -- Scope line color

      picker_bg = colors.background_950,                              -- Picker background
      picker_match_fg = colors.accent_200,                             -- Picker match color
      picker_selected_bg = utils.opaque(colors.background_600, 0.30),  -- Picker selection background
    }
  }
})
```

### Highlight Groups
- `SnacksNormal/NormalNC` - Core window background and text
- `SnacksWinBar/WinBarNC` - Winbar states
- `SnacksBackdrop` - Dimmed backdrop behind floats
- `SnacksNotifier*Info/Warn/Debug/Error/Trace` - Notifier severity levels (base, icon, title, footer, border)
- `SnacksDashboard*` - Dashboard elements (normal, desc, file, dir, footer, header, icon, key, terminal, special, title)
- `SnacksIndent/SnacksIndentScope` - Indent guide lines
- `SnacksPicker*` - Picker window, border, input, prompt, match, and selection highlights

## Neogit

https://github.com/NeogitOrg/neogit

### Configuration Options
Neogit uses predefined color schemes and doesn't expose configuration options.

### Highlight Groups
- `NeogitActiveItem` - Active/selected items
- `NeogitCursorLine` - Current line highlight
- `NeogitNormal` - Normal text
- `NeogitFloat*` - Floating window elements
- `NeogitSection*` - Section headers and types
- `NeogitChange*` - Change type indicators
- `NeogitDiff*` - Diff viewing highlights
- `NeogitHunk*` - Hunk-related highlights
- `NeogitPopup*` - Popup window elements
- `NeogitBranch*` - Git branch highlights
- `NeogitRemote` - Remote repository indicators
- `NeogitTag*` - Git tag highlights
- `NeogitGraph*` - Commit graph colors

## Render Markdown

https://github.com/MeanderingProgrammer/render-markdown.nvim

### Configuration Options

Configure render-markdown highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["MeanderingProgrammer/render-markdown.nvim"] = {
      heading_fg = colors.foreground_100, -- Heading text color
      code_bg = colors.background_900,    -- Code block background
      inline_code_fg = colors.accent_500, -- Inline code text color
      inline_code_bg = colors.background_950, -- Inline code background
      table_fg = colors.foreground_100,       -- Table text color
      quote_fg = colors.foreground_300,       -- Quote text color
      link_fg = colors.foreground_200,        -- Link text color
    }
  }
})
```

### Highlight Groups
- `RenderMarkdownH*` - Heading levels 1-6
- `RenderMarkdownH*Bg` - Heading backgrounds
- `RenderMarkdownCode*` - Code block elements
- `RenderMarkdownTable*` - Table elements
- `RenderMarkdownSuccess` - Success alerts
- `RenderMarkdownInfo` - Info alerts
- `RenderMarkdownHint` - Hint alerts
- `RenderMarkdownWarn` - Warning alerts
- `RenderMarkdownError` - Error alerts
- `RenderMarkdownQuote*` - Quote elements
- `RenderMarkdownLink*` - Link elements
- `RenderMarkdownChecked` - Checked checkboxes
- `RenderMarkdownUnchecked` - Unchecked checkboxes
- `RenderMarkdownMath` - Math expressions

## Diffview

https://github.com/sindrets/diffview.nvim

### Configuration Options
Diffview uses predefined color schemes and doesn't expose configuration options.

### Highlight Groups
- `DiffviewPrimary` - Primary UI elements
- `DiffviewSecondary` - Secondary UI elements
- `DiffviewDim1` - Dimmed text
- `DiffviewFilePanel*` - File panel elements
- `DiffviewStatus*` - File status highlights
- `DiffviewDiff*` - Diff viewing highlights
- `DiffviewNormal` - Normal background
- `DiffviewCursorLine` - Current line
- `DiffviewWinSeparator` - Window separator
- `DiffviewFolder*` - Folder elements
- `DiffviewReference` - Git references
- `DiffviewHash` - Commit hashes

## Dropbar

https://github.com/Bekaboo/dropbar.nvim

### Configuration Options

Configure dropbar highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["Bekaboo/dropbar.nvim"] = {
      fg = colors.foreground_100,                                -- Foreground color
      bg = colors.background_900,                                -- Background color
      hover_bg = utils.opaque(colors.background_600, 0.30), -- Hover background
      separator_fg = colors.foreground_300,                      -- Separator color
      icon_fg = colors.accent_500,                           -- Icon color
    }
  }
})
```

### Highlight Groups
- `DropBarCurrentContext/Hover/Preview` - Hover and context backgrounds
- `DropBarLinkTarget` - Link target text
- `DropBarMenu*` - Menu window, border, and hover entry/icon/symbol
- `DropBarIconKind*` - Kind icons (file, folder, function, class, etc.)
- `DropBarIconUIIndicator/Separator/PickPivot` - UI separators and pick indicators
- `DropBarFzfMatch` - Fuzzy match highlight

## Glance

https://github.com/DNLHC/glance.nvim

### Configuration Options

Configure glance.nvim highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["DNLHC/glance.nvim"] = {
      fg = colors.foreground_100,        -- Foreground color
      muted_fg = colors.foreground_300,  -- Muted text color
      bg = colors.background_900,        -- Background color
      border_fg = colors.background_700, -- Border color
      border_sp = colors.background_800, -- Border underline color
      cursorline_bg = utils.opaque(colors.background_600, 0.10), -- Cursor line background
      match_bg = colors.background_800,  -- Preview match background
      indent_fg = utils.opaque(colors.foreground_400, 0.20),     -- Indent guide color
    }
  }
})
```

### Highlight Groups
- `GlanceWinBarTitle/Filepath/Filename` - Winbar elements
- `GlanceList*` - List panel (normal, cursor line, filepath, filename, count, match, border)
- `GlancePreview*` - Preview panel (normal, cursor line, match, sign column, line number, border)
- `GlanceBorderTop` - Top border
- `GlanceIndent` - Indentation guides
- `GlanceFoldIcon` - Fold icons

## Grug-far

https://github.com/MagicDuck/grug-far.nvim

### Configuration Options
Grug-far uses predefined color schemes and doesn't expose configuration options.

### Highlight Groups
- `GrugFarNormal` - Main window text
- `GrugFarWinSeparator` - Window separator
- `GrugFarResults*` - Search result elements
- `GrugFarInput*` - Input field elements
- `GrugFarHelp*` - Help window elements
- `GrugFarCursorLine` - Current line
- `GrugFarSelection` - Selected text
- `GrugFarProgress*` - Progress indicators
- `GrugFarFold*` - Folding elements
- `GrugFarError` - Error messages
- `GrugFarWarning` - Warning messages
- `GrugFarInfo` - Info messages

## Markview

https://github.com/OXY2DEV/markview.nvim

### Configuration Options
Markview uses predefined color schemes and doesn't expose configuration options.

### Highlight Groups
- `MarkviewPalette*` - Color palette (0-7)
- `MarkviewBlockQuote*` - Block quote elements
- `MarkviewCheckbox*` - Checkbox states
- `MarkviewCode*` - Code elements
- `MarkviewEmail` - Email links
- `MarkviewHyperlink` - Hyperlinks
- `MarkviewImage` - Images
- `MarkviewGradient*` - Gradient colors (0-9)
- `MarkviewHeading*` - Heading levels
- `MarkviewIcon*` - Icons (0-6)
- `MarkviewInlineCode` - Inline code
- `MarkviewListItem*` - List items
- `MarkviewSubscript` - Subscript text
- `MarkviewSuperscript` - Superscript text
- `MarkviewTable*` - Table elements

## Which-key

https://github.com/folke/which-key.nvim

### Configuration Options

Configure which-key highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["folke/which-key.nvim"] = {
      key_fg = colors.accent_500,    -- Key color
      group_fg = colors.foreground_300, -- Group color
      bg = colors.background_900,       -- Background color
      border_fg = colors.background_900, -- Border color
    }
  }
})
```

### Highlight Groups
- `WhichKey` - Key bindings
- `WhichKeyIcon` - Icons
- `WhichKeyBorder` - Window border
- `WhichKeyGroup` - Key groups
- `WhichKeySeparator` - Separators
- `WhichKeyTitle` - Window title
- `WhichKeyIcon*` - Colored icons
- `WhichKeyDesc` - Descriptions
- `WhichKeyNormal` - Normal background
- `WhichKeyValue` - Values

## Nvim-scrollbar

https://github.com/petertriho/nvim-scrollbar

### Configuration Options

Configure nvim-scrollbar highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["petertriho/nvim-scrollbar"] = {
      handle_bg = utils.opaque(colors.background_500, 0.80), -- Handle background
      git_add_fg = colors.green,      -- Git added color
      git_change_fg = colors.yellow,  -- Git changed color
      git_delete_fg = colors.red,     -- Git deleted color
      error_fg = colors.red,          -- Error color
      warn_fg = colors.yellow,        -- Warning color
      info_fg = colors.blue,          -- Info color
      hint_fg = colors.green,         -- Hint color
    }
  }
})
```

### Highlight Groups
- `ScrollbarHandle` - Main scrollbar handle
- `ScrollbarMisc*` - Miscellaneous indicators
- `ScrollbarGit*` - Git change indicators
- `ScrollbarError*` - Error indicators
- `ScrollbarWarn*` - Warning indicators
- `ScrollbarInfo*` - Info indicators
- `ScrollbarHint*` - Hint indicators
- `ScrollbarSearch*` - Search indicators
- `ScrollbarCursor*` - Cursor position indicators

## Avante

https://github.com/yetone/avante.nvim

### Configuration Options
Avante uses predefined color schemes and doesn't expose configuration options.

### Highlight Groups
- `AvanteStateSpinner*` - Various state indicators
- `AvanteReversedNormal` - Reversed normal text
- `AvanteCommentFg` - Comment foreground
- `AvanteLogoLine*` - Logo gradient lines (1-14)
- `AvanteButton*` - Button states and hover effects
- `AvanteTitle*` - Various title levels
- `AvanteSidebar*` - Sidebar elements
- `AvantePopup*` - Popup elements
- `AvantePromptInput*` - Input elements
- `AvanteTask*` - Task status indicators
- `AvanteThinking` - AI thinking indicator
- `AvanteInlineHint` - Inline hints
- `AvanteSuggestion` - AI suggestions
- `AvanteAnnotation` - Code annotations
- `AvanteConfirmTitle` - Confirmation dialog
- `AvanteToBeDeleted*` - Deletion indicators
- `AvanteConflict*` - Conflict resolution highlights

## Octo

https://github.com/pwntester/octo.nvim

### Configuration Options

Configure octo.nvim highlights through the plugin configuration:

```lua
require("xeno").setup({
  plugins = {
    ["pwntester/octo.nvim"] = {
      grey_fg = colors.foreground_300,   -- Muted text color
      blue_fg = colors.blue,             -- Blue accent color
      green_fg = colors.green,           -- Green accent color
      red_fg = colors.red,               -- Red accent color
      purple_fg = colors.purple,         -- Purple accent color
      yellow_fg = colors.yellow,         -- Yellow accent color
      dirty_fg = colors.yellow,          -- Unsaved buffer indicator color
      float_bg = colors.background_900,  -- Floating window background
      date_fg = colors.foreground_300,   -- Date text color
      symbol_fg = colors.foreground_300, -- Symbol text color
      viewer_fg = colors.accent_500,     -- Current viewer color
      bubble_bg = colors.background_800, -- Bubble background
    }
  }
})
```

### Highlight Groups
- `OctoGrey/Blue/Green/Red/Purple/Yellow` - Base color highlights
- `OctoDirty` - Unsaved buffer indicator
- `OctoIssueTitle/IssueId` - Issue title and ID
- `OctoFloat` - Floating window background
- `OctoDate/Symbol/CommentLine` - Metadata text
- `OctoTimelineItemHeading/DetailsLabel/DetailsValue` - Detail panel elements
- `OctoBubble*` - Colored bubble backgrounds and delimiters
- `OctoUser/UserViewer/Reaction/ReactionViewer` - User and reaction highlights
- `OctoPassingTest/FailingTest` - Test status
- `OctoPullAdditions/Deletions/Modifications` - Pull request stats
- `OctoState*` - Issue/PR state highlights (open, closed, merged, pending, approved, changes requested, commented, dismissed)
- `OctoFilePanel*` - File panel elements
