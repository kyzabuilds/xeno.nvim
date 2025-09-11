local M = {}
local utils = require("xeno.core.utils")
local helpers = require("xeno.core.helpers")

M["nvim-telescope/telescope.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.base_800,
    fg = colors.base_300,
    border = colors.base_700,
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
    TelescopePromptCounter = { fg = colors.base_500 },
    TelescopeSelection = { bg = utils.opaque(colors.base_500, 0.30, nil, colors) },
    TelescopeSelectionCaret = { bg = utils.opaque(colors.base_500, 0.30, nil, colors), fg = colors.accent_500 },
  }
end

M["ibhagwan/fzf-lua"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.base_800,
    fg = colors.base_200,
    border = colors.base_200,
    prompt_fg = colors.accent_200,
    pointer_fg = colors.accent_200,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
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
    FzfLuaSearch = { bg = colors.base_800, fg = colors.base_200 },
    FzfLuaBufFlagCurl = { bg = colors.base_800, fg = colors.base_200 },

    -- Scroll Elements
    FzfLuaScrollBorderEmpty = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaScrollBorderFull = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaScrollFloatEmpty = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaScrollFloatFull = { bg = colors.base_700, fg = colors.base_200 },

    -- Help Elements
    FzfLuaHelpNormal = { bg = colors.base_700, fg = colors.base_200 },
    FzfLuaHelpBorder = { bg = colors.base_700, fg = colors.base_200 },
  }
end

M["hrsh7th/nvim-cmp"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    match_fg = colors.accent_200,
    kind_fg = colors.base_200,
    menu_fg = colors.base_300,
    item_fg = colors.base_200,
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
    CmpItemAbbrDeprecated = { fg = colors.base_300, strikethrough = true },
  }
end

M["Saghen/blink.cmp"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    label_fg = colors.base_300,
    match_fg = colors.base_300,
    kind_fg = colors.base_500,
    source_fg = colors.base_500,
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
    BlinkCmpScrollBarGutter = { bg = colors.base_800 },

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
    BlinkCmpKindField = { fg = colors.base_500 },
    BlinkCmpKindVariable = { fg = colors.base_500 },
    BlinkCmpKindClass = { fg = colors.base_500 },
    BlinkCmpKindInterface = { fg = colors.base_500 },
    BlinkCmpKindModule = { fg = colors.base_500 },
    BlinkCmpKindProperty = { fg = colors.base_500 },
    BlinkCmpKindUnit = { fg = colors.base_500 },
    BlinkCmpKindValue = { fg = colors.base_500 },
    BlinkCmpKindEnum = { fg = colors.base_500 },
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
    text_fg = colors.base_300,
    separator_fg = colors.base_300,
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
    NavicIconsProperty = { fg = colors.base_200 },
    NavicIconsField = { fg = colors.base_200 },
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
    bg = colors.base_700,
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
    scope_fg = utils.opaque(colors.base_500, 0.70, nil, colors),
    indent_fg = utils.opaque(colors.base_500, 0.30, nil, colors),
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
    line_fg = utils.opaque(colors.base_500, 0.30, nil, colors),
    current_fg = utils.opaque(colors.base_500, 0.70, nil, colors),
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
    bg = colors.base_800,
    fg = colors.base_200,
    root_fg = colors.accent_500,
    directory_fg = colors.base_200,
    git_add_fg = colors.green,
    git_modified_fg = colors.yellow,
    git_deleted_fg = colors.red,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  local neotree = { bg = config.bg, fg = config.fg }

  return {
    -- Root and Basic Elements
    NeoTreeRootName = { fg = config.root_fg, bold = true, italic = true, underline = true },
    NeoTreeNormal = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeNormalNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeEndOfBuffer = { bg = neotree.bg },

    -- Status Line
    NeoTreeStatusLine = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeStatusLineNC = { bg = neotree.bg, fg = neotree.fg },
    NeoTreeWinSeparator = { bg = neotree.bg, fg = colors.base_700 },

    -- Tabs
    NeoTreeTabActive = { bg = colors.base_700, bold = true },
    NeoTreeTabInactive = { bg = colors.base_800, fg = colors.base_300 },
    NeoTreeTabSeparatorActive = { fg = colors.base_300, bg = colors.base_700 },
    NeoTreeTabSeparatorInactive = { fg = colors.base_700, bg = colors.base_800 },

    -- Selection and Navigation
    NeoTreeCursorLine = { bg = utils.opaque(colors.base_500, 0.15, nil, colors) },
    NeoTreeIndentMarker = { fg = utils.opaque(colors.base_500, 0.40, nil, colors), nocombine = true },

    -- File System Elements
    NeoTreeDirectoryName = { fg = config.directory_fg },
    NeoTreeDirectoryIcon = { fg = colors.base_300 },
    NeoTreeDotFile = { fg = colors.base_500 },
    NeoTreeMessage = { fg = colors.base_300 },

    -- Git Status Colors
    NeoTreeGitAdded = { fg = config.git_add_fg },
    NeoTreeGitModified = { fg = config.git_modified_fg },
    NeoTreeGitDeleted = { fg = config.git_deleted_fg },
  }
end

M["nvim-tree/nvim-tree.lua"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    bg = colors.base_800,
    fg = colors.base_200,
    root_fg = colors.accent_500,
    folder_fg = colors.base_200,
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
    NvimTreeNormalFloatBorder = { bg = nvimtree.bg, fg = colors.base_700 },
    NvimTreeEndOfBuffer = { bg = nvimtree.bg },
    NvimTreePopup = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeSignColumn = { bg = nvimtree.bg, fg = nvimtree.fg },

    -- Status Line
    NvimTreeStatusLine = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeStatusLineNC = { bg = nvimtree.bg, fg = nvimtree.fg },
    NvimTreeWinSeparator = { bg = nvimtree.bg, fg = colors.base_700 },
    NvimTreeLineNr = { bg = nvimtree.bg, fg = colors.base_500 },
    NvimTreeCursorLineNr = { bg = nvimtree.bg, fg = colors.base_300 },

    -- Selection and Navigation
    NvimTreeCursorLine = { bg = utils.opaque(colors.base_500, 0.15, nil, colors) },
    NvimTreeCursorColumn = { bg = utils.opaque(colors.base_500, 0.15, nil, colors) },
    NvimTreeIndentMarker = { fg = utils.opaque(colors.base_500, 0.40, nil, colors), nocombine = true },

    -- Folder Elements
    NvimTreeFolderName = { fg = config.folder_fg },
    NvimTreeEmptyFolderName = { fg = colors.base_300 },
    NvimTreeOpenedFolderName = { fg = config.folder_fg, bold = true },
    NvimTreeSymlinkFolderName = { fg = colors.base_300, italic = true },
    NvimTreeFolderIcon = { fg = colors.base_300 },
    NvimTreeOpenedFolderIcon = { fg = colors.base_300 },
    NvimTreeClosedFolderIcon = { fg = colors.base_300 },
    NvimTreeFolderArrowOpen = { fg = colors.base_300 },
    NvimTreeFolderArrowClosed = { fg = colors.base_300 },

    -- File Elements
    NvimTreeFileIcon = { fg = colors.base_200 },
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
    NvimTreeGitIgnored = { fg = colors.base_500 },

    -- Git Icons
    NvimTreeGitDirtyIcon = { fg = colors.yellow },
    NvimTreeGitStagedIcon = { fg = colors.green },
    NvimTreeGitMergeIcon = { fg = colors.orange },
    NvimTreeGitRenamedIcon = { fg = colors.purple },
    NvimTreeGitNewIcon = { fg = colors.green },
    NvimTreeGitDeletedIcon = { fg = colors.red },
    NvimTreeGitIgnoredIcon = { fg = colors.base_500 },

    -- Git File Highlights
    NvimTreeGitFileDirtyHL = { fg = colors.yellow },
    NvimTreeGitFileStagedHL = { fg = colors.green },
    NvimTreeGitFileMergeHL = { fg = colors.orange },
    NvimTreeGitFileRenamedHL = { fg = colors.purple },
    NvimTreeGitFileNewHL = { fg = colors.green },
    NvimTreeGitFileDeletedHL = { fg = colors.red },
    NvimTreeGitFileIgnoredHL = { fg = colors.base_500 },

    -- Git Folder Highlights
    NvimTreeGitFolderDirtyHL = { fg = colors.yellow },
    NvimTreeGitFolderStagedHL = { fg = colors.green },
    NvimTreeGitFolderMergeHL = { fg = colors.orange },
    NvimTreeGitFolderRenamedHL = { fg = colors.purple },
    NvimTreeGitFolderNewHL = { fg = colors.green },
    NvimTreeGitFolderDeletedHL = { fg = colors.red },
    NvimTreeGitFolderIgnoredHL = { fg = colors.base_500 },

    -- File/Folder Status
    NvimTreeFileStaged = { fg = colors.green },
    NvimTreeFileRenamed = { fg = colors.purple },
    NvimTreeFileNew = { fg = colors.green },
    NvimTreeFileMerge = { fg = colors.orange },
    NvimTreeFileIgnored = { fg = colors.base_500 },
    NvimTreeFileDirty = { fg = colors.yellow },
    NvimTreeFileDeleted = { fg = colors.red },
    NvimTreeFolderStaged = { fg = colors.green },
    NvimTreeFolderRenamed = { fg = colors.purple },
    NvimTreeFolderNew = { fg = colors.green },
    NvimTreeFolderMerge = { fg = colors.orange },
    NvimTreeFolderIgnored = { fg = colors.base_500 },
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
    NvimTreeHiddenIcon = { fg = colors.base_500 },
    NvimTreeHiddenFileHL = { fg = colors.base_500 },
    NvimTreeHiddenFolderHL = { fg = colors.base_500 },
    NvimTreeHiddenDisplay = { fg = colors.base_500 },

    -- Window Picker
    NvimTreeWindowPicker = { fg = colors.base_950, bg = colors.accent_500, bold = true },
  }
end

M["lewis6991/gitsigns.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    add_fg = utils.opaque(colors.green, 0.60, nil, colors),
    change_fg = utils.opaque(colors.yellow, 0.60, nil, colors),
    delete_fg = utils.opaque(colors.red, 0.60, nil, colors),
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
    GitSignsUntracked = { fg = utils.opaque(colors.green, 0.60, nil, colors) },

    -- Number line highlights
    GitSignsAddNr = { fg = utils.opaque(colors.green, 0.60, nil, colors) },
    GitSignsChangeNr = { fg = utils.opaque(colors.yellow, 0.60, nil, colors) },
    GitSignsDeleteNr = { fg = utils.opaque(colors.red, 0.60, nil, colors) },
    GitSignsChangedeleteNr = { fg = utils.opaque(colors.yellow, 0.60, nil, colors) },
    GitSignsTopdeleteNr = { fg = utils.opaque(colors.red, 0.60, nil, colors) },
    GitSignsUntrackedNr = { fg = utils.opaque(colors.green, 0.60, nil, colors) },

    -- Line highlights
    GitSignsAddLn = { bg = utils.opaque(colors.green, 0.15, nil, colors) },
    GitSignsChangeLn = { bg = utils.opaque(colors.yellow, 0.15, nil, colors) },
    GitSignsDeleteLn = { bg = utils.opaque(colors.red, 0.15, nil, colors) },
    GitSignsChangedeleteLn = { bg = utils.opaque(colors.yellow, 0.15, nil, colors) },
    GitSignsTopdeleteLn = { bg = utils.opaque(colors.red, 0.15, nil, colors) },
    GitSignsUntrackedLn = { bg = utils.opaque(colors.green, 0.15, nil, colors) },

    -- Current line highlights
    GitSignsAddCul = { fg = utils.opaque(colors.green, 0.60, nil, colors) },
    GitSignsChangeCul = { fg = utils.opaque(colors.yellow, 0.60, nil, colors) },
    GitSignsDeleteCul = { fg = utils.opaque(colors.red, 0.60, nil, colors) },
    GitSignsChangedeleteCul = { fg = utils.opaque(colors.yellow, 0.60, nil, colors) },
    GitSignsTopdeleteCul = { fg = utils.opaque(colors.red, 0.60, nil, colors) },
    GitSignsUntrackedCul = { fg = utils.opaque(colors.green, 0.60, nil, colors) },

    -- Staged highlights
    GitSignsStagedAdd = { fg = utils.opaque(colors.green, 0.40, nil, colors) },
    GitSignsStagedChange = { fg = utils.opaque(colors.yellow, 0.40, nil, colors) },
    GitSignsStagedDelete = { fg = utils.opaque(colors.red, 0.40, nil, colors) },
    GitSignsStagedChangedelete = { fg = utils.opaque(colors.yellow, 0.40, nil, colors) },
    GitSignsStagedTopdelete = { fg = utils.opaque(colors.red, 0.40, nil, colors) },
    GitSignsStagedUntracked = { fg = utils.opaque(colors.green, 0.40, nil, colors) },

    -- Staged number line highlights
    GitSignsStagedAddNr = { fg = utils.opaque(colors.green, 0.40, nil, colors) },
    GitSignsStagedChangeNr = { fg = utils.opaque(colors.yellow, 0.40, nil, colors) },
    GitSignsStagedDeleteNr = { fg = utils.opaque(colors.red, 0.40, nil, colors) },
    GitSignsStagedChangedeleteNr = { fg = utils.opaque(colors.yellow, 0.40, nil, colors) },
    GitSignsStagedTopdeleteNr = { fg = utils.opaque(colors.red, 0.40, nil, colors) },
    GitSignsStagedUntrackedNr = { fg = utils.opaque(colors.green, 0.40, nil, colors) },

    -- Staged line highlights
    GitSignsStagedAddLn = { fg = utils.opaque(colors.green, 0.50, nil, colors), bg = utils.opaque(colors.green, 0.10, nil, colors) },
    GitSignsStagedChangeLn = { fg = utils.opaque(colors.yellow, 0.50, nil, colors), bg = utils.opaque(colors.yellow, 0.10, nil, colors) },
    GitSignsStagedChangedeleteLn = {
      fg = utils.opaque(colors.yellow, 0.50, nil, colors),
      bg = utils.opaque(colors.yellow, 0.10, nil, colors),
    },
    GitSignsStagedUntrackedLn = { fg = utils.opaque(colors.green, 0.50, nil, colors), bg = utils.opaque(colors.green, 0.10, nil, colors) },

    -- Staged current line highlights
    GitSignsStagedAddCul = { fg = utils.opaque(colors.green, 0.40, nil, colors) },
    GitSignsStagedChangeCul = { fg = utils.opaque(colors.yellow, 0.40, nil, colors) },
    GitSignsStagedDeleteCul = { fg = utils.opaque(colors.red, 0.40, nil, colors) },
    GitSignsStagedChangedeleteCul = { fg = utils.opaque(colors.yellow, 0.40, nil, colors) },
    GitSignsStagedTopdeleteCul = { fg = utils.opaque(colors.red, 0.40, nil, colors) },
    GitSignsStagedUntrackedCul = { fg = utils.opaque(colors.green, 0.40, nil, colors) },

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
    GitSignsCurrentLineBlame = { fg = utils.opaque(colors.base_300, 0.60, nil, colors), italic = true },
  }
end

M["akinsho/bufferline.nvim"] = function(colors, plugin_config)
  local is_light = utils.get_variant() == 2

  local function palette()
    if is_light then
      return {
        fill_bg = colors.base_700,
        fill_fg = colors.base_500,
        visible_bg = colors.base_900,
        visible_fg = colors.base_500,
        selected_bg = colors.base_900,
        selected_fg = colors.base_400,
        separator = colors.base_400,
      }
    else
      return {
        fill_bg = colors.base_950,
        fill_fg = colors.base_300,
        visible_bg = colors.base_900,
        visible_fg = colors.base_300,
        selected_bg = colors.base_800,
        selected_fg = colors.base_100,
        separator = colors.base_800,
      }
    end
  end

  local default_palette = palette()

  -- Default configuration using the palette
  local config = {
    selected_bg = default_palette.selected_bg,
    visible_bg = default_palette.visible_bg,
    separator = default_palette.separator,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  local bufferline = {
    fill_bg = default_palette.fill_bg,
    fill_fg = default_palette.fill_fg,
    visible_bg = config.visible_bg,
    visible_fg = default_palette.visible_fg,
    selected_bg = config.selected_bg,
    selected_fg = default_palette.selected_fg,
    separator = config.separator,
  }

  local buffer_visible = { fg = bufferline.visible_fg, bg = bufferline.visible_bg }
  local buffer_selected = { fg = bufferline.selected_fg, bg = bufferline.selected_bg, bold = true, sp = colors.accent_400 }
  local diagnostic_colors = { Hint = colors.blue, Info = colors.purple, Warning = colors.yellow, Error = colors.red }

  local highlights = {
    -- General/Default
    Defaults = helpers.with_borders({ sp = colors.base_700 }, config),

    -- Fill & Separators
    BufferLineFill = { fg = bufferline.fill_fg, bg = bufferline.fill_bg },
    BufferLineSeparator = { fg = bufferline.separator, bg = bufferline.fill_bg },
    BufferLineTabSeparator = { fg = bufferline.separator, bg = bufferline.visible_bg },
    BufferLineOffsetSeparator = { fg = colors.base_600, bg = bufferline.visible_bg },
    BufferLineGroupSeparator = { fg = colors.base_300, bg = bufferline.visible_bg },
    BufferLineGroupLabel = { fg = bufferline.visible_bg, bg = colors.base_300 },

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
    BufferLineModifiedVisible = { fg = colors.base_100, bg = colors.base_900 },
    BufferLineSeparatorVisible = { fg = colors.base_200, bg = bufferline.visible_bg },
    BufferLineIndicatorVisible = { fg = colors.base_600, bg = bufferline.visible_bg },

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
    BufferLineSeparatorSelected = { fg = colors.base_300, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineTabSeparatorSelected = { fg = colors.base_600, bg = bufferline.selected_bg, sp = colors.accent_400 },
    BufferLineDuplicateSelected = { fg = colors.base_300, bg = bufferline.selected_bg, sp = colors.accent_400 },

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
    bg = colors.base_800,
    fg = colors.base_200,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    TroubleNormal = { bg = config.bg, fg = config.fg },
    TroubleFile = { bg = config.bg, fg = config.fg },
    TroubleSignOther = { bg = config.bg, fg = config.fg },
    TroubleInformation = { bg = config.bg, fg = config.fg },
  }
end

M["NeogitOrg/neogit"] = function(colors, config)
  local neogit = {
    bg = colors.base_900,
    fg = colors.base_200,
    header_bg = colors.base_700,
    section_fg = colors.green,
    accent_fg = colors.accent_200,
    subtle_fg = colors.base_400,
  }

  return {
    -- Base UI Elements
    NeogitActiveItem = { bg = colors.base_800, bold = true },
    NeogitCursorLine = { link = "CursorLine" },
    NeogitCursorLineNr = { link = "CursorLineNr" },
    NeogitNormal = { link = "Normal" },
    NeogitFold = { clear = true },

    -- Float/Header Components
    NeogitFloatHeader = { bold = true, bg = colors.base_950 },
    NeogitFloatHeaderHighlight = { bold = true, fg = colors.base_300, bg = colors.base_800 },

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
    NeogitChangeAdded = { fg = utils.opaque(colors.green, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeModified = { fg = utils.opaque(colors.green, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeDeleted = { fg = utils.opaque(colors.red, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeRenamed = { fg = utils.opaque(colors.green, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeUpdated = { fg = utils.opaque(neogit.subtle_fg, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeCopied = { fg = utils.opaque(colors.base_300, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeUnmerged = { fg = utils.opaque(colors.base_200, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeNewFile = { fg = utils.opaque(colors.green, 0.7, nil, colors), bold = true, italic = true },
    NeogitChangeUntrackedstaged = { clear = true },
    NeogitChangeUntrackedunstaged = { clear = true },
    NeogitChangeUntrackeduntracked = { clear = true },

    -- Diff Additions
    NeogitDiffAdd = { fg = colors.green, bg = utils.opaque(colors.green, 0.15, nil, colors) },
    NeogitDiffAddHighlight = { fg = colors.green, bg = utils.opaque(colors.green, 0.15, nil, colors) },
    NeogitDiffAddCursor = { fg = colors.green, bg = utils.opaque(colors.green, 0.20, nil, colors) },
    NeogitDiffAdditions = { fg = colors.green },

    -- Diff Deletions
    NeogitDiffDelete = { fg = colors.red, bg = utils.opaque(colors.red, 0.15, nil, colors) },
    NeogitDiffDeleteHighlight = { fg = colors.red, bg = utils.opaque(colors.red, 0.15, nil, colors) },
    NeogitDiffDeleteCursor = { fg = colors.red, bg = utils.opaque(colors.red, 0.20, nil, colors) },
    NeogitDiffDeletions = { fg = colors.red },

    -- Diff Context
    NeogitDiffContext = { bg = colors.base_900 },
    NeogitDiffContextHighlight = { bg = colors.base_900 },
    NeogitDiffContextCursor = { bg = colors.base_800 },

    -- Diff Headers
    NeogitDiffHeader = helpers.with_borders({ fg = neogit.fg, bg = colors.base_900, sp = colors.base_700 }, config),
    NeogitDiffHeaderHighlight = helpers.with_borders(
      { bg = colors.base_800, fg = colors.base_200, sp = colors.base_700, bold = true },
      config
    ),
    NeogitDiffHeaderCursor = helpers.with_borders({ bg = colors.base_800, sp = colors.base_700, bold = true }, config),

    -- Hunk Headers
    NeogitHunkHeader = helpers.with_borders({ bg = colors.base_800, fg = colors.base_300, sp = colors.base_700, bold = true }, config),
    NeogitHunkHeaderHighlight = helpers.with_borders(
      { bg = colors.base_800, fg = colors.base_300, sp = colors.base_700, bold = true },
      config
    ),
    NeogitHunkHeaderCursor = helpers.with_borders(
      { bg = colors.base_800, fg = colors.base_200, sp = colors.base_700, bold = true },
      config
    ),

    -- Merge Headers
    NeogitHunkMergeHeader = { bold = true, fg = colors.base_200, bg = colors.base_900 },
    NeogitHunkMergeHeaderHighlight = { bold = true, fg = colors.base_950 },
    NeogitHunkMergeHeaderCursor = { bold = true, fg = colors.base_950, bg = colors.base_300 },

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
    NeogitTagDistance = { fg = colors.base_300 },

    -- File and Commit Elements
    NeogitFilePath = { italic = true, fg = neogit.base_500 },
    NeogitCommitViewHeader = { fg = colors.base_500 },
    NeogitCommitViewDescription = { fg = neogit.subtle_fg },
    NeogitStatusHEAD = { clear = true },

    -- Graph Colors (Regular)
    NeogitGraphWhite = { fg = colors.base_50 },
    NeogitGraphRed = { fg = colors.red },
    NeogitGraphGreen = { fg = neogit.accent_fg },
    NeogitGraphYellow = { fg = neogit.accent_fg },
    NeogitGraphBlue = { fg = neogit.accent_fg },
    NeogitGraphPurple = { fg = neogit.accent_fg },
    NeogitGraphCyan = { fg = colors.base_300 },
    NeogitGraphOrange = { fg = colors.base_300 },
    NeogitGraphGray = { fg = colors.base_200 },
    NeogitGraphAuthor = { fg = colors.base_300 },

    -- Graph Colors (Bold)
    NeogitGraphBoldWhite = { bold = true, fg = colors.base_50 },
    NeogitGraphBoldRed = { bold = true, fg = colors.red },
    NeogitGraphBoldGreen = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldYellow = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldBlue = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldPurple = { bold = true, fg = neogit.accent_fg },
    NeogitGraphBoldCyan = { bold = true, fg = colors.base_300 },
    NeogitGraphBoldOrange = { bold = true, fg = colors.base_300 },
    NeogitGraphBoldGray = { bold = true, fg = colors.base_200 },
  }
end

M["MeanderingProgrammer/render-markdown.nvim"] = function(colors, plugin_config)
  -- Default configuration
  local config = {
    heading_fg = colors.base_200,
    code_bg = colors.base_800,
    inline_code_fg = colors.accent_500,
    inline_code_bg = colors.base_950,
    table_fg = colors.base_200,
    quote_fg = colors.base_400,
    link_fg = colors.base_300,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    -- Headers
    RenderMarkdownH1 = { fg = config.heading_fg, bold = true },
    RenderMarkdownH2 = { fg = config.heading_fg, bold = true },
    RenderMarkdownH3 = { fg = colors.base_300, bold = true },
    RenderMarkdownH4 = { fg = config.heading_fg, bold = true },
    RenderMarkdownH5 = { fg = colors.base_100, bold = true },
    RenderMarkdownH6 = { fg = colors.base_500, bold = true },

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
    RenderMarkdownCodeBorder = { bg = colors.base_700 },
    RenderMarkdownCodeFallback = { fg = colors.base_500, bg = colors.base_900 },

    -- Table Elements
    RenderMarkdownTableHead = { fg = config.table_fg, bold = true },
    RenderMarkdownTableRow = { fg = colors.base_300, bg = colors.base_900 },
    RenderMarkdownTableFill = { fg = colors.base_600 },

    -- Status/Alert Elements
    RenderMarkdownSuccess = { fg = colors.green },
    RenderMarkdownInfo = { fg = colors.base_100 },
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
    RenderMarkdownUnchecked = { fg = colors.base_500 },
    RenderMarkdownTodo = { fg = colors.accent_500 },

    -- Special Elements
    RenderMarkdownMath = { fg = colors.accent_500 },
    RenderMarkdownInlineHighlight = { fg = colors.accent_500, bg = colors.base_950 },
    RenderMarkdownBullet = { fg = colors.base_500 },

    -- Structural Elements
    RenderMarkdownIndent = { fg = colors.base_700 },
    RenderMarkdownSign = { fg = colors.base_500 },
    RenderMarkdownDash = { fg = colors.base_500 },

    -- Miscellaneous
    RenderMarkdownHtmlComment = { fg = colors.base_500, italic = true },
  }
end

M["sindrets/diffview.nvim"] = function(colors, plugin_config)
  return {
    -- Primary UI elements
    DiffviewPrimary = { fg = colors.base_200 },
    DiffviewSecondary = { fg = colors.accent_300 },
    DiffviewDim1 = { fg = colors.base_600 },

    -- File panel highlights
    DiffviewFilePanelTitle = { bg = colors.base_800, fg = colors.accent_400, bold = true },
    DiffviewFilePanelCounter = { bg = colors.base_800, fg = colors.base_400, bold = true },
    DiffviewFilePanelFileName = { fg = colors.base_300 },
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
    DiffviewDiffAdd = { fg = "none", bg = utils.opaque(colors.green, 0.15, nil, colors) },
    DiffviewDiffChange = { fg = "none", bg = utils.opaque(colors.yellow, 0.15, nil, colors) },
    DiffviewDiffText = { fg = "none", bg = utils.opaque(colors.yellow, 0.20, nil, colors) },
    DiffviewDiffDelete = { fg = colors.base_900, bg = utils.opaque(colors.red, 0.20, nil, colors) },
    DiffviewDiffAddAsDelete = { fg = colors.red, bg = utils.opaque(colors.red, 0.20, nil, colors) },
    DiffviewDiffDeleteDim = { link = "Comment" },

    -- Window and UI elements
    DiffviewNormal = { bg = colors.base_800 },
    DiffviewCursorLine = { link = "CursorLine" },
    DiffviewSignColumn = { link = "Normal" },
    DiffviewStatusLine = { link = "StatusLine" },
    DiffviewStatusLineNC = { link = "StatusLineNC" },
    DiffviewWinSeparator = { bg = colors.base_800, fg = colors.base_700 },
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
    fg = colors.base_200,
    bg = colors.base_800,
    hover_bg = utils.opaque(colors.base_500, 0.30, nil, colors),
    separator_fg = colors.base_500,
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
    DropBarMenuCurrentContext = { bg = colors.base_700, fg = config.fg },
    DropBarMenuNormalFloat = { bg = config.bg, fg = config.fg },
    DropBarMenuFloatBorder = { bg = config.bg, fg = colors.base_700 },
    DropBarMenuHoverEntry = { bg = colors.base_700, fg = config.fg },
    DropBarMenuHoverSymbol = { bold = true },
    DropBarMenuHoverIcon = { reverse = true },

    -- Icons
    DropBarIconKindDefault = { fg = colors.base_200 },
    DropBarIconKindFile = { fg = colors.base_200 },
    DropBarIconKindFolder = { fg = colors.base_200 },
    DropBarIconKindList = { fg = colors.base_200 },
    DropBarIconKindArray = { fg = colors.base_200 },
    DropBarIconKindFunction = { fg = colors.base_200 },
    DropBarIconKindMethod = { fg = colors.base_200 },
    DropBarIconKindClass = { fg = colors.base_200 },
    DropBarIconKindModule = { fg = colors.base_200 },
    DropBarIconKindNamespace = { fg = colors.base_200 },
    DropBarIconKindConstant = { fg = colors.base_200 },
    DropBarIconKindVariable = { fg = colors.base_200 },

    -- UI separators
    DropBarIconUIIndicator = { fg = config.icon_fg },
    DropBarIconUISeparator = { fg = config.separator_fg },
    DropBarIconUIPickPivot = { fg = config.icon_fg },
    DropBarFzfMatch = { fg = config.icon_fg },
  }
end

M["DNLHC/glance.nvim"] = function(colors, config)
  return {
    -- Main window elements
    GlanceNone = { clear = true },
    GlanceWinBarTitle = helpers.with_borders({ fg = colors.base_200, bg = colors.base_800, sp = colors.base_700 }, config),
    GlanceWinBarFilepath = helpers.with_borders({ fg = colors.base_400, bg = colors.base_800, sp = colors.base_700 }, config),
    GlanceWinBarFilename = helpers.with_borders({ fg = colors.base_200, bg = colors.base_800, sp = colors.base_700 }, config),

    -- List panel
    GlanceListNormal = { fg = colors.base_200, bg = colors.base_800 },
    GlanceListCursorLine = { bg = utils.opaque(colors.base_500, 0.10, nil, colors) },
    GlanceListFilepath = { fg = colors.base_500 },
    GlanceListFilename = { link = "Directory" },
    GlanceListCount = { link = "Number" },
    GlanceListMatch = { link = "Search" },
    GlanceListEndOfBuffer = { fg = colors.base_800, bg = colors.base_800 },
    GlanceListBorderBottom = { fg = colors.base_600, bg = colors.base_800 },

    -- Preview panel
    GlancePreviewNormal = { bg = colors.base_800 },
    GlancePreviewCursorLine = { bg = utils.opaque(colors.base_500, 0.10, nil, colors) },
    GlancePreviewMatch = { bg = colors.base_700 },
    GlancePreviewSignColumn = { fg = colors.base_800 },
    GlancePreviewLineNr = { fg = colors.base_500 },
    GlancePreviewEndOfBuffer = { fg = colors.base_800, bg = colors.base_800 },
    GlancePreviewBorderBottom = { fg = colors.base_600, bg = colors.base_800 },

    -- Borders and separators
    GlanceBorderTop = { fg = colors.base_600, bg = colors.base_800 },
    GlanceIndent = { fg = utils.opaque(colors.base_500, 0.20, nil, colors) },
    GlanceFoldIcon = { fg = colors.base_500 },
  }
end

M["MagicDuck/grug-far.nvim"] = function(colors, plugin_config)
  return {
    -- Main window and background
    GrugFarNormal = { fg = colors.base_200 },
    GrugFarWinSeparator = { fg = colors.base_700 },
    GrugFarEndOfBuffer = { fg = colors.base_800 },

    -- Change indicators with enhanced visibility
    GrugFarResultsChangeIndicator = { fg = colors.yellow, bold = true },
    GrugFarResultsAddIndicator = { fg = colors.green, bold = true },
    GrugFarResultsRemoveIndicator = { fg = colors.red, bold = true },

    -- Line numbers with proper base colors
    GrugFarResultsLineNr = { fg = colors.base_500 },
    GrugFarResultsNumbersSeparator = { fg = colors.base_600 },
    GrugFarResultsColumnNr = { fg = colors.base_500 },
    GrugFarResultsCursorLineNo = { fg = colors.base_500, bold = true },

    -- File paths with enhanced styling
    GrugFarResultsPath = { fg = colors.base_500 },
    GrugFarResultsPathIcon = { fg = colors.accent_500 },

    -- Match highlighting with base colors
    GrugFarResultsMatch = { bg = utils.opaque(colors.base_500, 0.25, nil, colors), bold = true },
    GrugFarResultsMatchRemoved = { bg = utils.opaque(colors.red, 0.30, nil, colors), bold = true },
    GrugFarResultsMatchAdded = { bg = utils.opaque(colors.green, 0.30, nil, colors), bold = true },

    -- Context lines
    GrugFarResultsLine = { fg = colors.base_500 },
    GrugFarResultsLineContext = { fg = colors.base_400 },

    -- Headers with enhanced visibility
    GrugFarResultsHeader = { fg = colors.base_300 },
    GrugFarResultsCmdHeader = { fg = colors.base_400, bold = true, underline = true },

    -- UI messages and stats with base colors
    GrugFarResultsActionMessage = { fg = colors.base_300, bold = true },
    GrugFarResultsStats = { fg = colors.base_400, italic = true },
    GrugFarResultsStatsSuccess = { fg = colors.green, bold = true },
    GrugFarResultsStatsError = { fg = colors.red, bold = true },

    -- Input elements with proper theming
    GrugFarInputPlaceholder = { blend = 100, fg = colors.base_500 },
    GrugFarInputLabel = { fg = colors.base_400, bold = true },
    GrugFarInputText = { fg = colors.base_200 },
    GrugFarInputBorder = { fg = colors.base_600 },

    -- Help window elements with consistent theming
    GrugFarHelpWinNormal = { fg = colors.base_200 },
    GrugFarHelpWinBorder = { fg = colors.base_500 },
    GrugFarHelpWinActionDescription = { fg = colors.base_300 },
    GrugFarHelpWinActionKey = { fg = colors.base_400, bold = true },
    GrugFarHelpWinActionText = { fg = colors.base_200 },
    GrugFarHelpWinActionPrefix = { fg = colors.base_300, bold = true },
    GrugFarHelpWinHeader = { fg = colors.base_300, bold = true, underline = true },
    GrugFarHelpHeaderKey = { fg = colors.base_400, bold = true },
    GrugFarHelpHeader = { fg = colors.base_300, bold = true },

    -- Selection and cursor highlights
    GrugFarCursorLine = { bg = utils.opaque(colors.base_500, 0.30, nil, colors) },
    GrugFarSelection = { bg = utils.opaque(colors.accent_500, 0.20, nil, colors) },

    -- Search progress and status
    GrugFarProgressBar = { bg = colors.accent_500 },
    GrugFarProgressBg = { bg = colors.base_700 },

    -- Miscellaneous elements with base colors
    GrugFarResultsLongLineStr = { fg = colors.base_500, italic = true },
    GrugFarResultsNumberLabel = { fg = colors.base_500, bold = true },
    GrugFarVisualBufrange = { bg = utils.opaque(colors.accent_500, 0.25, nil, colors) },
    GrugFarResultsDiffSeparatorIndicator = { fg = colors.base_600 },

    -- Folding
    GrugFarFold = { fg = colors.base_500 },
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
    MarkviewPalette0 = { fg = colors.base_500, bg = colors.base_800 },
    MarkviewPalette0Fg = { fg = colors.base_500 },
    MarkviewPalette0Bg = { bg = colors.base_800 },
    MarkviewPalette0Sign = { fg = colors.base_500 },

    MarkviewPalette1 = { fg = colors.base_200, bg = colors.base_800 },
    MarkviewPalette1Fg = { fg = colors.base_200 },
    MarkviewPalette1Bg = { bg = colors.base_800 },
    MarkviewPalette1Sign = { fg = colors.base_200 },

    MarkviewPalette2 = { fg = colors.base_200, bg = colors.base_800 },
    MarkviewPalette2Fg = { fg = colors.base_200 },
    MarkviewPalette2Bg = { bg = colors.base_800 },
    MarkviewPalette2Sign = { fg = colors.base_200 },

    MarkviewPalette3 = { fg = colors.base_200, bg = colors.base_800 },
    MarkviewPalette3Fg = { fg = colors.base_200 },
    MarkviewPalette3Bg = { bg = colors.base_800 },
    MarkviewPalette3Sign = { fg = colors.base_200 },

    MarkviewPalette4 = { fg = colors.base_200, bg = colors.base_800 },
    MarkviewPalette4Fg = { fg = colors.base_200 },
    MarkviewPalette4Bg = { bg = colors.base_800 },
    MarkviewPalette4Sign = { fg = colors.base_200 },

    MarkviewPalette5 = { fg = colors.base_200, bg = colors.base_800 },
    MarkviewPalette5Fg = { fg = colors.base_200 },
    MarkviewPalette5Bg = { bg = colors.base_800 },
    MarkviewPalette5Sign = { fg = colors.base_200 },

    MarkviewPalette6 = { fg = colors.base_200, bg = colors.base_800 },
    MarkviewPalette6Fg = { fg = colors.base_200 },
    MarkviewPalette6Bg = { bg = colors.base_800 },
    MarkviewPalette6Sign = { fg = colors.base_200 },

    MarkviewPalette7 = { fg = colors.green, bg = colors.base_800 },
    MarkviewPalette7Fg = { fg = colors.green },
    MarkviewPalette7Bg = { bg = colors.base_800 },
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
    MarkviewCheckboxStriked = { fg = colors.base_500, strikethrough = true },
    MarkviewCheckboxUnchecked = { link = "MarkviewPalette1Fg" },

    -- Code blocks using base colors
    MarkviewCode = { bg = colors.base_800 },
    MarkviewCodeFg = { fg = colors.base_900 },
    MarkviewCodeInfo = { bg = colors.base_800, fg = colors.base_500 },

    -- Links
    MarkviewEmail = { link = "@markup.link.url.markdown_inline" },
    MarkviewHyperlink = { link = "@markup.link.label.markdown_inline" },
    MarkviewImage = { link = "@markup.link.label.markdown_inline" },

    -- Gradient colors (progressive gray scale)
    MarkviewGradient0 = { fg = colors.base_900 },
    MarkviewGradient1 = { fg = colors.base_800 },
    MarkviewGradient2 = { fg = colors.base_700 },
    MarkviewGradient3 = { fg = colors.base_600 },
    MarkviewGradient4 = { fg = colors.base_500 },
    MarkviewGradient5 = { fg = colors.base_400 },
    MarkviewGradient6 = { fg = colors.base_300 },
    MarkviewGradient7 = { fg = colors.base_200 },
    MarkviewGradient8 = { fg = colors.base_100 },
    MarkviewGradient9 = { fg = colors.base_100 },

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
    MarkviewIcon0 = { fg = colors.base_500, bg = colors.base_700 },
    MarkviewIcon1 = { fg = colors.base_200, bg = colors.base_700 },
    MarkviewIcon2 = { fg = colors.base_200, bg = colors.base_700 },
    MarkviewIcon3 = { fg = colors.base_200, bg = colors.base_700 },
    MarkviewIcon4 = { fg = colors.base_200, bg = colors.base_700 },
    MarkviewIcon5 = { fg = colors.base_200, bg = colors.base_700 },
    MarkviewIcon6 = { fg = colors.base_200, bg = colors.base_700 },

    -- Inline code (similar to render-markdown)
    MarkviewInlineCode = { bg = colors.base_950, fg = colors.accent_500 },

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
    group_fg = colors.base_400,
    bg = colors.base_800,
    border_fg = colors.base_800,
  }

  -- Merge with user overrides if provided
  if plugin_config then
    config = utils.extend("force", config, plugin_config)
  end

  return {
    WhichKey = { fg = config.key_fg },
    WhichKeyIcon = { fg = colors.base_500 },
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
    handle_bg = utils.opaque(colors.base_500, 0.30, nil, colors),
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
    ScrollbarMisc = { fg = colors.base_500 },
    ScrollbarMiscHandle = { fg = colors.base_500, bg = utils.opaque(colors.base_500, 0.30, nil, colors) },

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
    ScrollbarSearch = { fg = colors.base_100 },
    ScrollbarSearchHandle = { fg = colors.base_100, bg = utils.opaque(colors.base_500, 0.30, nil, colors) },

    -- Cursor position indicator
    ScrollbarCursor = { fg = colors.base_500 },
    ScrollbarCursorHandle = { fg = colors.base_500, bg = utils.opaque(colors.base_500, 0.30, nil, colors) },
  }
end

M["yetone/avante.nvim"] = function(colors, global_config, plugin_config)
  return {
    -- State indicators with colorful backgrounds
    AvanteStateSpinnerSearching = { fg = colors.base_900, bg = colors.purple },
    AvanteStateSpinnerSucceeded = { fg = colors.base_900, bg = colors.green },
    AvanteStateSpinnerFailed = { fg = colors.base_900, bg = colors.red },
    AvanteStateSpinnerToolCalling = { fg = colors.base_900, bg = colors.blue },
    AvanteStateSpinnerGenerating = { fg = colors.base_900, bg = colors.accent_300 },
    AvanteStateSpinnerCompacting = { fg = colors.base_900, bg = colors.purple },
    AvanteStateSpinnerThinking = { fg = colors.base_900, bg = colors.purple },

    -- Main UI elements
    AvanteReversedNormal = { bg = colors.base_400 },
    AvanteCommentFg = { fg = colors.base_500 },

    -- Logo gradient (from dark to light)
    AvanteLogoLine1 = { fg = colors.base_100 },
    AvanteLogoLine2 = { fg = colors.base_200 },
    AvanteLogoLine3 = { fg = colors.base_200 },
    AvanteLogoLine4 = { fg = colors.base_300 },
    AvanteLogoLine5 = { fg = colors.base_300 },
    AvanteLogoLine6 = { fg = colors.base_400 },
    AvanteLogoLine7 = { fg = colors.base_400 },
    AvanteLogoLine8 = { fg = colors.base_500 },
    AvanteLogoLine9 = { fg = colors.base_500 },
    AvanteLogoLine10 = { fg = colors.base_600 },
    AvanteLogoLine11 = { fg = colors.base_600 },
    AvanteLogoLine12 = { fg = colors.base_700 },
    AvanteLogoLine13 = { fg = colors.base_700 },
    AvanteLogoLine14 = { fg = colors.base_800 },

    -- Buttons with proper styling
    AvanteButtonDefault = { fg = colors.base_900, bg = colors.base_300 },
    AvanteButtonDefaultHover = { fg = colors.base_900, bg = colors.green },
    AvanteButtonPrimary = { fg = colors.base_900, bg = colors.base_300 },
    AvanteButtonPrimaryHover = { fg = colors.base_900, bg = colors.blue },
    AvanteButtonDanger = { fg = colors.base_900, bg = colors.base_300 },
    AvanteButtonDangerHover = { fg = colors.base_900, bg = colors.red },

    -- Titles and headers
    AvanteTitle = { fg = colors.base_900, bg = colors.green },
    AvanteSubtitle = { fg = colors.base_900, bg = colors.blue },
    AvanteReversedTitle = { fg = colors.green, bg = colors.base_900 },
    AvanteReversedSubtitle = { fg = colors.blue, bg = colors.base_900 },
    AvanteThirdTitle = { fg = colors.base_300, bg = colors.base_700 },
    AvanteReversedThirdTitle = { fg = colors.base_700, bg = colors.base_900 },

    -- Sidebar and floating elements
    AvanteSidebarNormal = { link = "NormalFloat" },
    AvanteSidebarWinSeparator = { fg = colors.base_900, bg = colors.base_900 },
    AvanteSidebarWinHorizontalSeparator = { fg = colors.base_700, bg = colors.base_900 },

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
    AvanteConfirmTitle = { fg = colors.base_900, bg = colors.red },

    -- Diff and change indicators
    AvanteToBeDeleted = { strikethrough = true, bg = utils.opaque(colors.red, 0.20, nil, colors) },
    AvanteToBeDeletedWOStrikethrough = { bg = utils.opaque(colors.red, 0.15, nil, colors) },

    -- Conflict resolution
    AvanteConflictCurrent = { bold = true, bg = utils.opaque(colors.red, 0.15, nil, colors) },
    AvanteConflictCurrentLabel = { bg = utils.opaque(colors.red, 0.25, nil, colors) },
    AvanteConflictIncoming = { bold = true, bg = utils.opaque(colors.blue, 0.15, nil, colors) },
    AvanteConflictIncomingLabel = { bg = utils.opaque(colors.blue, 0.25, nil, colors) },
  }
end

return M
