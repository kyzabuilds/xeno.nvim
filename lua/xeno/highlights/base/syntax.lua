local M = {}

function M.generate_syntax_highlights(colors)
  return {
    -- Base syntax now derives from the split foreground/background families.
    Comment = { fg = colors.foreground_400, italic = true },
    Character = { fg = colors.foreground_300 },
    Boolean = { fg = colors.foreground_300 },
    Float = { fg = colors.foreground_300 },
    Identifier = { fg = colors.foreground_200 },
    Function = { fg = colors.foreground_100 },
    Operator = { fg = colors.foreground_300 },
    Special = { fg = colors.foreground_300 },
    SpecialChar = { fg = colors.foreground_300 },
    Delimiter = { fg = colors.foreground_300 },
    SpecialComment = { fg = colors.foreground_300, italic = true },

    -- Accent syntax continues to use the accent family directly.
    Constant = { fg = colors.accent_100 },
    Number = { fg = colors.accent_100 },
    String = { fg = colors.accent_100 },
    Statement = { fg = colors.accent_100 },
    Conditional = { fg = colors.accent_100 },
    Repeat = { fg = colors.accent_100 },
    Label = { fg = colors.accent_300 },
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
    Tag = { fg = colors.accent_100 },
    Debug = { fg = colors.accent_100 },
    Todo = { fg = colors.accent_100, italic = true, bold = true },

    Underlined = { underline = true },
    Error = { fg = colors.red },

    -- TreeSitter highlights using syntax palettes
    ["@text"] = { fg = colors.foreground_200 },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.title"] = { fg = colors.accent_200, bold = true },
    ["@text.literal"] = { fg = colors.foreground_300 },
    ["@text.uri"] = { fg = colors.accent_100, underline = true },
    ["@text.reference"] = { fg = colors.accent_100 },

    ["@variable"] = { fg = colors.foreground_200 },
    ["@comment"] = { link = "Comment" },
    ["@spell"] = { clear = true },

    -- Keywords use syntax accent colors
    ["@keyword"] = { fg = colors.accent_300 },
    ["@keyword.repeat"] = { fg = colors.accent_300 },
    ["@keyword.function"] = { fg = colors.accent_200 },
    ["@keyword.conditional"] = { fg = colors.accent_200 },
    ["@keyword.operator"] = { fg = colors.accent_200 },
    ["@keyword.return"] = { fg = colors.accent_200 },

    ["@function"] = { fg = colors.accent_100 },
    ["@function.builtin"] = { fg = colors.foreground_100 },
    ["@function.macro"] = { fg = colors.accent_100 },
    ["@method"] = { fg = colors.accent_100 },

    ["@variable.builtin"] = { fg = colors.foreground_400 },
    ["@lsp.type.variable"] = { fg = colors.foreground_400 },

    ["@parameter"] = { fg = colors.foreground_400, italic = true },
    ["@property"] = { fg = colors.foreground_100 },
    ["@field"] = { fg = colors.accent_100 },

    ["@type"] = { fg = colors.foreground_100 },
    ["@type.builtin"] = { fg = colors.accent_100 },
    ["@type.qualifier"] = { fg = colors.accent_100 },
    ["@type.definition"] = { fg = colors.accent_100 },

    -- Modules and imports
    ["@module"] = { fg = colors.foreground_100 },
    ["@label"] = { fg = colors.accent_300 },
    ["@include"] = { fg = colors.accent_100 },
    ["@namespace"] = { fg = colors.accent_100 },

    ["@punctuation"] = { fg = colors.foreground_300 },
    ["@punctuation.delimiter"] = { fg = colors.foreground_300 },
    ["@punctuation.bracket"] = { fg = colors.foreground_300 },
    ["@punctuation.special"] = { fg = colors.foreground_300 },
    ["@constructor"] = { fg = colors.foreground_200 },

    ["@string"] = { fg = colors.accent_200 },
    ["@string.regexp"] = { fg = colors.accent_200 },
    ["@string.escape"] = { fg = colors.accent_200 },
    ["@string.special"] = { fg = colors.accent_100 },

    ["@constant"] = { fg = colors.accent_100 },
    ["@constant.builtin"] = { fg = colors.accent_100 },
    ["@constant.macro"] = { fg = colors.accent_100 },

    -- Numbers and booleans
    ["@number"] = { fg = colors.accent_300 },
    ["@boolean"] = { fg = colors.foreground_300 },
    ["@float"] = { fg = colors.foreground_300 },

    ["@tag"] = { fg = colors.accent_100 },
    ["@tag.attribute"] = { fg = colors.accent_100 },
    ["@tag.delimiter"] = { fg = colors.foreground_300 },

    -- Diagnostics
    ["@error"] = { fg = colors.red },
    ["@warning"] = { fg = colors.yellow },
    ["@info"] = { fg = colors.accent_100 },
    ["@hint"] = { fg = colors.green },

    -- LSP type mappings
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },

    -- Markdown support
    ["@markup.strong"] = { fg = colors.foreground_50, bold = true },

    -- Color reference highlights for the split base palette.
    ["@foreground.50"] = { fg = colors.foreground_50, sp = colors.foreground_50 },
    ["@foreground.100"] = { fg = colors.foreground_100, sp = colors.foreground_100 },
    ["@foreground.200"] = { fg = colors.foreground_200, sp = colors.foreground_200 },
    ["@foreground.300"] = { fg = colors.foreground_300, sp = colors.foreground_300 },
    ["@foreground.400"] = { fg = colors.foreground_400, sp = colors.foreground_400 },

    ["@background.500"] = { bg = colors.background_500 },
    ["@background.600"] = { bg = colors.background_600 },
    ["@background.700"] = { bg = colors.background_700 },
    ["@background.800"] = { bg = colors.background_800 },
    ["@background.900"] = { bg = colors.background_900 },
    ["@background.950"] = { bg = colors.background_950 },

    -- Standard accent colors (for UI reference)
    ["@accent.50"] = { fg = colors.accent_50, sp = colors.accent_50 },
    ["@accent.100"] = { fg = colors.accent_100, sp = colors.accent_100 },
    ["@accent.200"] = { fg = colors.accent_200, sp = colors.accent_200 },
    ["@accent.300"] = { fg = colors.accent_300, sp = colors.accent_300 },
    ["@accent.400"] = { fg = colors.accent_400, sp = colors.accent_400 },
    ["@accent.500"] = { fg = colors.accent_500, sp = colors.accent_500 },
    ["@accent.600"] = { fg = colors.accent_600, sp = colors.accent_600 },
  }
end

return M
