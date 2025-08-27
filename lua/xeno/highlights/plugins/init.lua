local M = {}
local utils = require("xeno.core.utils")
local helpers = require("xeno.core.helpers")

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

M["lukas-reineke/indent-blankline.nvim"] = function(colors)
  return {
    IblScope = { fg = colors.base_500, nocombine = true },
    IblIndent = { fg = utils.opaque(colors.base_500, 0.5), nocombine = true },
    IblChar = { fg = utils.opaque(colors.base_500, 0.5), nocombine = true },
  }
end

M["nvim-neo-tree/neo-tree.nvim"] = function(colors)
  local neotree = { bg = colors.base_800, fg = colors.base_200 }

  return {
    NeoTreeRootName = { fg = colors.accent_500, bold = true, italic = true, underline = true },
    NeoTreeNormal = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeNormalNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeEndOfBuffer = { bg = neotree.bg },
    NeoTreeStatusLine = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeStatusLineNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeWinSeparator = { bg = neotree.bg, fg = colors.base_700 },
    NeoTreeTabActive = { bg = colors.base_700, bold = true },
    NeoTreeTabInactive = { bg = colors.base_800, fg = colors.base_300 },
    NeoTreeTabSeparatorActive = { fg = colors.base_300, bg = colors.base_700 },
    NeoTreeTabSeparatorInactive = { fg = colors.base_700, bg = colors.base_800 },
    NeoTreeCursorLine = { bg = colors.base_700 },
    NeoTreeDirectoryName = { fg = colors.base_200 },
    NeoTreeDirectoryIcon = { fg = colors.base_300 },
    NeoTreeDotFile = { fg = colors.base_500 },
    NeoTreeMessage = { fg = colors.base_300 },
    NeoTreeGitAdded = { fg = colors.green },
    NeoTreeGitModified = { fg = colors.yellow },
    NeoTreeGitDeleted = { fg = colors.red },
    NeoTreeIndentMarker = { fg = colors.base_600, nocombine = true },
  }
end

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

  local function palette()
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

  local bufferline = palette()
  local buffer_visible = { fg = bufferline.visible_fg, bg = bufferline.visible_bg }
  local buffer_selected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 }
  local diagnostic_colors = { Hint = colors.blue, Info = colors.purple, Warning = colors.yellow, Error = colors.red }

  local highlights = {
    Defaults = { underline = true, sp = colors.base_700 },
    BufferLineFill = { fg = bufferline.fill_fg, bg = bufferline.fill_bg },
    BufferLineSeparator = { fg = bufferline.separator, bg = bufferline.fill_bg },
    BufferLineTabSeparator = { fg = bufferline.separator, bg = bufferline.visible_bg },
    BufferLineOffsetSeparator = { fg = colors.base_600, bg = bufferline.visible_bg },
    BufferLineGroupSeparator = { fg = colors.base_300, bg = bufferline.visible_bg },
    BufferLineGroupLabel = { fg = bufferline.visible_bg, bg = colors.base_300 },
    BufferLineBufferVisible = buffer_visible,
    BufferLineNumbersVisible = buffer_visible,
    BufferLineCloseButtonVisible = buffer_visible,
    BufferLineInfoDiagnosticVisible = buffer_visible,
    BufferLineDiagnosticVisible = buffer_visible,
    BufferLineHintDiagnosticVisible = buffer_visible,
    BufferLineWarningDiagnosticVisible = buffer_visible,
    BufferLineErrorDiagnosticVisible = buffer_visible,
    BufferLineWarningVisible = buffer_visible,
    BufferLineHintVisible = buffer_visible,
    BufferLineInfoVisible = buffer_visible,
    BufferLineErrorVisible = buffer_visible,
    BufferLineModifiedVisible = { fg = colors.base_100, bg = bufferline.visible_bg },
    BufferLineSeparatorVisible = { fg = colors.base_200, bg = bufferline.visible_bg },
    BufferLineIndicatorVisible = { fg = colors.base_600, bg = bufferline.visible_bg },
    BufferLineDuplicateVisible = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, italic = true },
    BufferLineBufferSelected = buffer_selected,
    BufferLineNumbersSelected = buffer_selected,
    BufferLineCloseButtonSelected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineModifiedSelected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineTabSelected = { fg = colors.accent_400, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineIndicatorSelected = { fg = colors.accent_400, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineSeparatorSelected = { fg = colors.base_300, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineTabSeparatorSelected = { fg = colors.base_600, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineDuplicateSelected = { fg = colors.base_300, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineHintSelected = { fg = diagnostic_colors.Hint, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineHintDiagnosticSelected = { fg = diagnostic_colors.Hint, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineInfoSelected = { fg = diagnostic_colors.Info, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineInfoDiagnosticSelected = { fg = diagnostic_colors.Info, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineWarningSelected = { fg = diagnostic_colors.Warning, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineErrorSelected = { fg = diagnostic_colors.Error, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineErrorDiagnosticSelected = { fg = diagnostic_colors.Error, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLinePickVisible = { fg = colors.red, bg = bufferline.visible_bg, bold = true, cterm = { bold = true } },
    BufferLinePickSelected = { fg = colors.red, bg = bufferline.selected_bg, bold = true },
    BufferLinePick = { fg = colors.red, bg = bufferline.visible_bg, bold = true, cterm = { bold = true } },
    BufferLineDiagnostic = buffer_visible,
    BufferLineTab = buffer_visible,
    BufferLineBuffer = buffer_visible,
    BufferLineNumbers = buffer_visible,
    BufferLineCloseButton = buffer_visible,
    BufferLineTabClose = buffer_visible,
    BufferLineModified = { fg = colors.base_100, bg = bufferline.visible_bg },
    BufferLineWarning = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.yellow },
    BufferLineHint = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.blue },
    BufferLineInfo = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.purple },
    BufferLineError = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.red },
    BufferLineInfoDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.purple },
    BufferLineHintDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.blue },
    BufferLineErrorDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.red },
    BufferLineWarningDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.purple },
  }
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
