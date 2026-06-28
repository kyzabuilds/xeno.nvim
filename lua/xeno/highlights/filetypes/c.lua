local M = {}

function M.generate(_colors)
  return {
    -- Link C's Vim-syntax and Tree-sitter groups to the shared core groups
    -- instead of raw palette shades, so custom themes that override intents
    -- (Conditional, Boolean, String, @keyword.*, ...) flow through to C.

    -- Vim C syntax (non-treesitter buffers).
    cInclude = { link = "Include" },
    cPreProc = { link = "PreProc" },
    cDefine = { link = "Define" },
    cPreCondit = { link = "PreCondit" },
    cPreConditMatch = { link = "PreCondit" },
    cCppOutWrapper = { link = "PreCondit" },
    cCppInWrapper = { link = "PreCondit" },

    cStatement = { link = "Statement" },
    cConditional = { link = "Conditional" },
    cRepeat = { link = "Repeat" },
    cLabel = { link = "Label" },
    cTypedef = { link = "Typedef" },
    cStructure = { link = "Structure" },
    cFunction = { link = "Function" },
    cFunctionPointer = { link = "Function" },

    cType = { link = "Type" },
    cStorageClass = { link = "StorageClass" },
    cTypeQualifier = { link = "StorageClass" },
    cFunctionSpec = { link = "StorageClass" },
    cOperator = { link = "Operator" },
    cConstant = { link = "Constant" },
    cNumber = { link = "Number" },
    cOctal = { link = "Number" },
    cFloat = { link = "Float" },
    cCharacter = { link = "Character" },
    cString = { link = "String" },
    cCppString = { link = "String" },
    cIncluded = { link = "String" },
    cSpecial = { link = "Special" },
    cSpecialCharacter = { link = "SpecialChar" },
    cFormat = { link = "Special" },
    cComment = { link = "Comment" },
    cCommentL = { link = "Comment" },
    cCommentStart = { link = "Comment" },
    cCommentSkip = { link = "Comment" },
    cTodo = { link = "Todo" },

    -- Tree-sitter C captures.
    ["@variable.c"] = { link = "@variable" },
    ["@variable.member.c"] = { link = "@property" },
    ["@property.c"] = { link = "@property" },
    ["@parameter.c"] = { link = "@parameter" },
    ["@variable.parameter.c"] = { link = "@parameter" },
    ["@variable.builtin.c"] = { link = "@variable.builtin" },
    ["@constant.c"] = { link = "@constant" },
    ["@constant.builtin.c"] = { link = "@constant.builtin" },
    ["@constant.macro.c"] = { link = "@constant.macro" },
    ["@boolean.c"] = { link = "@boolean" },
    ["@number.c"] = { link = "@number" },
    ["@float.c"] = { link = "@float" },
    ["@string.c"] = { link = "@string" },
    ["@string.escape.c"] = { link = "@string.escape" },
    ["@character.c"] = { link = "Character" },

    ["@type.c"] = { link = "@type" },
    ["@type.builtin.c"] = { link = "@type.builtin" },
    ["@type.qualifier.c"] = { link = "@type.qualifier" },
    ["@type.definition.c"] = { link = "@type.definition" },
    ["@attribute.c"] = { link = "Special" },

    ["@function.c"] = { link = "@function" },
    ["@function.call.c"] = { link = "@function.call" },
    ["@function.builtin.c"] = { link = "@function.builtin" },
    ["@function.macro.c"] = { link = "@function.macro" },
    ["@function.method.c"] = { link = "@function.method" },
    ["@function.method.call.c"] = { link = "@function.method.call" },

    ["@keyword.c"] = { link = "@keyword" },
    ["@keyword.type.c"] = { link = "@keyword" },
    ["@keyword.import.c"] = { link = "@include" },
    ["@keyword.directive.c"] = { link = "PreProc" },
    ["@keyword.directive.define.c"] = { link = "Define" },
    ["@keyword.conditional.c"] = { link = "@keyword.conditional" },
    ["@keyword.conditional.ternary.c"] = { link = "Operator" },
    ["@keyword.repeat.c"] = { link = "@keyword.repeat" },
    ["@keyword.return.c"] = { link = "@keyword.return" },
    ["@keyword.operator.c"] = { link = "@keyword.operator" },
    ["@keyword.modifier.c"] = { link = "@type.qualifier" },
    ["@operator.c"] = { link = "Operator" },
    ["@punctuation.c"] = { link = "@punctuation" },
    ["@punctuation.delimiter.c"] = { link = "@punctuation.delimiter" },
    ["@punctuation.bracket.c"] = { link = "@punctuation.bracket" },
    ["@punctuation.special.c"] = { link = "@punctuation.special" },
    ["@label.c"] = { link = "@label" },
    ["@comment.c"] = { link = "@comment" },
    ["@comment.documentation.c"] = { link = "@comment" },

    -- LSP semantic tokens link to their treesitter equivalents (no pop-in).
    ["@lsp.type.variable.c"] = { link = "@variable.c" },
    ["@lsp.type.parameter.c"] = { link = "@parameter.c" },
    ["@lsp.type.property.c"] = { link = "@property.c" },
    ["@lsp.type.member.c"] = { link = "@property.c" },
    ["@lsp.type.enumMember.c"] = { link = "@constant.c" },
    ["@lsp.type.function.c"] = { link = "@function.c" },
    ["@lsp.type.macro.c"] = { link = "@function.macro.c" },
    ["@lsp.type.struct.c"] = { link = "@type.c" },
    ["@lsp.type.enum.c"] = { link = "@type.c" },
    ["@lsp.type.type.c"] = { link = "@type.c" },
    ["@lsp.type.typeParameter.c"] = { link = "@type.c" },
  }
end

return M
