local M = {}

function M.generate(_colors)
  return {
    -- Keywords
    typescriptImport = { link = "@keyword.import" },
    typescriptExport = { link = "@keyword.import" },
    typescriptInterfaceKeyword = { link = "@keyword.type" },
    typescriptVariable = { link = "@keyword" },
    typescriptFuncKeyword = { link = "@keyword.function" },
    typescriptConditional = { link = "@keyword.conditional" },
    typescriptStatementKeyword = { link = "@keyword.return" },

    -- Functions
    typescriptFuncName = { link = "@function" },

    -- Types
    typescriptTypeReference = { link = "@type" },

    -- Variables
    typescriptImportBlock = { link = "@variable" },
    typescriptDestructureVariable = { link = "@variable" },
    typescriptCall = { link = "@variable" },
    typescriptArray = { link = "@variable" },
    typescriptConditionalParen = { link = "@variable" },
    typescriptVariableDeclaration = { link = "@variable" },

    -- These groups span both plain variables and function calls / member accesses.
    -- typescriptBlock/tsxEscJs already resolve to Normal via yats.vim; clear lets
    -- that chain stand. typescriptFuncCallArg resolves to accent_100 via yats.vim,
    -- so we force it to Normal to avoid a wrong-color flash.
    typescriptBlock = { clear = true },
    typescriptFuncCallArg = { link = "Normal" },
    tsxEscJs = { clear = true },

    -- Constants
    typescriptNull = { link = "@constant.builtin" },

    -- Members
    typescriptDOMFormProp = { link = "@variable.member" },
    typescriptObjectLabel = { link = "@property" },

    -- Mixed-capture identifiers: covers variables, functions, and more;
    -- force Normal so there is no wrong-color flash before LSP/treesitter resolves.
    typescriptIdentifierName = { link = "Normal" },

    -- typescriptGlobal normally links to Structure (accent_100); force foreground_300
    -- so there is no accent flash before @lsp.type.class.typescriptreact resolves.
    typescriptGlobal = { link = "@foreground.300" },

    -- TSX semantic tokens arrive after syntax highlighting; keep broad variable
    -- and parameter tokens neutral when their syntax group is also neutral.
    ["@lsp.type.variable.typescriptreact"] = { link = "@variable" },
    ["@lsp.type.parameter.typescriptreact"] = { link = "@variable" },
    ["@lsp.type.class.typescriptreact"] = { link = "@foreground.300" },

    -- JSX tags
    tsxTagName = { link = "@tag" },
    tsxIntrinsicTagName = { link = "@tag.builtin" },
  }
end

return M
