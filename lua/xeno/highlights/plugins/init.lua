local M = {}
local utils = require("xeno.core.utils")
local helpers = require("xeno.core.helpers")

M["nvim-telescope/telescope.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.background_900,
    fg = colors.foreground_100,
    border = colors.background_800,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    TelescopeNormal = { bg = config.bg, fg = config.fg },
    TelescopeBorder = { bg = config.bg, fg = config.border },
    TelescopeTitle = { bg = config.bg, fg = config.fg },
    TelescopePromptPrefix = { fg = colors.accent_500 },
    TelescopePromptCounter = { fg = colors.foreground_400 },
    TelescopeSelection = { bg = utils.opaque(colors.background_600, 0.30) },
    TelescopeSelectionCaret = { bg = utils.opaque(colors.background_600, 0.30), fg = colors.accent_500 },
  }
end

M["ibhagwan/fzf-lua"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.background_950,
    fg = colors.foreground_300,
    border = colors.background_800,
    prompt_fg = colors.accent_200,
    pointer_fg = colors.accent_200,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    ["fzf"] = function()
      return {
        StatusLine = { bg = config.bg, fg = config.fg },
        fzf1 = { bg = config.bg, fg = config.fg },
        fzf2 = { bg = config.bg, fg = config.fg },
        fzf3 = { bg = config.bg, fg = config.fg },
      }
    end,

    -- Main Interface Elements
    FzfLuaNormal = { bg = config.bg, fg = config.fg },
    FzfLuaBorder = { bg = config.bg, fg = config.border },
    FzfLuaTitle = { bg = config.bg, fg = config.fg },
    FzfLuaHeaderText = { bg = config.bg, fg = config.fg },

    -- Fzf-specific Elements
    FzfLuaFzfGutter = { bg = config.bg, fg = config.fg },
    FzfLuaFzfSeparator = { bg = config.bg, fg = config.border },
    FzfLuaFzfPrompt = { bg = config.bg, fg = config.prompt_fg },
    FzfLuaFzfPointer = { bg = config.bg, fg = config.pointer_fg },

    -- Search and Buffer Elements
    FzfLuaSearch = { bg = colors.background_900, fg = colors.foreground_100 },
    FzfLuaBufFlagCurl = { bg = colors.background_900, fg = colors.foreground_100 },

    -- Scroll Elements
    FzfLuaScrollBorderEmpty = { bg = colors.background_800, fg = colors.foreground_100 },
    FzfLuaScrollBorderFull = { bg = colors.background_800, fg = colors.foreground_100 },
    FzfLuaScrollFloatEmpty = { bg = colors.background_800, fg = colors.foreground_100 },
    FzfLuaScrollFloatFull = { bg = colors.background_800, fg = colors.foreground_100 },

    -- Fzf-specific Decorative Elements
    -- FzfIcon = { bg = colors.background_800, fg = colors.accent_500 },

    -- Help Elements
    FzfLuaHelpNormal = { bg = colors.background_800, fg = colors.foreground_100 },
    FzfLuaHelpBorder = { bg = colors.background_800, fg = colors.foreground_100 },
  }
end

M["hrsh7th/nvim-cmp"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    match_fg = colors.accent_200,
    kind_fg = colors.foreground_100,
    menu_fg = colors.foreground_200,
    item_fg = colors.foreground_100,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    CmpItemAbbrMatch = { fg = config.match_fg },
    CmpItemAbbrMatchFuzzy = { fg = colors.accent_500 },
    CmpItemKind = { fg = config.kind_fg },
    CmpItemMenu = { fg = config.menu_fg, italic = true },
    CmpItemAbbr = { fg = config.item_fg },
    CmpItemAbbrDeprecated = { fg = colors.foreground_200, strikethrough = true },
  }
end

M["Saghen/blink.cmp"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    label_fg = colors.foreground_200,
    match_fg = colors.foreground_200,
    kind_fg = colors.foreground_300,
    source_fg = colors.foreground_300,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Main completion menu
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "Pmenu" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },

    -- Documentation window
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "NormalFloat" },
    BlinkCmpDocSeparator = { link = "NormalFloat" },
    BlinkCmpDocCursorLine = { link = "Visual" },

    -- Signature help
    BlinkCmpSignatureHelp = { link = "NormalFloat" },
    BlinkCmpSignatureHelpBorder = { link = "NormalFloat" },
    BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" },

    -- Scrollbar
    BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
    BlinkCmpScrollBarGutter = { bg = colors.background_900 },

    -- Ghost text
    BlinkCmpGhostText = { link = "NonText" },

    -- Item labels and details
    BlinkCmpLabel = { fg = config.label_fg },
    BlinkCmpLabelMatch = { fg = config.match_fg, bold = true },
    BlinkCmpLabelDeprecated = { fg = config.label_fg, strikethrough = true },
    BlinkCmpLabelDetail = { fg = config.kind_fg, italic = true },
    BlinkCmpLabelDescription = { fg = config.label_fg, italic = true },
    BlinkCmpSource = { fg = config.source_fg, italic = true },
    BlinkCmpKind = { fg = config.kind_fg },

    -- Kind-specific highlights
    BlinkCmpKindText = { fg = colors.accent_300 },
    BlinkCmpKindMethod = { fg = colors.accent_300 },
    BlinkCmpKindFunction = { fg = colors.accent_300 },
    BlinkCmpKindConstructor = { fg = colors.accent_300 },
    BlinkCmpKindField = { fg = colors.foreground_300 },
    BlinkCmpKindVariable = { fg = colors.foreground_300 },
    BlinkCmpKindClass = { fg = colors.foreground_300 },
    BlinkCmpKindInterface = { fg = colors.foreground_300 },
    BlinkCmpKindModule = { fg = colors.foreground_300 },
    BlinkCmpKindProperty = { fg = colors.foreground_300 },
    BlinkCmpKindUnit = { fg = colors.foreground_300 },
    BlinkCmpKindValue = { fg = colors.foreground_300 },
    BlinkCmpKindEnum = { fg = colors.foreground_300 },
    BlinkCmpKindKeyword = { fg = colors.accent_300 },
    BlinkCmpKindSnippet = { fg = colors.accent_300 },
    BlinkCmpKindColor = { fg = colors.accent_300 },
    BlinkCmpKindFile = { fg = colors.accent_300 },
    BlinkCmpKindReference = { fg = colors.accent_300 },
    BlinkCmpKindFolder = { fg = colors.accent_300 },
    BlinkCmpKindEnumMember = { fg = colors.accent_300 },
    BlinkCmpKindConstant = { fg = colors.accent_300 },
    BlinkCmpKindStruct = { fg = colors.accent_300 },
    BlinkCmpKindEvent = { fg = colors.accent_300 },
    BlinkCmpKindOperator = { fg = colors.accent_300 },
    BlinkCmpKindTypeParameter = { fg = colors.accent_300 },
  }
end

M["SmiteshP/nvim-navic"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    text_fg = colors.foreground_200,
    separator_fg = colors.foreground_200,
    icon_fg = colors.accent_500,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    NavicText = { fg = config.text_fg },
    NavicSeparator = { fg = config.separator_fg },
    NavicIconsFile = { fg = config.icon_fg },
    NavicIconsModule = { fg = config.icon_fg },
    NavicIconsNamespace = { fg = config.icon_fg },
    NavicIconsPackage = { fg = config.icon_fg },
    NavicIconsClass = { fg = config.icon_fg },
    NavicIconsMethod = { fg = config.icon_fg },
    NavicIconsProperty = { fg = colors.foreground_100 },
    NavicIconsField = { fg = colors.foreground_100 },
    NavicIconsConstructor = { fg = config.icon_fg },
    NavicIconsFunction = { fg = config.icon_fg },
  }
end

M["folke/todo-comments.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    note_fg = colors.accent_500,
    warn_fg = colors.yellow,
    fix_fg = colors.red,
    bg = colors.background_800,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    TodoBgNOTE = { fg = config.bg, bg = config.note_fg, bold = true },
    TodoSignNOTE = { fg = config.note_fg, bg = config.bg },
    TodoFgNOTE = { fg = config.note_fg },
    TodoBgWARN = { fg = config.bg, bg = config.warn_fg, bold = true },
    TodoSignWARN = { fg = config.warn_fg, bg = config.bg },
    TodoFgWARN = { fg = config.warn_fg },
    TodoBgFIX = { fg = config.bg, bg = config.fix_fg, bold = true },
    TodoSignFIX = { fg = config.fix_fg, bg = config.bg },
    TodoFgFIX = { fg = config.fix_fg },
  }
end

M["lukas-reineke/indent-blankline.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    scope_fg = utils.opaque(colors.foreground_400, 0.70),
    indent_fg = utils.opaque(colors.foreground_400, 0.30),
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    IblScope = { fg = config.scope_fg, nocombine = true },
    IblIndent = { fg = config.indent_fg, nocombine = true },
    IblChar = { fg = config.indent_fg, nocombine = true },
  }
end

M["nvimdev/indentmini.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    line_fg = utils.opaque(colors.foreground_400, 0.30),
    current_fg = utils.opaque(colors.foreground_400, 0.70),
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    IndentLine = { fg = config.line_fg, nocombine = true },
    IndentLineCurrent = { fg = config.current_fg, nocombine = true },
  }
end

M["nvim-neo-tree/neo-tree.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.background_900,
    fg = colors.foreground_200,
    root_fg = colors.accent_500,
    directory_fg = colors.foreground_200,
    git_add_fg = colors.green,
    git_modified_fg = colors.yellow,
    git_deleted_fg = colors.red,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  local neotree = {
    bg = config.bg,
    fg = config.fg,
  }

  return {
    -- Filetypes
    ["neo-tree"] = function()
      return {
        Visual = { bg = colors.background_800 },
      }
    end,

    -- Root and Basic Elements
    NeoTreeRootName = { fg = config.root_fg, bold = true, italic = true, underline = true },
    NeoTreeNormal = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeNormalNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeEndOfBuffer = { bg = neotree.bg },

    -- Status Line
    NeoTreeStatusLine = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeStatusLineNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeWinSeparator = { bg = neotree.bg, fg = colors.background_800 },

    -- Tabs
    NeoTreeTabActive = { bg = colors.background_800, bold = true },
    NeoTreeTabInactive = { bg = colors.background_900, fg = colors.foreground_200 },
    NeoTreeTabSeparatorActive = { fg = colors.foreground_200, bg = colors.background_800 },
    NeoTreeTabSeparatorInactive = { fg = colors.background_800, bg = colors.background_900 },

    -- Selection and Navigation
    NeoTreeCursorLine = { bg = utils.opaque(colors.background_600, 0.30) },
    NeoTreeIndentMarker = { fg = utils.opaque(colors.foreground_400, 0.40), nocombine = true },

    -- File System Elements
    NeoTreeDirectoryName = { fg = config.directory_fg },
    NeoTreeDirectoryIcon = { fg = colors.foreground_200 },
    NeoTreeDotFile = { fg = colors.foreground_300 },
    NeoTreeMessage = { fg = colors.foreground_200 },

    -- Git Status Colors
    NeoTreeGitAdded = { fg = config.git_add_fg },
    NeoTreeGitModified = { fg = config.git_modified_fg },
    NeoTreeGitDeleted = { fg = config.git_deleted_fg },
  }
end

M["nvim-tree/nvim-tree.lua"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.background_900,
    fg = colors.foreground_100,
    root_fg = colors.accent_500,
    folder_fg = colors.foreground_100,
    git_add_fg = colors.green,
    git_modified_fg = colors.yellow,
    git_deleted_fg = colors.red,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  local nvimtree = { bg = config.bg, fg = config.fg }

  return {
    -- Root and Basic Elements
    NvimTreeRootFolder = { fg = config.root_fg, bold = true, italic = true, underline = true },
    NvimTreeNormal = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeNormalNC = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeNormalFloat = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeNormalFloatBorder = { bg = nvimtree.bg, fg = colors.background_800 },
    NvimTreeEndOfBuffer = { bg = nvimtree.bg },
    NvimTreePopup = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeSignColumn = { bg = nvimtree.bg, fg = nvimtree.fg },

    -- Status Line
    NvimTreeStatusLine = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeStatusLineNC = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeWinSeparator = { bg = nvimtree.bg, fg = colors.background_800 },
    NvimTreeLineNr = { bg = nvimtree.bg, fg = colors.foreground_300 },
    NvimTreeCursorLineNr = { bg = nvimtree.bg, fg = colors.foreground_200 },

    -- Selection and Navigation
    NvimTreeCursorLine = { bg = utils.opaque(colors.background_600, 0.15) },
    NvimTreeCursorColumn = { bg = utils.opaque(colors.background_600, 0.15) },
    NvimTreeIndentMarker = { fg = utils.opaque(colors.foreground_400, 0.40), nocombine = true },

    -- Folder Elements
    NvimTreeFolderName = { fg = config.folder_fg },
    NvimTreeEmptyFolderName = { fg = colors.foreground_200 },
    NvimTreeOpenedFolderName = { fg = config.folder_fg, bold = true },
    NvimTreeSymlinkFolderName = { fg = colors.foreground_200, italic = true },
    NvimTreeFolderIcon = { fg = colors.foreground_200 },
    NvimTreeOpenedFolderIcon = { fg = colors.foreground_200 },
    NvimTreeClosedFolderIcon = { fg = colors.foreground_200 },
    NvimTreeFolderArrowOpen = { fg = colors.foreground_200 },
    NvimTreeFolderArrowClosed = { fg = colors.foreground_200 },

    -- File Elements
    NvimTreeFileIcon = { fg = colors.foreground_100 },
    NvimTreeExecFile = { fg = colors.green, bold = true },
    NvimTreeImageFile = { fg = colors.purple },
    NvimTreeSpecialFile = { fg = colors.yellow, underline = true },
    NvimTreeSymlink = { fg = colors.blue, italic = true },
    NvimTreeSymlinkIcon = { fg = colors.blue },

    -- Git Status Colors
    NvimTreeGitDirty = { fg = config.git_modified_fg },
    NvimTreeGitStaged = { fg = config.git_add_fg },
    NvimTreeGitMerge = { fg = colors.orange },
    NvimTreeGitRenamed = { fg = colors.purple },
    NvimTreeGitNew = { fg = colors.green, bold = true },
    NvimTreeGitDeleted = { fg = colors.red },
    NvimTreeGitIgnored = { fg = colors.foreground_300 },

    -- Git Icons
    NvimTreeGitDirtyIcon = { fg = colors.yellow },
    NvimTreeGitStagedIcon = { fg = colors.green },
    NvimTreeGitMergeIcon = { fg = colors.orange },
    NvimTreeGitRenamedIcon = { fg = colors.purple },
    NvimTreeGitNewIcon = { fg = colors.green },
    NvimTreeGitDeletedIcon = { fg = colors.red },
    NvimTreeGitIgnoredIcon = { fg = colors.foreground_300 },

    -- Git File Highlights
    NvimTreeGitFileDirtyHL = { fg = colors.yellow },
    NvimTreeGitFileStagedHL = { fg = colors.green },
    NvimTreeGitFileMergeHL = { fg = colors.orange },
    NvimTreeGitFileRenamedHL = { fg = colors.purple },
    NvimTreeGitFileNewHL = { fg = colors.green },
    NvimTreeGitFileDeletedHL = { fg = colors.red },
    NvimTreeGitFileIgnoredHL = { fg = colors.foreground_300 },

    -- Git Folder Highlights
    NvimTreeGitFolderDirtyHL = { fg = colors.yellow },
    NvimTreeGitFolderStagedHL = { fg = colors.green },
    NvimTreeGitFolderMergeHL = { fg = colors.orange },
    NvimTreeGitFolderRenamedHL = { fg = colors.purple },
    NvimTreeGitFolderNewHL = { fg = colors.green },
    NvimTreeGitFolderDeletedHL = { fg = colors.red },
    NvimTreeGitFolderIgnoredHL = { fg = colors.foreground_300 },

    -- File/Folder Status
    NvimTreeFileStaged = { fg = colors.green },
    NvimTreeFileRenamed = { fg = colors.purple },
    NvimTreeFileNew = { fg = colors.green },
    NvimTreeFileMerge = { fg = colors.orange },
    NvimTreeFileIgnored = { fg = colors.foreground_300 },
    NvimTreeFileDirty = { fg = colors.yellow },
    NvimTreeFileDeleted = { fg = colors.red },
    NvimTreeFolderStaged = { fg = colors.green },
    NvimTreeFolderRenamed = { fg = colors.purple },
    NvimTreeFolderNew = { fg = colors.green },
    NvimTreeFolderMerge = { fg = colors.orange },
    NvimTreeFolderIgnored = { fg = colors.foreground_300 },
    NvimTreeFolderDirty = { fg = colors.yellow },
    NvimTreeFolderDeleted = { fg = colors.red },

    -- Opened Files
    NvimTreeOpenedFile = { fg = colors.accent_300, bold = true },
    NvimTreeOpenedHL = { fg = colors.accent_300 },

    -- Modified Files
    NvimTreeModifiedFile = { fg = colors.yellow, italic = true },
    NvimTreeModifiedIcon = { fg = colors.yellow },
    NvimTreeModifiedFileHL = { fg = colors.yellow },
    NvimTreeModifiedFolderHL = { fg = colors.yellow },

    -- Bookmarks
    NvimTreeBookmark = { fg = colors.blue, bold = true },
    NvimTreeBookmarkIcon = { fg = colors.blue },
    NvimTreeBookmarkHL = { fg = colors.blue, underline = true },

    -- Diagnostics
    NvimTreeLspDiagnosticsError = { fg = colors.red },
    NvimTreeLspDiagnosticsWarning = { fg = colors.yellow },
    NvimTreeLspDiagnosticsInformation = { fg = colors.blue },
    NvimTreeLspDiagnosticsHint = { fg = colors.green },
    NvimTreeDiagnosticErrorIcon = { fg = colors.red },
    NvimTreeDiagnosticWarnIcon = { fg = colors.yellow },
    NvimTreeDiagnosticInfoIcon = { fg = colors.blue },
    NvimTreeDiagnosticHintIcon = { fg = colors.green },

    -- Diagnostic File/Folder Highlights
    NvimTreeDiagnosticErrorFileHL = { fg = colors.red, undercurl = true, sp = colors.red },
    NvimTreeDiagnosticWarnFileHL = { fg = colors.yellow, undercurl = true, sp = colors.yellow },
    NvimTreeDiagnosticInfoFileHL = { fg = colors.blue, undercurl = true, sp = colors.blue },
    NvimTreeDiagnosticHintFileHL = { fg = colors.green, undercurl = true, sp = colors.green },
    NvimTreeDiagnosticErrorFolderHL = { fg = colors.red },
    NvimTreeDiagnosticWarnFolderHL = { fg = colors.yellow },
    NvimTreeDiagnosticInfoFolderHL = { fg = colors.blue },
    NvimTreeDiagnosticHintFolderHL = { fg = colors.green },

    -- Legacy LSP Diagnostic Text
    NvimTreeLspDiagnosticsErrorText = { fg = colors.red },
    NvimTreeLspDiagnosticsWarningText = { fg = colors.yellow },
    NvimTreeLspDiagnosticsInformationText = { fg = colors.blue },
    NvimTreeLspDiagnosticsHintText = { fg = colors.green },
    NvimTreeLspDiagnosticsErrorFolderText = { fg = colors.red },
    NvimTreeLspDiagnosticsWarningFolderText = { fg = colors.yellow },
    NvimTreeLspDiagnosticsInformationFolderText = { fg = colors.blue },
    NvimTreeLspDiagnosticsHintFolderText = { fg = colors.green },

    -- Filter and Live Filter
    NvimTreeLiveFilterPrefix = { fg = colors.accent_500, bold = true },
    NvimTreeLiveFilterValue = { fg = colors.accent_300 },

    -- Cut/Copy/Paste
    NvimTreeCutHL = { fg = colors.red, strikethrough = true },
    NvimTreeCopiedHL = { fg = colors.green, bold = true },

    -- Hidden Files
    NvimTreeHiddenIcon = { fg = colors.foreground_300 },
    NvimTreeHiddenFileHL = { fg = colors.foreground_300 },
    NvimTreeHiddenFolderHL = { fg = colors.foreground_300 },
    NvimTreeHiddenDisplay = { fg = colors.foreground_300 },

    -- Window Picker
    NvimTreeWindowPicker = { fg = colors.background_950, bg = colors.accent_500, bold = true },
  }
end

M["lewis6991/gitsigns.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    add_fg = utils.opaque(colors.green, 0.60),
    change_fg = utils.opaque(colors.yellow, 0.60),
    delete_fg = utils.opaque(colors.red, 0.60),
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Base gitsigns highlights
    GitSignsAdd = { fg = config.add_fg },
    GitSignsChange = { fg = config.change_fg },
    GitSignsDelete = { fg = config.delete_fg },
    GitSignsUntracked = { fg = utils.opaque(colors.green, 0.60) },

    -- Number line highlights
    GitSignsAddNr = { fg = utils.opaque(colors.green, 0.60) },
    GitSignsChangeNr = { fg = utils.opaque(colors.yellow, 0.60) },
    GitSignsDeleteNr = { fg = utils.opaque(colors.red, 0.60) },
    GitSignsChangedeleteNr = { fg = utils.opaque(colors.yellow, 0.60) },
    GitSignsTopdeleteNr = { fg = utils.opaque(colors.red, 0.60) },
    GitSignsUntrackedNr = { fg = utils.opaque(colors.green, 0.60) },

    -- Line highlights
    GitSignsAddLn = { bg = utils.opaque(colors.green, 0.15) },
    GitSignsChangeLn = { bg = utils.opaque(colors.yellow, 0.15) },
    GitSignsDeleteLn = { bg = utils.opaque(colors.red, 0.15) },
    GitSignsChangedeleteLn = { bg = utils.opaque(colors.yellow, 0.15) },
    GitSignsTopdeleteLn = { bg = utils.opaque(colors.red, 0.15) },
    GitSignsUntrackedLn = { bg = utils.opaque(colors.green, 0.15) },

    -- Current line highlights
    GitSignsAddCul = { fg = utils.opaque(colors.green, 0.60) },
    GitSignsChangeCul = { fg = utils.opaque(colors.yellow, 0.60) },
    GitSignsDeleteCul = { fg = utils.opaque(colors.red, 0.60) },
    GitSignsChangedeleteCul = { fg = utils.opaque(colors.yellow, 0.60) },
    GitSignsTopdeleteCul = { fg = utils.opaque(colors.red, 0.60) },
    GitSignsUntrackedCul = { fg = utils.opaque(colors.green, 0.60) },

    -- Staged highlights
    GitSignsStagedAdd = { fg = utils.opaque(colors.green, 0.40) },
    GitSignsStagedChange = { fg = utils.opaque(colors.yellow, 0.40) },
    GitSignsStagedDelete = { fg = utils.opaque(colors.red, 0.40) },
    GitSignsStagedChangedelete = { fg = utils.opaque(colors.yellow, 0.40) },
    GitSignsStagedTopdelete = { fg = utils.opaque(colors.red, 0.40) },
    GitSignsStagedUntracked = { fg = utils.opaque(colors.green, 0.40) },

    -- Staged number line highlights
    GitSignsStagedAddNr = { fg = utils.opaque(colors.green, 0.40) },
    GitSignsStagedChangeNr = { fg = utils.opaque(colors.yellow, 0.40) },
    GitSignsStagedDeleteNr = { fg = utils.opaque(colors.red, 0.40) },
    GitSignsStagedChangedeleteNr = { fg = utils.opaque(colors.yellow, 0.40) },
    GitSignsStagedTopdeleteNr = { fg = utils.opaque(colors.red, 0.40) },
    GitSignsStagedUntrackedNr = { fg = utils.opaque(colors.green, 0.40) },

    -- Staged line highlights
    GitSignsStagedAddLn = { fg = utils.opaque(colors.green, 0.50), bg = utils.opaque(colors.green, 0.10) },
    GitSignsStagedChangeLn = { fg = utils.opaque(colors.yellow, 0.50), bg = utils.opaque(colors.yellow, 0.10) },
    GitSignsStagedChangedeleteLn = {
      fg = utils.opaque(colors.yellow, 0.50),
      bg = utils.opaque(colors.yellow, 0.10),
    },
    GitSignsStagedUntrackedLn = { fg = utils.opaque(colors.green, 0.50), bg = utils.opaque(colors.green, 0.10) },

    -- Staged current line highlights
    GitSignsStagedAddCul = { fg = utils.opaque(colors.green, 0.40) },
    GitSignsStagedChangeCul = { fg = utils.opaque(colors.yellow, 0.40) },
    GitSignsStagedDeleteCul = { fg = utils.opaque(colors.red, 0.40) },
    GitSignsStagedChangedeleteCul = { fg = utils.opaque(colors.yellow, 0.40) },
    GitSignsStagedTopdeleteCul = { fg = utils.opaque(colors.red, 0.40) },
    GitSignsStagedUntrackedCul = { fg = utils.opaque(colors.green, 0.40) },

    -- Preview highlights
    GitSignsAddPreview = { link = "DiffAdd" },
    GitSignsDeletePreview = { link = "DiffDelete" },

    -- Inline highlights
    GitSignsAddInline = { link = "TermCursor" },
    GitSignsDeleteInline = { link = "TermCursor" },
    GitSignsChangeInline = { link = "TermCursor" },
    GitSignsAddLnInline = { link = "GitSignsAddInline" },
    GitSignsChangeLnInline = { link = "GitSignsChangeInline" },
    GitSignsDeleteLnInline = { link = "GitSignsDeleteInline" },

    -- Virtual line highlights
    GitSignsDeleteVirtLn = { link = "DiffDelete" },
    GitSignsDeleteVirtLnInLine = { link = "GitSignsDeleteLnInline" },
    GitSignsVirtLnum = { link = "GitSignsDeleteVirtLn" },

    -- Blame and other features
    GitSignsCurrentLineBlame = { fg = utils.opaque(colors.foreground_200, 0.60), italic = true },
  }
end

M["akinsho/bufferline.nvim"] = function(colors, plugin_config)
  local light = utils.get_variant() == 2

  local function variant()
    if light then
      return {
        fill_bg = colors.background_800,
        fill_fg = colors.foreground_300,
        visible_bg = colors.background_950,
        visible_fg = colors.foreground_300,
        selected_bg = colors.background_950,
        selected_fg = colors.foreground_200,
        separator = colors.background_800,
      }
    else
      return {
        fill_bg = colors.background_950,
        fill_fg = colors.foreground_200,
        visible_bg = colors.background_950,
        visible_fg = colors.foreground_200,
        selected_bg = colors.background_900,
        selected_fg = colors.foreground_50,
        separator = colors.background_900,
      }
    end
  end

  local palette = variant()

  -- Default configuration using the palette
  local config = {
    selected_bg = palette.selected_bg,
    visible_bg = palette.visible_bg,
    separator = palette.separator,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  local bufferline = {
    fill_bg = palette.fill_bg,
    fill_fg = palette.fill_fg,
    visible_bg = config.visible_bg,
    visible_fg = palette.visible_fg,
    selected_bg = config.selected_bg,
    selected_fg = palette.selected_fg,
    separator = config.separator,
  }

  local buffer_visible = { fg = bufferline.visible_fg, bg = bufferline.visible_bg }
  local buffer_selected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 }
  local diagnostic_colors = { Hint = colors.blue, Info = colors.purple, Warning = colors.yellow, Error = colors.red }

  local highlights = {
    -- General/Default
    Defaults = helpers.with_borders({ sp = colors.background_800 }, config),

    -- Fill & Separators
    BufferLineFill = { fg = bufferline.fill_fg, bg = bufferline.fill_bg },
    BufferLineSeparator = { fg = bufferline.separator, bg = bufferline.fill_bg },
    BufferLineTabSeparator = { fg = bufferline.separator, bg = bufferline.visible_bg },
    BufferLineOffsetSeparator = { fg = colors.background_700, bg = bufferline.visible_bg },
    BufferLineGroupSeparator = { fg = colors.foreground_200, bg = bufferline.visible_bg },
    BufferLineGroupLabel = { fg = colors.background_950, bg = colors.foreground_200 },

    -- Base Buffer States (using buffer_visible reference)
    BufferLineBuffer = buffer_visible,
    BufferLineNumbers = buffer_visible,
    BufferLineCloseButton = buffer_visible,
    BufferLineTab = buffer_visible,
    BufferLineTabClose = buffer_visible,
    BufferLineDiagnostic = buffer_visible,

    -- Visible Buffer States
    BufferLineBufferVisible = buffer_visible,
    BufferLineNumbersVisible = buffer_visible,
    BufferLineCloseButtonVisible = buffer_visible,
    BufferLineDuplicateVisible = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, italic = true },
    BufferLineModifiedVisible = { fg = colors.foreground_50, bg = colors.background_950 },
    BufferLineSeparatorVisible = { fg = colors.foreground_100, bg = bufferline.visible_bg },
    BufferLineIndicatorVisible = { fg = colors.foreground_300, bg = bufferline.visible_bg },

    -- Visible Diagnostics
    BufferLineInfoVisible = buffer_visible,
    BufferLineInfoDiagnosticVisible = buffer_visible,
    BufferLineHintVisible = buffer_visible,
    BufferLineHintDiagnosticVisible = buffer_visible,
    BufferLineWarningVisible = buffer_visible,
    BufferLineWarningDiagnosticVisible = buffer_visible,
    BufferLineErrorVisible = buffer_visible,
    BufferLineErrorDiagnosticVisible = buffer_visible,

    -- Base Diagnostics (visible state)
    BufferLineInfo = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.purple },
    BufferLineInfoDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.purple },
    BufferLineHint = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.blue },
    BufferLineHintDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.blue },
    BufferLineWarning = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.yellow },
    BufferLineWarningDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.purple },
    BufferLineError = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.red },
    BufferLineErrorDiagnostic = { fg = bufferline.visible_fg, bg = bufferline.visible_bg, sp = colors.red },
    -- BufferLineModified = {},

    -- Selected Buffer States
    BufferLineBufferSelected = buffer_selected,
    BufferLineNumbersSelected = buffer_selected,
    BufferLineCloseButtonSelected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineTabSelected = { fg = colors.accent_400, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineModifiedSelected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineIndicatorSelected = { fg = colors.accent_400, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineSeparatorSelected = { fg = colors.foreground_200, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineTabSeparatorSelected = { fg = colors.foreground_300, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineDuplicateSelected = { fg = colors.foreground_200, bg = bufferline.selected_bg, sp = colors.accent_400 },

    -- Selected Diagnostics
    BufferLineInfoSelected = { fg = diagnostic_colors.Info, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineInfoDiagnosticSelected = { fg = diagnostic_colors.Info, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineHintSelected = { fg = diagnostic_colors.Hint, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineHintDiagnosticSelected = { fg = diagnostic_colors.Hint, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineWarningSelected = { fg = diagnostic_colors.Warning, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineErrorSelected = { fg = diagnostic_colors.Error, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },
    BufferLineErrorDiagnosticSelected = { fg = diagnostic_colors.Error, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 },

    -- Pick States
    BufferLinePick = { fg = colors.red, bg = bufferline.visible_bg, bold = true, cterm = { bold = true } },
    BufferLinePickVisible = { fg = colors.red, bg = bufferline.visible_bg, bold = true, cterm = { bold = true } },
    BufferLinePickSelected = { fg = colors.red, bg = bufferline.selected_bg, bold = true },
  }
  return helpers.default(highlights)
end

M["folke/trouble.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.background_950,
    fg = colors.foreground_100,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    ["trouble"] = function()
      return {
        StatusLine = { bg = config.bg, fg = config.fg },
      }
    end,
    TroubleNormal = { bg = config.bg, fg = config.fg },
    TroubleFile = { bg = config.bg, fg = config.fg },
    TroubleSignOther = { bg = config.bg, fg = config.fg },
    TroubleInformation = { bg = config.bg, fg = config.fg },
  }
end

M["NeogitOrg/neogit"] = function(colors, config)
  local neogit = {
    bg = colors.background_950,
    fg = colors.foreground_100,
    header_bg = colors.background_800,
    section_fg = colors.green,
    accent_fg = colors.accent_200,
    subtle_fg = colors.foreground_300,
  }

  return {
    -- Base UI Elements
    NeogitActiveItem = { bg = colors.background_900, bold = true },
    NeogitCursorLine = { link = "CursorLine" },
    NeogitCursorLineNr = { link = "CursorLineNr" },
    NeogitNormal = { link = "Normal" },
    NeogitFold = { clear = true },

    -- Float/Header Components
    NeogitFloatHeader = { bold = true, bg = colors.background_950 },
    NeogitFloatHeaderHighlight = { bold = true, fg = colors.foreground_200, bg = colors.background_900 },

    -- Section Headers
    NeogitSectionHeader = { bold = true, fg = neogit.section_fg },
    NeogitSectionHeaderCount = { clear = true },

    -- Section Types
    NeogitStashes = { fg = neogit.subtle_fg },
    NeogitStagedchanges = { fg = neogit.subtle_fg },
    NeogitUnstagedchanges = { fg = neogit.subtle_fg },
    NeogitUntrackedfiles = { fg = neogit.subtle_fg },
    NeogitUnpushedchanges = { fg = neogit.subtle_fg },
    NeogitUnpulledchanges = { fg = neogit.subtle_fg },
    NeogitUnmergedchanges = { fg = neogit.subtle_fg },
    NeogitRecentcommits = { fg = neogit.subtle_fg },

    -- Change Types
    NeogitChangeAdded = { fg = utils.opaque(colors.green, 0.7), bold = true, italic = true },
    NeogitChangeModified = { fg = utils.opaque(colors.green, 0.7), bold = true, italic = true },
    NeogitChangeDeleted = { fg = utils.opaque(colors.red, 0.7), bold = true, italic = true },
    NeogitChangeRenamed = { fg = utils.opaque(colors.green, 0.7), bold = true, italic = true },
    NeogitChangeUpdated = { fg = utils.opaque(neogit.subtle_fg, 0.7), bold = true, italic = true },
    NeogitChangeCopied = { fg = utils.opaque(colors.foreground_200, 0.7), bold = true, italic = true },
    NeogitChangeUnmerged = { fg = utils.opaque(colors.foreground_100, 0.7), bold = true, italic = true },
    NeogitChangeNewFile = { fg = utils.opaque(colors.green, 0.7), bold = true, italic = true },
    NeogitChangeUntrackedstaged = { clear = true },
    NeogitChangeUntrackedunstaged = { clear = true },
    NeogitChangeUntrackeduntracked = { clear = true },

    -- Diff Additions
    NeogitDiffAdd = { fg = colors.green, bg = utils.opaque(colors.green, 0.15) },
    NeogitDiffAddHighlight = { fg = colors.green, bg = utils.opaque(colors.green, 0.15) },
    NeogitDiffAddCursor = { fg = colors.green, bg = utils.opaque(colors.green, 0.20) },
    NeogitDiffAdditions = { fg = colors.green },

    -- Diff Deletions
    NeogitDiffDelete = { fg = colors.red, bg = utils.opaque(colors.red, 0.15) },
    NeogitDiffDeleteHighlight = { fg = colors.red, bg = utils.opaque(colors.red, 0.15) },
    NeogitDiffDeleteCursor = { fg = colors.red, bg = utils.opaque(colors.red, 0.20) },
    NeogitDiffDeletions = { fg = colors.red },

    -- Diff Context
    NeogitDiffContext = { bg = colors.background_950 },
    NeogitDiffContextHighlight = { bg = colors.background_950 },
    NeogitDiffContextCursor = { bg = colors.background_900 },

    -- Diff Headers
    NeogitDiffHeader = helpers.with_borders({ fg = neogit.fg, bg = colors.background_950, sp = colors.background_800 }, config),
    NeogitDiffHeaderHighlight = helpers.with_borders(
      { bg = colors.background_900, fg = colors.foreground_100, sp = colors.background_800, bold = true },
      config
    ),
    NeogitDiffHeaderCursor = helpers.with_borders({ bg = colors.background_900, sp = colors.background_800, bold = true }, config),

    -- Hunk Headers
    NeogitHunkHeader = helpers.with_borders(
      { bg = colors.background_900, fg = colors.foreground_200, sp = colors.background_800, bold = true },
      config
    ),
    NeogitHunkHeaderHighlight = helpers.with_borders(
      { bg = colors.background_900, fg = colors.foreground_200, sp = colors.background_800, bold = true },
      config
    ),
    NeogitHunkHeaderCursor = helpers.with_borders(
      { bg = colors.background_900, fg = colors.foreground_100, sp = colors.background_800, bold = true },
      config
    ),

    -- Merge Headers
    NeogitHunkMergeHeader = { bold = true, fg = colors.foreground_100, bg = colors.background_950 },
    NeogitHunkMergeHeaderHighlight = { bold = true, fg = colors.background_950 },
    NeogitHunkMergeHeaderCursor = { bold = true, fg = colors.background_950, bg = colors.foreground_200 },

    -- Popup Elements
    NeogitPopupBold = { bold = true },
    NeogitPopupActionKey = { fg = neogit.accent_fg },
    NeogitPopupConfigKey = { fg = neogit.accent_fg },
    NeogitPopupOptionKey = { fg = neogit.accent_fg },
    NeogitPopupSwitchKey = { fg = neogit.accent_fg },

    -- Git References
    NeogitBranch = { bold = true, fg = neogit.accent_fg },
    NeogitBranchHead = { bold = true, underline = true, fg = neogit.accent_fg },
    NeogitRemote = { bold = true, fg = neogit.accent_fg },
    NeogitUnpushedTo = { bold = true, fg = colors.green },
    NeogitUnpulledFrom = { bold = true, fg = colors.green },
    NeogitUnmergedInto = { bold = true, fg = colors.green },
    NeogitTagName = { fg = neogit.accent_fg },
    NeogitTagDistance = { fg = colors.foreground_200 },

    -- File and Commit Elements
    NeogitFilePath = { italic = true, fg = neogit.subtle_fg },
    NeogitCommitViewHeader = { fg = colors.foreground_300 },
    NeogitCommitViewDescription = { fg = neogit.subtle_fg },
    NeogitStatusHEAD = { clear = true },

    -- Graph Colors (Regular)
    NeogitGraphWhite = { fg = colors.foreground_50 },
    NeogitGraphRed = { fg = colors.red },
    NeogitGraphGreen = { fg = neogit.accent_fg },
    NeogitGraphYellow = { fg = neogit.accent_fg },
    NeogitGraphBlue = { fg = neogit.accent_fg },
    NeogitGraphPurple = { fg = neogit.accent_fg },
    NeogitGraphCyan = { fg = colors.foreground_200 },
    NeogitGraphOrange = { fg = colors.foreground_200 },
    NeogitGraphGray = { fg = colors.foreground_100 },
    NeogitGraphAuthor = { fg = colors.foreground_200 },

    -- Graph Colors (Bold)
    NeogitGraphBoldWhite = { bold = true, fg = colors.foreground_50 },
    NeogitGraphBoldRed = { bold = true, fg = colors.red },
    NeogitGraphBoldGreen = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldYellow = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldBlue = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldPurple = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldCyan = { bold = true, fg = colors.foreground_200 },
    NeogitGraphBoldOrange = { bold = true, fg = colors.foreground_200 },
    NeogitGraphBoldGray = { bold = true, fg = colors.foreground_100 },
  }
end

M["MeanderingProgrammer/render-markdown.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    heading_fg = colors.foreground_100,
    code_bg = colors.background_900,
    inline_code_fg = colors.accent_500,
    inline_code_bg = colors.background_950,
    table_fg = colors.foreground_100,
    quote_fg = colors.foreground_300,
    link_fg = colors.foreground_200,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Headers
    RenderMarkdownH1 = { fg = config.heading_fg, bold = true },
    RenderMarkdownH2 = { fg = config.heading_fg, bold = true },
    RenderMarkdownH3 = { fg = colors.foreground_200, bold = true },
    RenderMarkdownH4 = { fg = config.heading_fg, bold = true },
    RenderMarkdownH5 = { fg = colors.foreground_50, bold = true },
    RenderMarkdownH6 = { fg = colors.foreground_300, bold = true },

    -- Header Backgrounds
    RenderMarkdownH1Bg = { fg = colors.accent_300, bold = true },
    RenderMarkdownH2Bg = { fg = colors.accent_200, bold = true },
    RenderMarkdownH3Bg = { fg = colors.accent_200, bold = true },
    RenderMarkdownH4Bg = { fg = colors.accent_200, bold = true },
    RenderMarkdownH5Bg = { clear = true },
    RenderMarkdownH6Bg = { clear = true },

    -- Code Elements
    RenderMarkdownCode = { bg = config.code_bg },
    RenderMarkdownCodeInline = { fg = config.inline_code_fg, bg = config.inline_code_bg },
    RenderMarkdownCodeInfo = { link = "@label" },
    RenderMarkdownCodeBorder = { bg = colors.background_800 },
    RenderMarkdownCodeFallback = { fg = colors.foreground_300, bg = colors.background_950 },

    -- Table Elements
    RenderMarkdownTableHead = { fg = config.table_fg, bold = true },
    RenderMarkdownTableRow = { fg = colors.foreground_200, bg = colors.background_950 },
    RenderMarkdownTableFill = { fg = colors.foreground_400 },

    -- Status/Alert Elements
    RenderMarkdownSuccess = { fg = colors.green },
    RenderMarkdownInfo = { fg = colors.foreground_50 },
    RenderMarkdownHint = { fg = colors.green },
    RenderMarkdownWarn = { fg = colors.yellow },
    RenderMarkdownError = { fg = colors.red },

    -- Quote Elements
    RenderMarkdownQuote = { fg = config.quote_fg, italic = true },
    RenderMarkdownQuote1 = { link = "RenderMarkdownQuote" },
    RenderMarkdownQuote2 = { link = "RenderMarkdownQuote" },
    RenderMarkdownQuote3 = { link = "RenderMarkdownQuote" },
    RenderMarkdownQuote4 = { link = "RenderMarkdownQuote" },
    RenderMarkdownQuote5 = { link = "RenderMarkdownQuote" },
    RenderMarkdownQuote6 = { link = "RenderMarkdownQuote" },

    -- Link Elements
    RenderMarkdownLink = { fg = config.link_fg, underline = true },
    RenderMarkdownWikiLink = { fg = config.link_fg, underline = true, bold = true },

    -- Task List Elements
    RenderMarkdownChecked = { fg = colors.accent_500 },
    RenderMarkdownUnchecked = { fg = colors.foreground_300 },
    RenderMarkdownTodo = { fg = colors.accent_500 },

    -- Special Elements
    RenderMarkdownMath = { fg = colors.accent_500 },
    RenderMarkdownInlineHighlight = { fg = colors.accent_500, bg = colors.background_950 },
    RenderMarkdownBullet = { fg = colors.foreground_300 },

    -- Structural Elements
    RenderMarkdownIndent = { fg = colors.foreground_400 },
    RenderMarkdownSign = { fg = colors.foreground_300 },
    RenderMarkdownDash = { fg = colors.foreground_300 },

    -- Miscellaneous
    RenderMarkdownHtmlComment = { fg = colors.foreground_300, italic = true },
  }
end

M["sindrets/diffview.nvim"] = function(colors, plugin_config)
  return {
    -- Primary UI elements
    DiffviewPrimary = { fg = colors.foreground_100 },
    DiffviewSecondary = { fg = colors.accent_300 },
    DiffviewDim1 = { fg = colors.foreground_400 },

    -- File panel highlights
    DiffviewFilePanelTitle = { bg = colors.background_900, fg = colors.accent_400, bold = true },
    DiffviewFilePanelCounter = { bg = colors.background_900, fg = colors.foreground_300, bold = true },
    DiffviewFilePanelFileName = { fg = colors.foreground_200 },
    DiffviewFilePanelPath = { link = "Comment" },
    DiffviewFilePanelSelected = { link = "Type" },
    DiffviewFilePanelRootPath = { link = "DiffviewFilePanelTitle" },
    DiffviewFilePanelConflicts = { link = "DiagnosticSignWarn" },
    DiffviewFilePanelDeletions = { link = "diffRemoved" },
    DiffviewFilePanelInsertions = { link = "diffAdded" },

    -- Status highlights
    DiffviewStatusAdded = { link = "diffAdded" },
    DiffviewStatusUntracked = { link = "diffAdded" },
    DiffviewStatusModified = { link = "diffChanged" },
    DiffviewStatusRenamed = { link = "diffChanged" },
    DiffviewStatusCopied = { link = "diffChanged" },
    DiffviewStatusTypeChange = { link = "diffChanged" },
    DiffviewStatusUnmerged = { link = "diffChanged" },
    DiffviewStatusUnknown = { link = "diffRemoved" },
    DiffviewStatusDeleted = { link = "diffRemoved" },
    DiffviewStatusBroken = { link = "diffRemoved" },
    DiffviewStatusIgnored = { link = "Comment" },

    -- Diff highlights
    DiffviewDiffAdd = { fg = "none", bg = utils.opaque(colors.green, 0.15) },
    DiffviewDiffChange = { fg = "none", bg = "none" },
    DiffviewDiffText = { fg = "none", bg = utils.opaque(colors.yellow, 0.20) },
    DiffviewDiffDelete = { fg = colors.background_950, bg = utils.opaque(colors.red, 0.20) },
    DiffviewDiffAddAsDelete = { fg = colors.red, bg = utils.opaque(colors.red, 0.20) },
    DiffviewDiffDeleteDim = { link = "Comment" },

    -- Window and UI elements
    DiffviewNormal = { bg = colors.background_900 },
    DiffviewCursorLine = { link = "CursorLine" },
    DiffviewSignColumn = { link = "Normal" },
    DiffviewStatusLine = { link = "StatusLine" },
    DiffviewStatusLineNC = { link = "StatusLineNC" },
    DiffviewWinSeparator = { bg = colors.background_900, fg = colors.background_800 },
    DiffviewEndOfBuffer = { link = "EndOfBuffer" },
    DiffviewNonText = { link = "NonText" },

    -- Folder and tree elements
    DiffviewFolderName = { link = "Directory" },
    DiffviewFolderSign = { link = "PreProc" },

    -- Git references and metadata
    DiffviewReference = { link = "Function" },
    DiffviewHash = { link = "Identifier" },
    DiffviewReflogSelector = { link = "Special" },
  }
end

M["Bekaboo/dropbar.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    fg = colors.foreground_100,
    bg = colors.background_900,
    hover_bg = utils.opaque(colors.background_600, 0.30),
    separator_fg = colors.foreground_300,
    icon_fg = colors.accent_500,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Core UI elements
    DropBarCurrentContext = { bg = config.hover_bg },
    DropBarHover = { bg = config.hover_bg },
    DropBarPreview = { bg = config.hover_bg },
    DropBarLinkTarget = { fg = config.fg },

    -- Menu elements
    DropBarMenuCurrentContext = { bg = colors.background_800, fg = config.fg },
    DropBarMenuNormalFloat = { bg = config.bg, fg = config.fg },
    DropBarMenuFloatBorder = { bg = config.bg, fg = colors.background_800 },
    DropBarMenuHoverEntry = { bg = colors.background_800, fg = config.fg },
    DropBarMenuHoverSymbol = { bold = true },
    DropBarMenuHoverIcon = { reverse = true },

    -- Icons
    DropBarIconKindDefault = { fg = colors.foreground_100 },
    DropBarIconKindFile = { fg = colors.foreground_100 },
    DropBarIconKindFolder = { fg = colors.foreground_100 },
    DropBarIconKindList = { fg = colors.foreground_100 },
    DropBarIconKindArray = { fg = colors.foreground_100 },
    DropBarIconKindFunction = { fg = colors.foreground_100 },
    DropBarIconKindMethod = { fg = colors.foreground_100 },
    DropBarIconKindClass = { fg = colors.foreground_100 },
    DropBarIconKindModule = { fg = colors.foreground_100 },
    DropBarIconKindNamespace = { fg = colors.foreground_100 },
    DropBarIconKindConstant = { fg = colors.foreground_100 },
    DropBarIconKindVariable = { fg = colors.foreground_100 },

    -- UI separators
    DropBarIconUIIndicator = { fg = config.icon_fg },
    DropBarIconUISeparator = { fg = config.separator_fg },
    DropBarIconUIPickPivot = { fg = config.icon_fg },
    DropBarFzfMatch = { fg = config.icon_fg },
  }
end

M["DNLHC/glance.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    fg = colors.foreground_100,
    muted_fg = colors.foreground_300,
    -- bg = colors.background_900,
    bg = colors.background_900,
    border_fg = colors.background_700,
    border_sp = colors.background_800,
    cursorline_bg = utils.opaque(colors.background_600, 0.10),
    match_bg = colors.background_800,
    indent_fg = utils.opaque(colors.foreground_400, 0.20),
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Main window elements
    GlanceNone = { clear = true },
    GlanceWinBarTitle = helpers.with_borders({ fg = config.fg, bg = config.bg, sp = config.border_sp }, config),
    GlanceWinBarFilepath = helpers.with_borders({ fg = config.muted_fg, bg = config.bg, sp = config.border_sp }, config),
    GlanceWinBarFilename = helpers.with_borders({ fg = config.fg, bg = config.bg, sp = config.border_sp }, config),

    -- List panel
    GlanceListNormal = { fg = config.fg, bg = config.bg },
    GlanceListCursorLine = { bg = config.cursorline_bg },
    GlanceListFilepath = { fg = config.muted_fg },
    GlanceListFilename = { link = "Directory" },
    GlanceListCount = { link = "Number" },
    GlanceListMatch = { link = "Search" },
    GlanceListEndOfBuffer = { fg = config.bg, bg = config.bg },
    GlanceListBorderBottom = { fg = config.border_fg, bg = config.bg },

    -- Preview panel
    GlancePreviewNormal = { bg = config.bg },
    GlancePreviewCursorLine = { bg = config.cursorline_bg },
    GlancePreviewMatch = { bg = config.match_bg },
    GlancePreviewSignColumn = { fg = config.bg },
    GlancePreviewLineNr = { fg = config.muted_fg },
    GlancePreviewEndOfBuffer = { fg = config.bg, bg = config.bg },
    GlancePreviewBorderBottom = { fg = config.border_fg, bg = config.bg },

    -- Borders and separators
    GlanceBorderTop = { fg = config.border_fg, bg = config.bg },
    GlanceIndent = { fg = config.indent_fg },
    GlanceFoldIcon = { fg = config.muted_fg },
  }
end

M["MagicDuck/grug-far.nvim"] = function(colors, plugin_config)
  return {
    -- Main window and background
    GrugFarNormal = { fg = colors.foreground_100 },
    GrugFarWinSeparator = { fg = colors.background_800 },
    GrugFarEndOfBuffer = { fg = colors.background_900 },

    -- Change indicators with enhanced visibility
    GrugFarResultsChangeIndicator = { fg = colors.yellow, bold = true },
    GrugFarResultsAddIndicator = { fg = colors.green, bold = true },
    GrugFarResultsRemoveIndicator = { fg = colors.red, bold = true },

    -- Line numbers with proper base colors
    GrugFarResultsLineNr = { fg = colors.foreground_300 },
    GrugFarResultsNumbersSeparator = { fg = colors.foreground_400 },
    GrugFarResultsColumnNr = { fg = colors.foreground_300 },
    GrugFarResultsCursorLineNo = { fg = colors.foreground_300, bold = true },

    -- File paths with enhanced styling
    GrugFarResultsPath = { fg = colors.foreground_300 },
    GrugFarResultsPathIcon = { fg = colors.accent_500 },

    -- Match highlighting with base colors
    GrugFarResultsMatch = { bg = utils.opaque(colors.background_600, 0.25), bold = true },
    GrugFarResultsMatchRemoved = { bg = utils.opaque(colors.red, 0.30), bold = true },
    GrugFarResultsMatchAdded = { bg = utils.opaque(colors.green, 0.30), bold = true },

    -- Context lines
    GrugFarResultsLine = { fg = colors.foreground_300 },
    GrugFarResultsLineContext = { fg = colors.foreground_300 },

    -- Headers with enhanced visibility
    GrugFarResultsHeader = { fg = colors.foreground_200 },
    GrugFarResultsCmdHeader = { fg = colors.foreground_300, bold = true, underline = true },

    -- UI messages and stats with base colors
    GrugFarResultsActionMessage = { fg = colors.foreground_200, bold = true },
    GrugFarResultsStats = { fg = colors.foreground_300, italic = true },
    GrugFarResultsStatsSuccess = { fg = colors.green, bold = true },
    GrugFarResultsStatsError = { fg = colors.red, bold = true },

    -- Input elements with proper theming
    GrugFarInputPlaceholder = { blend = 100, fg = colors.foreground_300 },
    GrugFarInputLabel = { fg = colors.foreground_300, bold = true },
    GrugFarInputText = { fg = colors.foreground_100 },
    GrugFarInputBorder = { fg = colors.background_700 },

    -- Help window elements with consistent theming
    GrugFarHelpWinNormal = { fg = colors.foreground_100 },
    GrugFarHelpWinBorder = { fg = colors.foreground_300 },
    GrugFarHelpWinActionDescription = { fg = colors.foreground_200 },
    GrugFarHelpWinActionKey = { fg = colors.foreground_300, bold = true },
    GrugFarHelpWinActionText = { fg = colors.foreground_100 },
    GrugFarHelpWinActionPrefix = { fg = colors.foreground_200, bold = true },
    GrugFarHelpWinHeader = { fg = colors.foreground_200, bold = true, underline = true },
    GrugFarHelpHeaderKey = { fg = colors.foreground_300, bold = true },
    GrugFarHelpHeader = { fg = colors.foreground_200, bold = true },

    -- Selection and cursor highlights
    GrugFarCursorLine = { bg = utils.opaque(colors.background_600, 0.30) },
    GrugFarSelection = { bg = utils.opaque(colors.accent_500, 0.20) },

    -- Search progress and status
    GrugFarProgressBar = { bg = colors.accent_500 },
    GrugFarProgressBg = { bg = colors.background_800 },

    -- Miscellaneous elements with base colors
    GrugFarResultsLongLineStr = { fg = colors.foreground_300, italic = true },
    GrugFarResultsNumberLabel = { fg = colors.foreground_300, bold = true },
    GrugFarVisualBufrange = { bg = utils.opaque(colors.accent_500, 0.25) },
    GrugFarResultsDiffSeparatorIndicator = { fg = colors.foreground_400 },

    -- Folding
    GrugFarFold = { fg = colors.foreground_300 },
    GrugFarFoldMarker = { fg = colors.accent_500, bold = true },

    -- Error and warning states
    GrugFarError = { fg = colors.red, bold = true },
    GrugFarWarning = { fg = colors.yellow, bold = true },
    GrugFarInfo = { fg = colors.blue },
  }
end

M["OXY2DEV/markview.nvim"] = function(colors, plugin_config)
  return {
    -- Palette colors (0-6 use base colors, 7 uses green accent)
    MarkviewPalette0 = { fg = colors.foreground_300, bg = colors.background_900 },
    MarkviewPalette0Fg = { fg = colors.foreground_300 },
    MarkviewPalette0Bg = { bg = colors.background_900 },
    MarkviewPalette0Sign = { fg = colors.foreground_300 },

    MarkviewPalette1 = { fg = colors.foreground_100, bg = colors.background_900 },
    MarkviewPalette1Fg = { fg = colors.foreground_100 },
    MarkviewPalette1Bg = { bg = colors.background_900 },
    MarkviewPalette1Sign = { fg = colors.foreground_100 },

    MarkviewPalette2 = { fg = colors.foreground_100, bg = colors.background_900 },
    MarkviewPalette2Fg = { fg = colors.foreground_100 },
    MarkviewPalette2Bg = { bg = colors.background_900 },
    MarkviewPalette2Sign = { fg = colors.foreground_100 },

    MarkviewPalette3 = { fg = colors.foreground_100, bg = colors.background_900 },
    MarkviewPalette3Fg = { fg = colors.foreground_100 },
    MarkviewPalette3Bg = { bg = colors.background_900 },
    MarkviewPalette3Sign = { fg = colors.foreground_100 },

    MarkviewPalette4 = { fg = colors.foreground_100, bg = colors.background_900 },
    MarkviewPalette4Fg = { fg = colors.foreground_100 },
    MarkviewPalette4Bg = { bg = colors.background_900 },
    MarkviewPalette4Sign = { fg = colors.foreground_100 },

    MarkviewPalette5 = { fg = colors.foreground_100, bg = colors.background_900 },
    MarkviewPalette5Fg = { fg = colors.foreground_100 },
    MarkviewPalette5Bg = { bg = colors.background_900 },
    MarkviewPalette5Sign = { fg = colors.foreground_100 },

    MarkviewPalette6 = { fg = colors.foreground_100, bg = colors.background_900 },
    MarkviewPalette6Fg = { fg = colors.foreground_100 },
    MarkviewPalette6Bg = { bg = colors.background_900 },
    MarkviewPalette6Sign = { fg = colors.foreground_100 },

    MarkviewPalette7 = { fg = colors.green, bg = colors.background_900 },
    MarkviewPalette7Fg = { fg = colors.green },
    MarkviewPalette7Bg = { bg = colors.background_900 },
    MarkviewPalette7Sign = { fg = colors.green },

    -- Block quotes using palette colors
    MarkviewBlockQuoteDefault = { link = "MarkviewPalette0Fg" },
    MarkviewBlockQuoteError = { link = "MarkviewPalette1Fg" },
    MarkviewBlockQuoteNote = { link = "MarkviewPalette5Fg" },
    MarkviewBlockQuoteOk = { link = "MarkviewPalette4Fg" },
    MarkviewBlockQuoteSpecial = { link = "MarkviewPalette3Fg" },
    MarkviewBlockQuoteWarn = { link = "MarkviewPalette2Fg" },

    -- Checkboxes using palette and status colors
    MarkviewCheckboxCancelled = { link = "MarkviewPalette0Fg" },
    MarkviewCheckboxChecked = { link = "MarkviewPalette4Fg" },
    MarkviewCheckboxPending = { link = "MarkviewPalette2Fg" },
    MarkviewCheckboxProgress = { link = "MarkviewPalette6Fg" },
    MarkviewCheckboxStriked = { fg = colors.foreground_300, strikethrough = true },
    MarkviewCheckboxUnchecked = { link = "MarkviewPalette1Fg" },

    -- Code blocks using base colors
    MarkviewCode = { bg = colors.background_900 },
    MarkviewCodeFg = { fg = colors.background_950 },
    MarkviewCodeInfo = { bg = colors.background_900, fg = colors.foreground_300 },

    -- Links
    MarkviewEmail = { link = "@markup.link.url.markdown_inline" },
    MarkviewHyperlink = { link = "@markup.link.label.markdown_inline" },
    MarkviewImage = { link = "@markup.link.label.markdown_inline" },

    -- Gradient colors (progressive gray scale)
    MarkviewGradient0 = { fg = colors.foreground_400 },
    MarkviewGradient1 = { fg = colors.foreground_400 },
    MarkviewGradient2 = { fg = colors.foreground_300 },
    MarkviewGradient3 = { fg = colors.foreground_300 },
    MarkviewGradient4 = { fg = colors.foreground_200 },
    MarkviewGradient5 = { fg = colors.foreground_200 },
    MarkviewGradient6 = { fg = colors.foreground_100 },
    MarkviewGradient7 = { fg = colors.foreground_100 },
    MarkviewGradient8 = { fg = colors.foreground_50 },
    MarkviewGradient9 = { fg = colors.foreground_50 },

    -- Headings using palette colors (1-6)
    MarkviewHeading1 = { link = "MarkviewPalette1" },
    MarkviewHeading1Sign = { link = "MarkviewPalette1Sign" },
    MarkviewHeading2 = { link = "MarkviewPalette2" },
    MarkviewHeading2Sign = { link = "MarkviewPalette2Sign" },
    MarkviewHeading3 = { link = "MarkviewPalette3" },
    MarkviewHeading3Sign = { link = "MarkviewPalette3Sign" },
    Markviewheading4 = { link = "MarkviewPalette4" },
    Markviewheading4Sign = { link = "MarkviewPalette4Sign" },
    MarkviewHeading5 = { link = "MarkviewPalette5" },
    MarkviewHeading5Sign = { link = "MarkviewPalette5Sign" },
    MarkviewHeading6 = { link = "MarkviewPalette6" },
    MarkviewHeading6Sign = { link = "MarkviewPalette6Sign" },

    -- Icons using palette colors with code background
    MarkviewIcon0 = { fg = colors.foreground_300, bg = colors.background_800 },
    MarkviewIcon1 = { fg = colors.foreground_100, bg = colors.background_800 },
    MarkviewIcon2 = { fg = colors.foreground_100, bg = colors.background_800 },
    MarkviewIcon3 = { fg = colors.foreground_100, bg = colors.background_800 },
    MarkviewIcon4 = { fg = colors.foreground_100, bg = colors.background_800 },
    MarkviewIcon5 = { fg = colors.foreground_100, bg = colors.background_800 },
    MarkviewIcon6 = { fg = colors.foreground_100, bg = colors.background_800 },

    -- Inline code (similar to render-markdown)
    MarkviewInlineCode = { bg = colors.background_950, fg = colors.accent_500 },

    -- List items using palette colors
    MarkviewListItemMinus = { link = "MarkviewPalette2Fg" },
    MarkviewListItemPlus = { link = "MarkviewPalette4Fg" },
    MarkviewListItemStar = { link = "MarkviewPalette6Fg" },

    -- Sub/superscript using palette colors
    MarkviewSubscript = { link = "MarkviewPalette3Fg" },
    MarkviewSuperscript = { link = "MarkviewPalette6Fg" },

    -- Table elements using base colors (similar to render-markdown)
    MarkviewTableAlignCenter = { link = "@markup.heading" },
    MarkviewTableAlignLeft = { link = "@markup.heading" },
    MarkviewTableAlignRight = { link = "@markup.heading" },
    MarkviewTableBorder = { link = "MarkviewPalette5Fg" },
    MarkviewTableHeader = { link = "@markup.heading" },
  }
end

M["folke/which-key.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    key_fg = colors.accent_500,
    group_fg = colors.foreground_300,
    bg = colors.background_900,
    border_fg = colors.background_900,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    WhichKey = { fg = config.key_fg },
    WhichKeyIcon = { fg = colors.foreground_300 },
    WhichKeyBorder = { bg = config.bg, fg = config.border_fg },
    WhichKeyGroup = { fg = config.group_fg },
    WhichKeySeparator = { link = "Comment" },
    WhichKeyTitle = { bg = config.bg },
    WhichKeyIconRed = { link = "DiagnosticError" },
    WhichKeyIconPurple = { link = "Constant" },
    WhichKeyIconOrange = { link = "DiagnosticWarn" },
    WhichKeyIconGrey = { link = "Normal" },
    WhichKeyIconGreen = { link = "DiagnosticOk" },
    WhichKeyIconCyan = { link = "DiagnosticHint" },
    WhichKeyIconBlue = { link = "DiagnosticInfo" },
    WhichKeyIconAzure = { link = "Function" },
    WhichKeyDesc = { link = "Identifier" },
    WhichKeyNormal = { bg = config.bg },
    WhichKeyIconYellow = { link = "DiagnosticWarn" },
    WhichKeyValue = { link = "Comment" },
  }
end

M["petertriho/nvim-scrollbar"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    handle_bg = utils.opaque(colors.background_600, 0.30),
    git_add_fg = colors.green,
    git_change_fg = colors.yellow,
    git_delete_fg = colors.red,
    error_fg = colors.red,
    warn_fg = colors.yellow,
    info_fg = colors.blue,
    hint_fg = colors.green,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Base scrollbar elements
    ScrollbarHandle = { bg = config.handle_bg },

    -- Miscellaneous scrollbar indicators
    ScrollbarMisc = { fg = colors.foreground_300 },
    ScrollbarMiscHandle = { fg = colors.foreground_300, bg = utils.opaque(colors.background_600, 0.30) },

    -- Git indicators
    ScrollbarGitAdd = { fg = config.git_add_fg },
    ScrollbarGitAddHandle = { fg = config.git_add_fg, bg = config.handle_bg },
    ScrollbarGitChange = { fg = config.git_change_fg },
    ScrollbarGitChangeHandle = { fg = config.git_change_fg, bg = config.handle_bg },
    ScrollbarGitDelete = { fg = config.git_delete_fg },
    ScrollbarGitDeleteHandle = { fg = config.git_delete_fg, bg = config.handle_bg },

    -- Diagnostic indicators
    ScrollbarError = { fg = config.error_fg },
    ScrollbarErrorHandle = { fg = config.error_fg, bg = config.handle_bg },
    ScrollbarWarn = { fg = config.warn_fg },
    ScrollbarWarnHandle = { fg = config.warn_fg, bg = config.handle_bg },
    ScrollbarInfo = { fg = config.info_fg },
    ScrollbarInfoHandle = { fg = config.info_fg, bg = config.handle_bg },
    ScrollbarHint = { fg = config.hint_fg },
    ScrollbarHintHandle = { fg = config.hint_fg, bg = config.handle_bg },

    -- Search indicators
    ScrollbarSearch = { fg = colors.foreground_50 },
    ScrollbarSearchHandle = { fg = colors.foreground_50, bg = utils.opaque(colors.background_600, 0.30) },

    -- Cursor position indicator
    ScrollbarCursor = { fg = colors.foreground_300 },
    ScrollbarCursorHandle = { fg = colors.foreground_300, bg = utils.opaque(colors.background_600, 0.30) },
  }
end

M["yetone/avante.nvim"] = function(colors, global_config, plugin_config)
  return {
    -- State indicators with colorful backgrounds
    AvanteStateSpinnerSearching = { fg = colors.background_950, bg = colors.purple },
    AvanteStateSpinnerSucceeded = { fg = colors.background_950, bg = colors.green },
    AvanteStateSpinnerFailed = { fg = colors.background_950, bg = colors.red },
    AvanteStateSpinnerToolCalling = { fg = colors.background_950, bg = colors.blue },
    AvanteStateSpinnerGenerating = { fg = colors.background_950, bg = colors.accent_300 },
    AvanteStateSpinnerCompacting = { fg = colors.background_950, bg = colors.purple },
    AvanteStateSpinnerThinking = { fg = colors.background_950, bg = colors.purple },

    -- Main UI elements
    AvanteReversedNormal = { bg = colors.foreground_300 },
    AvanteCommentFg = { fg = colors.foreground_300 },

    -- Logo gradient (from dark to light)
    AvanteLogoLine1 = { fg = colors.foreground_50 },
    AvanteLogoLine2 = { fg = colors.foreground_100 },
    AvanteLogoLine3 = { fg = colors.foreground_100 },
    AvanteLogoLine4 = { fg = colors.foreground_200 },
    AvanteLogoLine5 = { fg = colors.foreground_200 },
    AvanteLogoLine6 = { fg = colors.foreground_300 },
    AvanteLogoLine7 = { fg = colors.foreground_300 },
    AvanteLogoLine8 = { fg = colors.foreground_400 },
    AvanteLogoLine9 = { fg = colors.foreground_400 },
    AvanteLogoLine10 = { fg = colors.foreground_400 },
    AvanteLogoLine11 = { fg = colors.foreground_400 },
    AvanteLogoLine12 = { fg = colors.foreground_400 },
    AvanteLogoLine13 = { fg = colors.foreground_400 },
    AvanteLogoLine14 = { fg = colors.foreground_400 },

    -- Buttons with proper styling
    AvanteButtonDefault = { fg = colors.background_950, bg = colors.foreground_200 },
    AvanteButtonDefaultHover = { fg = colors.background_950, bg = colors.green },
    AvanteButtonPrimary = { fg = colors.background_950, bg = colors.foreground_200 },
    AvanteButtonPrimaryHover = { fg = colors.background_950, bg = colors.blue },
    AvanteButtonDanger = { fg = colors.background_950, bg = colors.foreground_200 },
    AvanteButtonDangerHover = { fg = colors.background_950, bg = colors.red },

    -- Titles and headers
    AvanteTitle = { fg = colors.background_950, bg = colors.green },
    AvanteSubtitle = { fg = colors.background_950, bg = colors.blue },
    AvanteReversedTitle = { fg = colors.green, bg = colors.background_950 },
    AvanteReversedSubtitle = { fg = colors.blue, bg = colors.background_950 },
    AvanteThirdTitle = { fg = colors.foreground_200, bg = colors.background_800 },
    AvanteReversedThirdTitle = { fg = colors.background_800, bg = colors.background_950 },

    -- Sidebar and floating elements
    AvanteSidebarNormal = { link = "NormalFloat" },
    AvanteSidebarWinSeparator = { fg = colors.background_950, bg = colors.background_950 },
    AvanteSidebarWinHorizontalSeparator = { fg = colors.background_800, bg = colors.background_950 },

    -- Popup and input elements
    AvantePopupHint = { link = "NormalFloat" },
    AvantePromptInput = { clear = true },
    AvantePromptInputBorder = { link = "NormalFloat" },

    -- Task status indicators
    AvanteTaskRunning = { fg = colors.purple },
    AvanteTaskCompleted = { fg = colors.green },
    AvanteTaskFailed = { fg = colors.red },

    -- Special text states
    AvanteThinking = { fg = colors.purple },
    AvanteInlineHint = { link = "Keyword" },
    AvanteSuggestion = { link = "Comment" },
    AvanteAnnotation = { link = "Comment" },

    -- Confirmation dialogs
    AvanteConfirmTitle = { fg = colors.background_950, bg = colors.red },

    -- Diff and change indicators
    AvanteToBeDeleted = { strikethrough = true, bg = utils.opaque(colors.red, 0.20) },
    AvanteToBeDeletedWOStrikethrough = { bg = utils.opaque(colors.red, 0.15) },

    -- Conflict resolution
    AvanteConflictCurrent = { bold = true, bg = utils.opaque(colors.red, 0.15) },
    AvanteConflictCurrentLabel = { bg = utils.opaque(colors.red, 0.25) },
    AvanteConflictIncoming = { bold = true, bg = utils.opaque(colors.blue, 0.15) },
    AvanteConflictIncomingLabel = { bg = utils.opaque(colors.blue, 0.25) },
  }
end

return M
