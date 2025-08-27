local M = {}
local utils = require("xeno.core.utils")

function M.generate_editor_highlights(colors)
  local is_light = utils.get_variant() == 2
  local cursor_line_bg = is_light and colors.base_800 or colors.base_900

  return {
    Normal = { bg = colors.base_900, fg = colors.base_300 },
    NormalNC = { fg = colors.base_200, bg = colors.base_900 },
    Visual = { bg = utils.opaque(colors.accent_100, 0.2) },

    NormalFloat = { fg = colors.base_200, bg = colors.base_800 },
    FloatBorder = { fg = colors.base_400, bg = colors.base_800 },
    FloatTitle = { fg = colors.base_300, bg = colors.base_800 },

    ColorColumn = { bg = colors.base_800 },

    Cursor = { bg = colors.accent_200, reverse = false },
    CursorColumn = { bg = cursor_line_bg },
    CursorLine = { bg = cursor_line_bg },
    CursorLineNr = { bg = cursor_line_bg, fg = colors.accent_200 },
    CursorLineFold = { bg = cursor_line_bg },
    CursorLineSign = { bg = cursor_line_bg },
    CursorLineSignColumn = { bg = cursor_line_bg },

    LineNr = { fg = colors.base_600 },
    Directory = { fg = colors.base_200 },

    ErrorMsg = { fg = colors.red },
    WarningMsg = { fg = colors.yellow },
    MoreMsg = { fg = colors.green },

    IncSearch = { bg = utils.opaque(colors.accent_100, 0.2) },
    Search = { bg = utils.opaque(colors.accent_100, 0.2) },
    CurSearch = { bg = utils.opaque(colors.accent_100, 0.4) },

    MatchParen = { fg = colors.accent_100, bold = true },
    NonText = { fg = colors.base_300 },

    Pmenu = { bg = colors.base_700, fg = colors.base_200 },
    PmenuSel = { bg = colors.base_600, bold = false },
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
    WinBar = { bg = "NONE", fg = utils.adjust_lightness(colors.base_200, -50), bold = false },
    WinBarNC = { link = "WinBar" },

    WildMenu = { fg = colors.base_200, bg = colors.base_800 },
    SignColumn = { bg = "NONE" },
    Folded = { fg = colors.base_300, bg = utils.adjust_lightness(colors.base_700, 3) },
    FoldStatus = { fg = utils.adjust_lightness(colors.base_200, -50) },
    FoldColumn = { fg = colors.base_300, bg = colors.base_700 },
    EndOfBuffer = { bg = "NONE" },
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

    DiagnosticSignError = { fg = colors.red },
    DiagnosticSignWarn = { fg = colors.yellow },
    DiagnosticSignInfo = { fg = colors.accent_100 },
    DiagnosticSignHint = { fg = colors.green },

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
