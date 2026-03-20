local M = {}
local utils = require("xeno.core.utils")
local helpers = require("xeno.core.helpers")

function M.generate_editor_highlights(colors, config)
  return {
    Normal = { bg = colors.background_950, fg = colors.foreground_50 },
    NormalNC = { bg = colors.background_950, fg = colors.foreground_100 },
    Visual = { bg = utils.opaque(colors.background_600, 0.20) },

    NormalFloat = { fg = colors.foreground_100, bg = colors.background_900 },
    FloatBorder = { fg = colors.background_800, bg = colors.background_900 },
    FloatTitle = { fg = colors.foreground_50, bg = colors.background_900 },

    ColorColumn = { bg = colors.background_900 },

    Cursor = { bg = colors.accent_500, fg = "#000000" },
    CursorColumn = { bg = utils.opaque(colors.background_600, 0.05) },
    CursorLine = { bg = utils.opaque(colors.background_600, 0.05) },
    CursorLineNr = { bg = utils.opaque(colors.background_600, 0.05), fg = colors.foreground_100, bold = false },
    CursorLineFold = { bg = utils.opaque(colors.background_600, 0.05) },
    CursorLineSign = { bg = utils.opaque(colors.background_600, 0.05) },
    CursorLineSignColumn = { bg = utils.opaque(colors.background_600, 0.05) },

    LineNr = { fg = colors.foreground_400 },
    Directory = { fg = colors.foreground_100 },

    ErrorMsg = { fg = colors.red },
    WarningMsg = { fg = colors.yellow },
    MoreMsg = { fg = colors.green },

    Search = { bg = utils.opaque(colors.background_600, 0.15), fg = colors.foreground_100 },
    IncSearch = { link = "Cursor" },
    CurSearch = { bg = utils.opaque(colors.background_600, 0.40), fg = colors.foreground_100 },

    MatchParen = { fg = colors.accent_100, bold = true },
    NonText = { fg = colors.foreground_400 },

    Pmenu = { bg = colors.background_800, fg = colors.foreground_100 },
    PmenuSel = { bg = colors.background_700, bold = false, reverse = false },
    PmenuSbar = { bg = colors.background_950 },
    PmenuThumb = { bg = colors.background_700 },

    Question = { fg = colors.green },
    QuickFixLine = { bg = colors.background_900 },
    SpecialKey = { fg = colors.foreground_50 },
    SpellBad = { undercurl = true, sp = colors.red },
    SpellCap = { undercurl = true, sp = colors.yellow },
    SpellLocal = { undercurl = true, sp = colors.green },
    SpellRare = { undercurl = true, sp = colors.accent_100 },

    StatusLine = { fg = colors.foreground_100, bg = colors.background_950 },
    StatusLineNC = { fg = colors.foreground_200, bg = colors.background_900 },
    TabLine = { fg = colors.foreground_200, bg = colors.background_900 },
    TabLineFill = { fg = colors.foreground_300, bg = colors.background_900 },
    TabLineSel = { fg = colors.background_950, bg = colors.accent_100 },

    Title = { fg = colors.foreground_50, bold = true },
    VisualNOS = { bg = colors.background_900 },

    WinSeparator = { fg = colors.background_800 },
    WhiteSpace = { fg = colors.foreground_400 },
    WinBar = helpers.with_borders({ bg = colors.background_900, fg = colors.foreground_300, sp = colors.background_800 }, config),
    WinBarNC = helpers.with_borders({ bg = colors.background_900, fg = colors.foreground_300, sp = colors.background_800 }, config),

    WildMenu = { fg = colors.foreground_100, bg = colors.background_900 },
    SignColumn = { link = "Normal" },
    Folded = { fg = colors.foreground_200, bg = colors.background_900 },
    FoldStatus = { fg = utils.adjust_lightness(colors.foreground_200, -50) },
    FoldColumn = { link = "Normal", fg = colors.foreground_300 },
    EndOfBuffer = { link = "Normal" },
    Substitute = { fg = colors.background_950, bg = colors.accent_100 },

    IndentLine = { fg = colors.foreground_400, bg = "NONE" },

    NotifyBackground = { bg = "NONE" },

    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInfo = { fg = colors.accent_100 },
    DiagnosticHint = { fg = colors.green },

    DiagnosticVirtualTextError = { fg = colors.red },
    DiagnosticVirtualTextWarn = { fg = colors.yellow },
    DiagnosticVirtualTextInfo = { fg = colors.accent_100 },
    DiagnosticVirtualTextHint = { fg = colors.green },

    DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = colors.accent_100, undercurl = true },
    DiagnosticUnderlineHint = { sp = colors.green, undercurl = true },

    DiagnosticFloatingError = { fg = colors.red, bg = colors.background_900 },
    DiagnosticFloatingWarn = { fg = colors.yellow, bg = colors.background_900 },
    DiagnosticFloatingInfo = { fg = colors.accent_100, bg = colors.background_900 },
    DiagnosticFloatingHint = { fg = colors.green, bg = colors.background_900 },
    DiagnosticFloatingOk = { fg = colors.green, bg = colors.background_900 },

    ErrorFloat = { fg = colors.red, bg = colors.background_900 },
    WarningFloat = { fg = colors.yellow, bg = colors.background_900 },
    InfoFloat = { fg = colors.accent_100, bg = colors.background_900 },
    HintFloat = { fg = colors.green, bg = colors.background_900 },
    OkFloat = { fg = colors.green, bg = colors.background_900 },

    VirtualTextError = { fg = colors.red },
    VirtualTextWarning = { fg = colors.yellow },
    VirtualTextInfo = { fg = colors.accent_100 },
    VirtualTextHint = { fg = colors.green },
    VirtualTextOk = { fg = colors.green },

    RedSign = { fg = colors.red },
    YellowSign = { fg = colors.yellow },
    BlueSign = { fg = colors.accent_100 },
    PurpleSign = { fg = colors.accent_100 },
    GreenSign = { fg = colors.green },

    CurrentWord = { bg = utils.opaque(colors.background_600, 0.30) },
    InlayHints = { fg = colors.foreground_400 },

    LspInfoBorder = { fg = colors.background_700, bg = colors.background_900 },
    LspInfoTitle = { fg = colors.foreground_100, bg = colors.background_900 },
    LspInfoFloat = { fg = colors.foreground_100, bg = colors.background_900 },

    LspHover = { fg = colors.foreground_100, bg = colors.background_900 },
    LspHoverBorder = { fg = colors.background_700, bg = colors.background_900 },
    LspSignatureHelp = { fg = colors.foreground_100, bg = colors.background_900 },
    LspSignatureHelpBorder = { fg = colors.background_700, bg = colors.background_900 },

    -- Additional floating window variants
    FloatingWindow = { fg = colors.foreground_100, bg = colors.background_900 },
    Floating = { fg = colors.foreground_100, bg = colors.background_900 },

    DiagnosticSignError = { fg = colors.red },
    DiagnosticSignWarn = { fg = colors.yellow },
    DiagnosticSignInfo = { fg = colors.accent_100 },
    DiagnosticSignHint = { fg = colors.green },

    DiagnosticUnnecessary = { fg = colors.foreground_400 },

    DiffAdd = { bg = utils.opaque(colors.green, 0.25), fg = colors.green },
    DiffChange = { bg = utils.opaque(colors.yellow, 0.25), fg = colors.yellow },
    DiffDelete = { bg = utils.opaque(colors.red, 0.25), fg = colors.red },
    DiffText = { bg = colors.background_900 },

    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.yellow },
    GitSignsDelete = { fg = colors.red },
  }
end

return M
