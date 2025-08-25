local M = {}
local utils = require("xeno.utils")
local helpers = require("xeno.helpers")

-- Telescope highlights
M["nvim-telescope/telescope.nvim"] = function(colors)
  return {
    TelescopeNormal = { fg = colors.base_200, bg = colors.base_800 },
    TelescopeMatching = { fg = colors.accent_500 },
    TelescopeBorder = { fg = colors.base_300 },
    TelescopePromptBorder = { fg = colors.base_300 },
    TelescopePromptNormal = { fg = colors.base_200, bg = colors.base_700 },
    TelescopeResultsBorder = { fg = colors.base_300 },
    TelescopePreviewBorder = { fg = colors.base_300 },
    TelescopeSelection = { link = "PmenuSel" },
    TelescopeSelectionCaret = { fg = colors.accent_500, bg = colors.base_800 },
  }
end

M["ibhagwan/fzf-lua"] = function(colors)
  return {
    FzfLuaNormal = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaFzfGutter = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaFzfSeparator = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaFzfPrompt = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaFzfPointer = { bg = colors.base_800, fg = colors.accent_200 },
    FzfLuaBorder = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaBufFlagCurl = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaHeaderText = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaSearch = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaTitle = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaScrollBorderEmpty = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaScrollBorderFull = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaScrollFloatEmpty = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaScrollFloatFull = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaHelpNormal = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaHelpBorder = { bg = colors.base_700, fg = colors.base_200 },
  }
end

-- nvim-cmp highlights
M["hrsh7th/nvim-cmp"] = function(colors)
  return {
    CmpItemAbbrMatch = { fg = colors.accent_200 },
    CmpItemAbbrMatchFuzzy = { fg = colors.accent_500 },
    CmpItemKind = { fg = colors.base_200 },
    CmpItemMenu = { fg = colors.base_300, italic = true },
    CmpItemAbbr = { fg = colors.base_200 },
    CmpItemAbbrDeprecated = { fg = colors.base_300, strikethrough = true },
  }
end

-- nvim-navic (winbar) highlights
M["SmiteshP/nvim-navic"] = function(colors)
  return {
    NavicText = { fg = colors.base_300 },
    NavicSeparator = { fg = colors.base_300 },
    NavicIconsFile = { fg = colors.accent_500 },
    NavicIconsModule = { fg = colors.accent_500 },
    NavicIconsNamespace = { fg = colors.accent_500 },
    NavicIconsPackage = { fg = colors.accent_500 },
    NavicIconsClass = { fg = colors.accent_500 },
    NavicIconsMethod = { fg = colors.accent_500 },
    NavicIconsProperty = { fg = colors.base_200 },
    NavicIconsField = { fg = colors.base_200 },
    NavicIconsConstructor = { fg = colors.accent_500 },
    NavicIconsFunction = { fg = colors.accent_500 },
  }
end

-- todo-comments highlights
M["folke/todo-comments.nvim"] = function(colors)
  return {
    TodoBgNOTE = { fg = colors.base_700, bg = colors.accent_500, bold = true },
    TodoSignNOTE = { fg = colors.accent_500, bg = colors.base_700 },
    TodoFgNOTE = { fg = colors.accent_500 },
    TodoBgWARN = { fg = colors.base_700, bg = colors.yellow, bold = true },
    TodoSignWARN = { fg = colors.yellow, bg = colors.base_700 },
    TodoFgWARN = { fg = colors.yellow },
    TodoBgFIX = { fg = colors.base_700, bg = colors.red, bold = true },
    TodoSignFIX = { fg = colors.red, bg = colors.base_700 },
    TodoFgFIX = { fg = colors.red },
  }
end

-- indent-blankline highlights
M["lukas-reineke/indent-blankline.nvim"] = function(colors)
  return {
    IblScope = { fg = colors.base_500, nocombine = true },
    IblIndent = { fg = utils.opaque(colors.base_500, 0.5), nocombine = true },
    IblChar = { fg = utils.opaque(colors.base_500, 0.5), nocombine = true },
  }
end

-- neo-tree highlights
M["nvim-neo-tree/neo-tree.nvim"] = function(colors)
  local neotree = {
    bg = colors.base_800,
    fg = colors.base_200,
  }

  return {
    -- Root directory
    NeoTreeRootName = { fg = colors.accent_500, bold = true, italic = true, underline = true },

    -- Main backgrounds
    NeoTreeNormal = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeNormalNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeEndOfBuffer = { bg = neotree.bg },

    -- Status line
    NeoTreeStatusLine = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeStatusLineNC = { bg = neotree.bg, fg = neotree.fg },

    -- Window separator
    NeoTreeWinSeparator = { bg = neotree.bg, fg = colors.base_700 }, -- Uses the same color as WinSeparator

    -- Tabs
    NeoTreeTabActive = { bg = colors.base_700, bold = true },
    NeoTreeTabInactive = { bg = colors.base_800, fg = colors.base_300 },
    NeoTreeTabSeparatorActive = { fg = colors.base_300, bg = colors.base_700 },
    NeoTreeTabSeparatorInactive = { fg = colors.base_700, bg = colors.base_800 },

    -- Cursor line highlighting
    NeoTreeCursorLine = { bg = colors.base_700 },

    -- Files and directories
    NeoTreeDirectoryName = { fg = colors.base_200 },
    NeoTreeDirectoryIcon = { fg = colors.base_300 },
    NeoTreeDotFile = { fg = colors.base_300 }, -- Similar to Comment but slightly altered
    NeoTreeMessage = { fg = colors.base_300 },

    -- Git status indicators
    NeoTreeGitAdded = { fg = colors.green },
    NeoTreeGitModified = { fg = colors.yellow },
    NeoTreeGitDeleted = { fg = colors.red },

    -- Indentation
    NeoTreeIndentMarker = { fg = colors.base_600, nocombine = true },
  }
end

-- gitsigns highlights
M["lewis6991/gitsigns.nvim"] = function(colors)
  return {
    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.yellow },
    GitSignsDelete = { fg = colors.red },
    GitSignsCurrentLineBlame = { fg = colors.base_300 },
  }
end

M["akinsho/bufferline.nvim"] = function(colors)
  local is_light = utils.get_variant() == 2

  local function get_base_colors()
    if is_light then
      return {
        fill_bg = colors.base_700,
        fill_fg = colors.base_500,
        visible_bg = colors.base_900,
        visible_fg = colors.base_700,
        selected_bg = colors.base_900,
        selected_fg = colors.base_400,
        separator = colors.base_400,
      }
    else
      return {
        fill_bg = colors.base_900,
        fill_fg = colors.base_300,
        visible_bg = colors.base_900,
        visible_fg = colors.base_300,
        selected_bg = colors.base_800,
        selected_fg = colors.base_100,
        separator = colors.base_800,
      }
    end
  end

  local base_colors = get_base_colors()

  local base_visible = {
    fg = base_colors.visible_fg,
    bg = base_colors.visible_bg,
  }

  local base_selected = {
    fg = base_colors.selected_fg,
    bg = base_colors.selected_bg,
    bold = true,
    sp = colors.accent_400,
  }

  local diagnostic_colors = {
    Hint = colors.blue,
    Info = colors.purple,
    Warning = colors.yellow,
    Error = colors.red,
  }

  local highlights = {
    defaults = { sp = colors.base_700 },

    BufferLineFill = { fg = base_colors.fill_fg, bg = base_colors.fill_bg },
    BufferLineSeparator = { fg = base_colors.separator, bg = base_colors.fill_bg },
    BufferLineTabSeparator = { fg = base_colors.separator, bg = base_colors.visible_bg },
    BufferLineOffsetSeparator = { fg = colors.base_600, bg = base_colors.visible_bg },
    BufferLineGroupSeparator = { fg = colors.base_300, bg = base_colors.visible_bg },
    BufferLineGroupLabel = { fg = base_colors.visible_bg, bg = colors.base_300 },

    BufferLineBufferVisible = base_visible,
    BufferLineNumbersVisible = base_visible,
    BufferLineCloseButtonVisible = base_visible,
    BufferLineInfoDiagnosticVisible = base_visible,
    BufferLineDiagnosticVisible = base_visible,
    BufferLineHintDiagnosticVisible = base_visible,
    BufferLineWarningDiagnosticVisible = base_visible,
    BufferLineErrorDiagnosticVisible = base_visible,
    BufferLineWarningVisible = base_visible,
    BufferLineHintVisible = base_visible,
    BufferLineInfoVisible = base_visible,
    BufferLineErrorVisible = base_visible,
    BufferLineModifiedVisible = { fg = colors.base_100, bg = base_colors.visible_bg },
    BufferLineSeparatorVisible = { fg = colors.base_200, bg = base_colors.visible_bg },
    BufferLineIndicatorVisible = { fg = colors.base_600, bg = base_colors.visible_bg },
    BufferLineDuplicateVisible = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, italic = true },

    BufferLineBufferSelected = base_selected,
    BufferLineNumbersSelected = base_selected,

    BufferLineCloseButtonSelected = {
      fg = base_colors.selected_fg,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineModifiedSelected = {
      fg = base_colors.selected_fg,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineTabSelected = {
      fg = colors.accent_400,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineIndicatorSelected = {
      fg = colors.accent_400,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineSeparatorSelected = {
      fg = colors.base_300,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineTabSeparatorSelected = {
      fg = colors.base_600,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineDuplicateSelected = {
      fg = colors.base_300,
      bg = base_colors.selected_bg,
      sp = colors.accent_400,
    },

    BufferLineHintSelected = {
      fg = diagnostic_colors.Hint,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
    },
    BufferLineHintDiagnosticSelected = {
      fg = diagnostic_colors.Hint,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
    },
    BufferLineInfoSelected = {
      fg = diagnostic_colors.Info,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
    },

    BufferLineInfoDiagnosticSelected = {
      fg = diagnostic_colors.Info,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
    },

    BufferLineWarningSelected = {
      fg = diagnostic_colors.Warning,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
    },

    BufferLineWarningDiagnosticSelected = {
      fg = diagnostic_colors.Warning,
      bg = base_colors.selected_bg,
      bold = true,
    },

    BufferLineErrorSelected = {
      fg = diagnostic_colors.Error,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
      cterm = { bold = true, underline = true },
    },

    BufferLineErrorDiagnosticSelected = {
      fg = diagnostic_colors.Error,
      bg = base_colors.selected_bg,
      bold = true,
      sp = colors.accent_400,
    },

    BufferLinePickVisible = {
      fg = colors.red,
      bg = base_colors.visible_bg,
      bold = true,
      cterm = { bold = true },
    },

    BufferLinePickSelected = {
      fg = colors.red,
      bg = base_colors.selected_bg,
      bold = true,
    },

    BufferLinePick = {
      fg = colors.red,
      bg = base_colors.visible_bg,
      bold = true,
      cterm = {
        bold = true,
      },
    },

    BufferLineDiagnostic = base_visible,
    BufferLineTab = base_visible,
    BufferLineBuffer = base_visible,
    BufferLineNumbers = base_visible,
    BufferLineCloseButton = base_visible,
    BufferLineTabClose = base_visible,

    BufferLineModified = { fg = colors.base_100, bg = base_colors.visible_bg },
    BufferLineWarning = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.yellow },
    BufferLineHint = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.blue },
    BufferLineInfo = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.purple },
    BufferLineError = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.red },
    BufferLineInfoDiagnostic = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.purple },
    BufferLineHintDiagnostic = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.blue },
    BufferLineErrorDiagnostic = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.red },
    BufferLineWarningDiagnostic = { fg = base_colors.visible_fg, bg = base_colors.visible_bg, sp = colors.purple },
    BufferLinebg = base_visible,
  }

  -- Use the default helper to apply defaults to all highlights
  return helpers.default(highlights)
end

M["folke/trouble.nvim"] = function(colors)
  return {
    TroubleNormal = { bg = colors.base_800, fg = colors.base_200 },
    TroubleFile = { bg = colors.base_800, fg = colors.base_200 },
    TroubleSignOther = { bg = colors.base_800, fg = colors.base_200 },
    TroubleInformation = { bg = colors.base_800, fg = colors.base_200 },
  }
end

return M
