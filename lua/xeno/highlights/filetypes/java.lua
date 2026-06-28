local M = {}

function M.generate(_colors)
  return {
    -- Link Java's Vim-syntax and Tree-sitter groups to the shared core groups
    -- instead of raw palette shades, so custom themes that override intents
    -- (Conditional, Boolean, String, @keyword.*, ...) flow through to Java.

    -- Vim Java syntax (non-treesitter buffers).
    javaExternal = { link = "Include" },
    javaModuleExternal = { link = "Include" },
    javaModuleImport = { link = "Include" },
    javaModuleStmt = { link = "Statement" },
    javaStatement = { link = "Statement" },
    javaConditional = { link = "Conditional" },
    javaRepeat = { link = "Repeat" },
    javaBranch = { link = "Statement" },
    javaExceptions = { link = "Exception" },
    javaAssert = { link = "Statement" },
    javaOperator = { link = "Operator" },
    javaStorageClass = { link = "StorageClass" },
    javaMethodDecl = { link = "Function" },
    javaClassDecl = { link = "Structure" },
    javaScopeDecl = { link = "StorageClass" },
    javaConceptKind = { link = "Keyword" },

    javaType = { link = "Type" },
    javaTypedef = { link = "Typedef" },
    javaC_Java = { link = "Type" },
    javaI_Java = { link = "Type" },
    javaFuncDef = { link = "Function" },
    javaFuncDefStart = { link = "Function" },
    javaLambdaDef = { link = "Function" },
    javaLambdaDefStart = { link = "Function" },
    javaMethodRef = { link = "Function" },
    javaVarArg = { link = "Operator" },

    javaBoolean = { link = "Boolean" },
    javaConstant = { link = "Constant" },
    javaNumber = { link = "Number" },
    javaString = { link = "String" },
    javaCharacter = { link = "Character" },
    javaSpecial = { link = "Special" },
    javaSpecialChar = { link = "SpecialChar" },
    javaAnnotation = { link = "@attribute.java" },
    javaAnnotationStart = { link = "@attribute.java" },
    javaLabel = { link = "Label" },
    javaUserLabel = { link = "Label" },
    javaUserLabelRef = { link = "Label" },
    javaComment = { link = "Comment" },
    javaLineComment = { link = "Comment" },
    javaTodo = { link = "Todo" },
    javaParen = { link = "Delimiter" },
    javaParen1 = { link = "Delimiter" },
    javaParen2 = { link = "Delimiter" },
    javaBlockStart = { link = "Delimiter" },
    javaBlockOtherStart = { link = "Delimiter" },

    -- Tree-sitter Java captures.
    ["@variable.java"] = { link = "@variable" },
    ["@variable.member.java"] = { link = "@property" },
    ["@property.java"] = { link = "@property" },
    ["@parameter.java"] = { link = "@parameter" },
    ["@constant.java"] = { link = "@constant" },
    ["@constant.builtin.java"] = { link = "@constant.builtin" },
    ["@boolean.java"] = { link = "@boolean" },
    ["@number.java"] = { link = "@number" },
    ["@string.java"] = { link = "@string" },
    ["@character.java"] = { link = "Character" },

    ["@type.java"] = { link = "@type" },
    ["@type.builtin.java"] = { link = "@type.builtin" },
    ["@type.qualifier.java"] = { link = "@type.qualifier" },
    ["@constructor.java"] = { link = "@constructor" },
    ["@module.java"] = { link = "@module" },
    ["@namespace.java"] = { link = "@namespace" },
    ["@attribute.java"] = { link = "Special" },

    ["@function.java"] = { link = "@function" },
    ["@function.call.java"] = { link = "@function.call" },
    ["@function.method.java"] = { link = "@function.method" },
    ["@function.method.call.java"] = { link = "@function.method.call" },

    ["@keyword.java"] = { link = "@keyword" },
    ["@keyword.import.java"] = { link = "@include" },
    ["@keyword.function.java"] = { link = "@keyword.function" },
    ["@keyword.conditional.java"] = { link = "@keyword.conditional" },
    ["@keyword.repeat.java"] = { link = "@keyword.repeat" },
    ["@keyword.return.java"] = { link = "@keyword.return" },
    ["@keyword.exception.java"] = { link = "@keyword" },
    ["@keyword.operator.java"] = { link = "@keyword.operator" },
    ["@keyword.modifier.java"] = { link = "@type.qualifier" },
    ["@operator.java"] = { link = "Operator" },
    ["@punctuation.java"] = { link = "@punctuation" },
    ["@punctuation.delimiter.java"] = { link = "@punctuation.delimiter" },
    ["@punctuation.bracket.java"] = { link = "@punctuation.bracket" },

    -- LSP semantic tokens link to their treesitter equivalents (no pop-in).
    ["@lsp.type.class.java"] = { link = "@type.java" },
    ["@lsp.type.interface.java"] = { link = "@type.java" },
    ["@lsp.type.enum.java"] = { link = "@type.java" },
    ["@lsp.type.typeParameter.java"] = { link = "@type.java" },
    ["@lsp.type.method.java"] = { link = "@function.method.java" },
    ["@lsp.type.function.java"] = { link = "@function.java" },
    ["@lsp.type.property.java"] = { link = "@property.java" },
    ["@lsp.type.variable.java"] = { link = "@variable.java" },
    ["@lsp.type.parameter.java"] = { link = "@parameter.java" },
    ["@lsp.type.decorator.java"] = { link = "@attribute.java" },
  }
end

return M
