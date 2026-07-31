local M = {}

function M.generate(_colors)
  return {
    -- Link Rust's Vim-syntax and Tree-sitter groups to the shared core groups
    -- instead of raw palette shades, so custom themes that override intents
    -- (Conditional, Boolean, String, @keyword.*, ...) flow through to Rust.

    -- Vim Rust syntax (non-treesitter buffers).
    rustConditional = { link = "@keyword.conditional" },
    rustRepeat = { link = "@keyword.repeat" },
    rustKeyword = { link = "@keyword" },
    rustTypedef = { link = "Typedef" },
    rustStructure = { link = "Structure" },
    rustUnion = { link = "Structure" },
    rustUnsafeKeyword = { link = "@keyword" },
    rustAsync = { link = "@keyword" },
    rustAwait = { link = "@keyword" },
    rustFuncName = { link = "@function" },
    rustFuncCall = { link = "@function.call" },
    rustAssert = { link = "@function.macro" },
    rustPanic = { link = "@function.macro" },
    rustLabel = { link = "@label" },
    rustExternCrate = { link = "@keyword.import" },

    rustType = { link = "@type" },
    rustTrait = { link = "@type" },
    rustEnum = { link = "@type" },

    rustStorage = { link = "@type.qualifier" },
    rustDefault = { link = "@keyword" },
    rustOperator = { link = "Operator" },
    rustSigil = { link = "Operator" },
    rustSelf = { link = "@variable.builtin" },
    rustLifetime = { link = "@attribute.rust" },
    rustModPathSep = { link = "@punctuation.delimiter" },
    rustMacro = { link = "@function.macro" },
    rustMacroVariable = { link = "@variable" },
    rustMacroRepeatDelimiters = { link = "@punctuation.special" },
    rustAttribute = { link = "@attribute.rust" },
    rustDerive = { link = "@attribute.rust" },
    rustDeriveTrait = { link = "@type" },

    rustBoolean = { link = "@boolean" },
    rustConstant = { link = "@constant" },
    rustEnumVariant = { link = "@constant" },
    rustNumber = { link = "@number" },
    rustFloat = { link = "Float" },
    rustString = { link = "@string" },
    rustStringDelimiter = { link = "@string" },
    rustCharacter = { link = "Character" },
    rustModPath = { link = "@module" },
    rustIdentifier = { link = "@variable" },

    rustCommentLine = { link = "@comment" },
    rustCommentLineDoc = { link = "@comment" },
    rustCommentBlock = { link = "@comment" },
    rustCommentBlockDoc = { link = "@comment" },
    rustTodo = { link = "Todo" },

    -- Tree-sitter Rust captures.
    ["@variable.rust"] = { link = "@variable" },
    ["@variable.member.rust"] = { link = "@property" },
    ["@variable.parameter.rust"] = { link = "@parameter" },
    ["@variable.builtin.rust"] = { link = "@variable.builtin" },
    ["@constant.rust"] = { link = "@constant" },
    ["@constant.builtin.rust"] = { link = "@constant.builtin" },
    ["@boolean.rust"] = { link = "@boolean" },
    ["@number.rust"] = { link = "@number" },
    ["@number.float.rust"] = { link = "@float" },
    ["@string.rust"] = { link = "@string" },
    ["@string.escape.rust"] = { link = "@string.escape" },
    ["@character.rust"] = { link = "Character" },

    ["@type.rust"] = { link = "@type" },
    ["@type.builtin.rust"] = { link = "@type.builtin" },
    ["@module.rust"] = { link = "@module" },
    ["@attribute.rust"] = { link = "Special" },
    ["@attribute.builtin.rust"] = { link = "Special" },
    ["@label.rust"] = { link = "@label" },

    ["@function.rust"] = { link = "@function" },
    ["@function.call.rust"] = { link = "@function.call" },
    ["@function.macro.rust"] = { link = "@function.macro" },

    ["@keyword.rust"] = { link = "@keyword" },
    ["@keyword.import.rust"] = { link = "@include" },
    ["@keyword.type.rust"] = { link = "@keyword" },
    ["@keyword.function.rust"] = { link = "@keyword.function" },
    ["@keyword.modifier.rust"] = { link = "@type.qualifier" },
    ["@keyword.coroutine.rust"] = { link = "@keyword" },
    ["@keyword.exception.rust"] = { link = "@keyword" },
    ["@keyword.conditional.rust"] = { link = "@keyword.conditional" },
    ["@keyword.repeat.rust"] = { link = "@keyword.repeat" },
    ["@keyword.return.rust"] = { link = "@keyword.return" },
    ["@keyword.operator.rust"] = { link = "@keyword.operator" },
    ["@keyword.debug.rust"] = { link = "@keyword" },
    ["@operator.rust"] = { link = "Operator" },
    ["@punctuation.rust"] = { link = "@punctuation" },
    ["@punctuation.delimiter.rust"] = { link = "@punctuation.delimiter" },
    ["@punctuation.bracket.rust"] = { link = "@punctuation.bracket" },
    ["@punctuation.special.rust"] = { link = "@punctuation.special" },
    ["@comment.rust"] = { link = "@comment" },
    ["@comment.documentation.rust"] = { link = "@comment" },

    -- LSP semantic tokens link to their treesitter equivalents (no pop-in).
    ["@lsp.type.variable.rust"] = { link = "@variable.rust" },
    ["@lsp.type.parameter.rust"] = { link = "@variable.parameter.rust" },
    ["@lsp.type.property.rust"] = { link = "@variable.member.rust" },
    ["@lsp.type.struct.rust"] = { link = "@type.rust" },
    ["@lsp.type.enum.rust"] = { link = "@type.rust" },
    ["@lsp.type.enumMember.rust"] = { link = "@constant.rust" },
    ["@lsp.type.function.rust"] = { link = "@function.rust" },
    ["@lsp.type.method.rust"] = { link = "@function.call.rust" },
    ["@lsp.type.macro.rust"] = { link = "@function.macro.rust" },
    ["@lsp.type.interface.rust"] = { link = "@type.rust" },
    ["@lsp.type.typeParameter.rust"] = { link = "@type.rust" },
    ["@lsp.type.selfKeyword.rust"] = { link = "@variable.builtin.rust" },
    ["@lsp.type.lifetime.rust"] = { link = "@attribute.rust" },
  }
end

return M
