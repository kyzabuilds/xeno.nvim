local M = {}

function M.generate(colors)
  return {
    -- Lua variables should stay on the dim foreground level even when LSP later
    -- classifies a constant capture as a semantic variable.
    ["@variable.lua"] = { fg = colors.foreground_400 },
    ["@constant.lua"] = { link = "@variable.lua" },
    ["@lsp.type.variable.lua"] = { link = "@variable.lua" },

    -- Keep Lua Tree-sitter function captures and Lua LSP function tokens aligned
    -- so the higher-priority semantic token does not repaint builtins/calls.
    ["@function.lua"] = { fg = colors.accent_400 },
    ["@function.call.lua"] = { link = "@function.lua" },
    ["@function.builtin.lua"] = { link = "@function.lua" },
    ["@function.method.lua"] = { link = "@function.lua" },
    ["@function.method.call.lua"] = { link = "@function.lua" },
    ["@lsp.type.function.lua"] = { link = "@function.lua" },
    ["@lsp.type.method.lua"] = { link = "@function.lua" },

    -- Lua method-style members can be parsed as properties before LSP resolves
    -- them as methods/properties. Keep those paths on the Lua function color.
    ["@property.lua"] = { link = "@function.lua" },
    ["@variable.member.lua"] = { link = "@function.lua" },
    ["@lsp.type.property.lua"] = { link = "@function.lua" },
  }
end

return M
