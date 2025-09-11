local M = {}
local utils = require("xeno.core.utils")
local helpers = require("xeno.core.helpers")

function M.generate_editor_highlights(colors, config)
  return {
    Normal = { bg = colors.base_900, fg = colors.base_300 },
    NormalNC = { fg = colors.base_200, bg = colors.base_900 },
    Visual = { bg = utils.opaque(colors.base_500, 0.20) },

    NormalFloat = { fg = colors.base_200, bg = colors.base_800 },
    FloatBorder = { fg = colors.base_700, bg = colors.base_800 },
    FloatTitle = { fg = colors.base_300, bg = colors.base_800 },

    ColorColumn = { bg = colors.base_800 },

    Cursor = { bg = colors.accent_500, fg = "#000000" },
    CursorColumn = { bg = utils.opaque(colors.base_500, 0.05) },
    CursorLine = { bg = utils.opaque(colors.base_500, 0.05) },
    CursorLineNr = { bg = utils.opaque(colors.base_500, 0.05), fg = colors.base_200, bold = false },
    CursorLineFold = { bg = utils.opaque(colors.base_500, 0.05) },
    CursorLineSign = { bg = utils.opaque(colors.base_500, 0.05) },
    CursorLineSignColumn = { bg = utils.opaque(colors.base_500, 0.05) },

    LineNr = { fg = colors.base_600 },
    Directory = { fg = colors.base_200 },

    ErrorMsg = { fg = colors.red },
    WarningMsg = { fg = colors.yellow },
    MoreMsg = { fg = colors.green },

    Search = { bg = utils.opaque(colors.base_500, 0.15) },
    IncSearch = { link = "Cursor" },
    CurSearch = { bg = utils.opaque(colors.base_500, 0.40) },

    MatchParen = { fg = colors.accent_100, bold = true },
    NonText = { fg = colors.base_300 },

    Pmenu = { bg = colors.base_700, fg = colors.base_200 },
    PmenuSel = { bg = colors.base_600, bold = false, reverse = false },
    PmenuSbar = { bg = colors.base_900 },
    PmenuThumb = { bg = colors.base_600 },

    Question = { fg = colors.green },
    QuickFixLine = { bg = colors.base_800 },
    SpecialKey = { fg = colors.base_300 },
    SpellBad = { undercurl = true, sp = colors.red },
    SpellCap = { undercurl = true, sp = colors.yellow },
    SpellLocal = { undercurl = true, sp = colors.green },
    SpellRare = { undercurl = true, sp = colors.accent_100 },

    StatusLine = { fg = colors.base_200, bg = colors.base_900 },
    StatusLineNC = { fg = colors.base_300, bg = colors.base_800 },
    TabLine = { fg = colors.base_300, bg = colors.base_800 },
    TabLineFill = { fg = colors.base_400, bg = colors.base_800 },
    TabLineSel = { fg = colors.base_700, bg = colors.accent_100 },

    Title = { fg = colors.base_200, bold = true },
    VisualNOS = { bg = colors.base_800 },

    WinSeparator = { fg = colors.base_700 },
    WhiteSpace = { fg = colors.base_700 },
    WinBar = helpers.with_borders({ bg = colors.base_800, fg = colors.base_500, sp = colors.base_700 }, config),
    WinBarNC = helpers.with_borders({ bg = colors.base_800, fg = colors.base_500, sp = colors.base_700 }, config),

    WildMenu = { fg = colors.base_200, bg = colors.base_800 },
    SignColumn = { link = "Normal" },
    Folded = { fg = colors.base_300, bg = colors.base_800 },
    FoldStatus = { fg = utils.adjust_lightness(colors.base_200, -50) },
    FoldColumn = { link = "Normal", fg = colors.base_500 },
    EndOfBuffer = { link = "Normal" },
    Substitute = { fg = colors.base_700, bg = colors.accent_100 },

    IndentLine = { fg = colors.base_200, bg = "NONE" },

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

    DiagnosticFloatingError = { fg = colors.red, bg = colors.base_800 },
    DiagnosticFloatingWarn = { fg = colors.yellow, bg = colors.base_800 },
    DiagnosticFloatingInfo = { fg = colors.accent_100, bg = colors.base_800 },
    DiagnosticFloatingHint = { fg = colors.green, bg = colors.base_800 },
    DiagnosticFloatingOk = { fg = colors.green, bg = colors.base_800 },

    ErrorFloat = { fg = colors.red, bg = colors.base_800 },
    WarningFloat = { fg = colors.yellow, bg = colors.base_800 },
    InfoFloat = { fg = colors.accent_100, bg = colors.base_800 },
    HintFloat = { fg = colors.green, bg = colors.base_800 },
    OkFloat = { fg = colors.green, bg = colors.base_800 },

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

    CurrentWord = { bg = utils.opaque(colors.base_500, 0.30) },
    InlayHints = { fg = colors.base_500 },

    LspInfoBorder = { fg = colors.base_400, bg = colors.base_800 },
    LspInfoTitle = { fg = colors.base_300, bg = colors.base_800 },
    LspInfoFloat = { fg = colors.base_200, bg = colors.base_800 },

    LspHover = { fg = colors.base_200, bg = colors.base_800 },
    LspHoverBorder = { fg = colors.base_400, bg = colors.base_800 },
    LspSignatureHelp = { fg = colors.base_200, bg = colors.base_800 },
    LspSignatureHelpBorder = { fg = colors.base_400, bg = colors.base_800 },

    -- Additional floating window variants
    FloatingWindow = { fg = colors.base_200, bg = colors.base_800 },
    Floating = { fg = colors.base_200, bg = colors.base_800 },

    DiagnosticSignError = { fg = colors.red },
    DiagnosticSignWarn = { fg = colors.yellow },
    DiagnosticSignInfo = { fg = colors.accent_100 },
    DiagnosticSignHint = { fg = colors.green },

    DiagnosticUnnecessary = { fg = colors.base_600 },

    DiffAdd = { bg = utils.opaque(colors.green, 0.25), fg = colors.green },
    DiffChange = { bg = utils.opaque(colors.yellow, 0.25), fg = colors.yellow },
    DiffDelete = { bg = utils.opaque(colors.red, 0.25), fg = colors.red },
    DiffText = { bg = colors.base_800 },

    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.yellow },
    GitSignsDelete = { fg = colors.red },
  }
end

return M
