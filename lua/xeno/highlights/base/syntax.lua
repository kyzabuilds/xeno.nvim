local M = {}

function M.generate_syntax_highlights(colors)
  return {
    -- Use syntax_base colors for base-derived syntax elements
    Comment = { fg = colors.syntax_base_500, italic = true },
    Character = { fg = colors.syntax_base_300 },
    Boolean = { fg = colors.syntax_base_300 },
    Float = { fg = colors.syntax_base_300 },
    Identifier = { fg = colors.syntax_base_300 },
    Function = { fg = colors.syntax_base_100 },
    Operator = { fg = colors.syntax_base_300 },
    Special = { fg = colors.syntax_base_300 },
    SpecialChar = { fg = colors.syntax_base_300 },
    Delimiter = { fg = colors.syntax_base_300 },
    SpecialComment = { fg = colors.syntax_base_300, italic = true },

    -- Use syntax_accent colors for accent-derived syntax elements
    Constant = { fg = colors.syntax_accent_100 },
    Number = { fg = colors.syntax_accent_100 },
    String = { fg = colors.syntax_accent_100 },
    Statement = { fg = colors.syntax_accent_100 },
    Conditional = { fg = colors.syntax_accent_100 },
    Repeat = { fg = colors.syntax_accent_100 },
    Label = { fg = colors.syntax_accent_300 },
    Keyword = { fg = colors.syntax_accent_100 },
    Exception = { fg = colors.syntax_accent_100 },
    PreProc = { fg = colors.syntax_accent_100 },
    Include = { fg = colors.syntax_accent_100 },
    Define = { fg = colors.syntax_accent_100 },
    Macro = { fg = colors.syntax_accent_100 },
    PreCondit = { fg = colors.syntax_accent_100 },
    Type = { fg = colors.syntax_accent_100 },
    StorageClass = { fg = colors.syntax_accent_100 },
    Structure = { fg = colors.syntax_accent_100 },
    Typedef = { fg = colors.syntax_accent_100 },
    Tag = { fg = colors.syntax_accent_100 },
    Debug = { fg = colors.syntax_accent_100 },
    Todo = { fg = colors.syntax_accent_100, italic = true, bold = true },

    Underlined = { underline = true },
    Error = { fg = colors.red },

    -- TreeSitter highlights using syntax palettes
    ["@text"] = { fg = colors.syntax_base_200 },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.title"] = { fg = colors.syntax_accent_200, bold = true },
    ["@text.literal"] = { fg = colors.syntax_base_300 },
    ["@text.uri"] = { fg = colors.syntax_accent_100, underline = true },
    ["@text.reference"] = { fg = colors.syntax_accent_100 },

    ["@variable"] = { clear = true },
    ["@comment"] = { link = "Comment" },
    ["@spell"] = { clear = true },

    -- Keywords use syntax accent colors
    ["@keyword"] = { fg = colors.syntax_accent_300 },
    ["@keyword.repeat"] = { fg = colors.syntax_accent_300 },
    ["@keyword.function"] = { fg = colors.syntax_accent_200 },
    ["@keyword.conditional"] = { fg = colors.syntax_accent_200 },
    ["@keyword.operator"] = { fg = colors.syntax_accent_200 },
    ["@keyword.return"] = { fg = colors.syntax_accent_200 },

    -- Functions use syntax base colors
    ["@function"] = { fg = colors.syntax_accent_100 },
    ["@function.builtin"] = { fg = colors.syntax_base_100 },
    ["@function.macro"] = { fg = colors.syntax_accent_100 },
    ["@method"] = { fg = colors.syntax_accent_100 },

    -- Variables use syntax base colors
    ["@variable.builtin"] = { fg = colors.syntax_base_400 },
    ["@lsp.type.variable"] = { fg = colors.syntax_base_400 },

    -- Parameters use syntax base colors
    ["@parameter"] = { fg = colors.syntax_base_400, italic = true },
    ["@property"] = { fg = colors.syntax_base_100 },
    ["@field"] = { fg = colors.syntax_accent_100 },

    -- Types use syntax accent colors
    ["@type"] = { fg = colors.syntax_base_100 },
    ["@type.builtin"] = { fg = colors.syntax_accent_100 },
    ["@type.qualifier"] = { fg = colors.syntax_accent_100 },
    ["@type.definition"] = { fg = colors.syntax_accent_100 },

    -- Modules and imports
    ["@module"] = { fg = colors.syntax_base_100 },
    ["@label"] = { fg = colors.syntax_accent_300 },
    ["@include"] = { fg = colors.syntax_accent_100 },
    ["@namespace"] = { fg = colors.syntax_accent_100 },

    -- Punctuation uses syntax base colors
    ["@punctuation"] = { fg = colors.syntax_base_500 },
    ["@punctuation.delimiter"] = { fg = colors.syntax_base_500 },
    ["@punctuation.bracket"] = { fg = colors.syntax_base_500 },
    ["@punctuation.special"] = { fg = colors.syntax_base_500 },
    ["@constructor"] = { fg = colors.syntax_base_500 },

    -- Strings use syntax accent colors
    ["@string"] = { fg = colors.syntax_accent_200 },
    ["@string.regexp"] = { fg = colors.syntax_accent_200 },
    ["@string.escape"] = { fg = colors.syntax_accent_200 },
    ["@string.special"] = { fg = colors.syntax_accent_100 },

    -- Constants use syntax accent colors
    ["@constant"] = { fg = colors.syntax_accent_100 },
    ["@constant.builtin"] = { fg = colors.syntax_accent_100 },
    ["@constant.macro"] = { fg = colors.syntax_accent_100 },

    -- Numbers and booleans
    ["@number"] = { fg = colors.syntax_accent_300 },
    ["@boolean"] = { fg = colors.syntax_base_300 },
    ["@float"] = { fg = colors.syntax_base_300 },

    -- Tags use syntax accent colors
    ["@tag"] = { fg = colors.syntax_accent_100 },
    ["@tag.attribute"] = { fg = colors.syntax_accent_100 },
    ["@tag.delimiter"] = { fg = colors.syntax_base_300 },

    -- Diagnostics
    ["@error"] = { fg = colors.red },
    ["@warning"] = { fg = colors.yellow },
    ["@info"] = { fg = colors.syntax_accent_100 },
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
    ["@markup.strong"] = { fg = colors.base_50, bold = true },

    -- Color reference highlights for both standard and syntax palettes

    -- Standard base colors (for UI reference)
    ["@base.fg.100"] = { fg = colors.base_100, sp = colors.base_100 },
    ["@base.fg.200"] = { fg = colors.base_200, sp = colors.base_200 },
    ["@base.fg.300"] = { fg = colors.base_300, sp = colors.base_300 },
    ["@base.fg.400"] = { fg = colors.base_400, sp = colors.base_400 },
    ["@base.fg.500"] = { fg = colors.base_500, sp = colors.base_500 },
    ["@base.fg.600"] = { fg = colors.base_600, sp = colors.base_600 },
    ["@base.fg.700"] = { fg = colors.base_700, sp = colors.base_700 },
    ["@base.fg.800"] = { fg = colors.base_800, sp = colors.base_800 },
    ["@base.fg.900"] = { fg = colors.base_900, sp = colors.base_900 },
    ["@base.fg.950"] = { fg = colors.base_950, sp = colors.base_950 },

    ["@base.bg.100"] = { bg = colors.base_100 },
    ["@base.bg.200"] = { bg = colors.base_200 },
    ["@base.bg.300"] = { bg = colors.base_300 },
    ["@base.bg.400"] = { bg = colors.base_400 },
    ["@base.bg.500"] = { bg = colors.base_500 },
    ["@base.bg.600"] = { bg = colors.base_600 },
    ["@base.bg.700"] = { bg = colors.base_700 },
    ["@base.bg.800"] = { bg = colors.base_800 },
    ["@base.bg.900"] = { bg = colors.base_900 },
    ["@base.bg.950"] = { bg = colors.base_950 },

    -- Standard accent colors (for UI reference)
    ["@accent.fg.100"] = { fg = colors.accent_100, sp = colors.accent_100 },
    ["@accent.fg.200"] = { fg = colors.accent_200, sp = colors.accent_200 },
    ["@accent.fg.300"] = { fg = colors.accent_300, sp = colors.accent_300 },
    ["@accent.fg.400"] = { fg = colors.accent_400, sp = colors.accent_400 },
    ["@accent.fg.500"] = { fg = colors.accent_500, sp = colors.accent_500 },
    ["@accent.fg.600"] = { fg = colors.accent_600, sp = colors.accent_600 },
    ["@accent.fg.700"] = { fg = colors.accent_700, sp = colors.accent_700 },
    ["@accent.fg.800"] = { fg = colors.accent_800, sp = colors.accent_800 },
    ["@accent.fg.900"] = { fg = colors.accent_900, sp = colors.accent_900 },
    ["@accent.fg.950"] = { fg = colors.accent_950, sp = colors.accent_950 },

    ["@accent.bg.100"] = { bg = colors.accent_100 },
    ["@accent.bg.200"] = { bg = colors.accent_200 },
    ["@accent.bg.300"] = { bg = colors.accent_300 },
    ["@accent.bg.400"] = { bg = colors.accent_400 },
    ["@accent.bg.500"] = { bg = colors.accent_500 },
    ["@accent.bg.600"] = { bg = colors.accent_600 },
    ["@accent.bg.700"] = { bg = colors.accent_700 },
    ["@accent.bg.800"] = { bg = colors.accent_800 },
    ["@accent.bg.900"] = { bg = colors.accent_900 },
    ["@accent.bg.950"] = { bg = colors.accent_950 },
  }
end

return M
