local M = {}
local utils = require("xeno.utils")

function M.generate_base_highlights(colors)
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

    Comment = { fg = colors.base_600, italic = true },
    Constant = { fg = colors.accent_100 },
    Number = { fg = colors.accent_100 },
    String = { fg = colors.accent_100 },
    Character = { fg = colors.base_300 },
    Boolean = { fg = colors.base_300 },
    Float = { fg = colors.base_300 },
    Identifier = { fg = colors.base_300 },
    Function = { fg = colors.base_200 },
    Statement = { fg = colors.accent_100 },
    Conditional = { fg = colors.accent_100 },
    Repeat = { fg = colors.accent_100 },
    Label = { fg = colors.accent_300 },
    Operator = { fg = colors.base_300 },
    Keyword = { fg = colors.accent_100 },
    Exception = { fg = colors.accent_100 },
    PreProc = { fg = colors.accent_100 },
    Include = { fg = colors.accent_100 },
    Define = { fg = colors.accent_100 },
    Macro = { fg = colors.accent_100 },
    PreCondit = { fg = colors.accent_100 },
    Type = { fg = colors.accent_100 },
    StorageClass = { fg = colors.accent_100 },
    Structure = { fg = colors.accent_100 },
    Typedef = { fg = colors.accent_100 },
    Special = { fg = colors.base_300 },
    SpecialChar = { fg = colors.base_300 },
    Tag = { fg = colors.accent_100 },
    Delimiter = { fg = colors.base_300 },
    SpecialComment = { fg = colors.base_300, italic = true },
    Debug = { fg = colors.accent_100 },
    Underlined = { underline = true },
    Error = { fg = colors.red },
    Todo = { fg = colors.accent_100, italic = true, bold = true },

    ["@text"] = { fg = colors.base_200 },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.title"] = { fg = colors.accent_100, bold = true },
    ["@text.literal"] = { fg = colors.base_300 },
    ["@text.uri"] = { fg = colors.accent_100, underline = true },
    ["@text.reference"] = { fg = colors.accent_100 },

    ["@variable"] = { clear = true },
    ["@comment"] = { link = "Comment" },
    ["@spell"] = { clear = true },

    ["@keyword"] = { fg = colors.accent_200 },
    ["@keyword.function"] = { fg = colors.accent_200 },
    ["@keyword.operator"] = { fg = colors.accent_200 },
    ["@keyword.return"] = { fg = colors.accent_200 },

    ["@function"] = { fg = colors.base_200 },
    ["@function.builtin"] = { fg = colors.base_200 },
    ["@function.macro"] = { fg = colors.accent_100 },
    ["@method"] = { fg = colors.accent_100 },

    ["@variable.builtin"] = { fg = colors.base_400 },
    ["@lsp.type.variable"] = { fg = colors.base_400 },

    ["@parameter"] = { fg = colors.base_400, italic = true },
    ["@property"] = { fg = colors.accent_100 },
    ["@field"] = { fg = colors.accent_100 },

    ["@type"] = { fg = colors.accent_100 },
    ["@type.builtin"] = { fg = colors.accent_100 },
    ["@type.qualifier"] = { fg = colors.accent_100 },
    ["@type.definition"] = { fg = colors.accent_100 },

    ["@include"] = { fg = colors.accent_100 },
    ["@namespace"] = { fg = colors.accent_100 },

    ["@punctuation"] = { fg = colors.base_500 },
    ["@punctuation.delimiter"] = { fg = colors.base_500 },
    ["@punctuation.bracket"] = { fg = colors.base_500 },
    ["@punctuation.special"] = { fg = colors.base_500 },
    ["@constructor"] = { fg = colors.base_500 },

    ["@string"] = { fg = colors.accent_200 },
    ["@string.regexp"] = { fg = colors.accent_200 },
    ["@string.escape"] = { fg = colors.accent_200 },
    ["@string.special"] = { fg = colors.accent_100 },

    ["@constant"] = { fg = colors.accent_100 },
    ["@constant.builtin"] = { fg = colors.accent_100 },
    ["@constant.macro"] = { fg = colors.accent_100 },

    ["@number"] = { fg = colors.accent_300 },
    ["@boolean"] = { fg = colors.base_300 },
    ["@float"] = { fg = colors.base_300 },

    ["@tag"] = { fg = colors.accent_100 },
    ["@tag.attribute"] = { fg = colors.accent_100 },
    ["@tag.delimiter"] = { fg = colors.base_300 },

    ["@error"] = { fg = colors.red },
    ["@warning"] = { fg = colors.yellow },
    ["@info"] = { fg = colors.accent_100 },
    ["@hint"] = { fg = colors.green },

    TreeSitterContext = { fg = "#555555", bg = "NONE", sp = "#cccccc", underline = true },

    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },

    ["@base_100"] = { fg = colors.base_100 },
    ["@base_200"] = { fg = colors.base_200 },
    ["@base_300"] = { fg = colors.base_300 },
    ["@base_400"] = { fg = colors.base_400 },
    ["@base_500"] = { fg = colors.base_500 },
    ["@base_600"] = { fg = colors.base_600 },
    ["@base_700"] = { fg = colors.base_700 },
    ["@base_800"] = { fg = colors.base_800 },
    ["@base_900"] = { fg = colors.base_900 },

    ["@accent_100"] = { fg = colors.accent_100 },
    ["@accent_200"] = { fg = colors.accent_200 },
    ["@accent_300"] = { fg = colors.accent_300 },
    ["@accent_400"] = { fg = colors.accent_400 },
    ["@accent_500"] = { fg = colors.accent_500 },
    ["@accent_600"] = { fg = colors.accent_600 },
    ["@accent_700"] = { fg = colors.accent_700 },
    ["@accent_800"] = { fg = colors.accent_800 },
    ["@accent_900"] = { fg = colors.accent_900 },
  }
end

return M
