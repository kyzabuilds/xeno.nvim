local t = require("tests.helpers")

local function setup_theme()
  t.reset_state()
  vim.o.background = "dark"

  local xeno = require("xeno")
  xeno.setup(t.test_config({
    background = "#1f2335",
    accent = "#7aa2f7",
  }))

  return xeno
end

t.describe("applied highlights", function()
  t.it("applies core editor groups from the generated palette", function()
    local xeno = setup_theme()

    t.eq(t.get_hl("NormalFloat").bg, xeno.colors.background_900)
    t.eq(t.get_hl("NormalFloat").fg, xeno.colors.foreground_100)
    t.eq(t.get_hl("StatusLine").bg, xeno.colors.background_950)
    t.eq(t.get_hl("StatusLine").fg, xeno.colors.foreground_100)
    t.eq(t.get_hl("LineNr").fg, xeno.colors.foreground_400)
    t.eq(t.get_hl("Folded").bg, xeno.colors.background_900)
    t.eq(t.get_hl("Folded").fg, xeno.colors.foreground_200)
    t.eq(t.get_hl("InlayHints").fg, xeno.colors.foreground_400)
  end)

  t.it("applies syntax and palette reference groups", function()
    local xeno = setup_theme()

    t.eq(t.get_hl("Comment").fg, xeno.colors.foreground_400)
    t.eq(t.get_hl("Identifier").fg, xeno.colors.foreground_200)
    t.eq(t.get_hl("Function").fg, xeno.colors.foreground_100)
    t.eq(t.get_hl("@parameter").fg, xeno.colors.foreground_400)
    t.eq(t.get_hl("@punctuation").fg, xeno.colors.foreground_300)

    t.eq(t.get_hl("@foreground.100").fg, xeno.colors.foreground_100)
    t.eq(t.get_hl("@background.950").bg, xeno.colors.background_950)
    t.eq(t.get_hl("@accent.500").fg, xeno.colors.accent_500)
  end)

  t.it("keeps TSX semantic variables neutral to avoid LSP pop-in", function()
    setup_theme()

    t.eq(t.get_hl("@lsp.type.variable").fg, t.get_hl("@variable").fg)
    t.eq(t.get_hl("@lsp.type.parameter").fg, t.get_hl("@parameter").fg)
    t.eq(t.get_hl("@lsp.type.variable.typescriptreact").fg, t.get_hl("Normal").fg)
    t.eq(t.get_hl("@lsp.type.parameter.typescriptreact").fg, t.get_hl("Normal").fg)
  end)

  t.it("aligns Lua function treesitter and LSP groups", function()
    local xeno = setup_theme()

    t.eq(t.get_hl("@variable.lua").fg, xeno.colors.foreground_400)
    t.eq(t.get_hl("@constant.lua").fg, xeno.colors.foreground_400)
    t.eq(t.get_hl("@lsp.type.variable.lua").fg, xeno.colors.foreground_400)
    t.eq(t.get_hl("@function.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@function.call.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@function.builtin.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@function.method.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@function.method.call.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@lsp.type.function.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@lsp.type.method.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@property.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@variable.member.lua").fg, xeno.colors.accent_400)
    t.eq(t.get_hl("@lsp.type.property.lua").fg, xeno.colors.accent_400)
  end)

  t.it("links Java-specific groups to shared core groups", function()
    setup_theme()

    local function same(group, target)
      t.eq(t.get_hl(group).fg, t.get_hl(target).fg, group .. " -> " .. target)
    end

    same("javaExternal", "Include")
    same("javaScopeDecl", "StorageClass")
    same("javaType", "Type")
    same("javaFuncDef", "Function")
    same("javaAnnotation", "Special")
    same("javaBoolean", "Boolean")
    same("javaNumber", "Number")
    same("@variable.java", "@variable")
    same("@function.method.call.java", "@function.method.call")
    same("@keyword.modifier.java", "@type.qualifier")
    same("@boolean.java", "@boolean")
    same("@number.java", "@number")
    same("@lsp.type.method.java", "@function.method")
  end)

  t.it("links C-specific groups to shared core groups", function()
    setup_theme()

    local function same(group, target)
      t.eq(t.get_hl(group).fg, t.get_hl(target).fg, group .. " -> " .. target)
    end

    same("cInclude", "Include")
    same("cDefine", "Define")
    same("cPreCondit", "PreCondit")
    same("cStatement", "Statement")
    same("cConditional", "Conditional")
    same("cRepeat", "Repeat")
    same("cStructure", "Structure")
    same("cType", "Type")
    same("cStorageClass", "StorageClass")
    same("cTypeQualifier", "StorageClass")
    same("cFunctionSpec", "StorageClass")
    same("cFunction", "Function")
    same("cConstant", "Constant")
    same("cNumber", "Number")
    same("cString", "String")
    same("cComment", "Comment")
    t.truthy(t.get_hl("cComment").italic)
    same("cTodo", "Todo")
    t.truthy(t.get_hl("cTodo").bold)
    t.truthy(t.get_hl("cTodo").italic)

    same("@variable.c", "@variable")
    same("@variable.member.c", "@property")
    same("@parameter.c", "@parameter")
    same("@variable.parameter.c", "@parameter")
    same("@constant.macro.c", "@constant.macro")
    same("@boolean.c", "@boolean")
    same("@type.c", "@type")
    same("@type.qualifier.c", "@type.qualifier")
    same("@function.call.c", "@function.call")
    same("@function.macro.c", "@function.macro")
    same("@keyword.type.c", "@keyword")
    same("@keyword.directive.c", "PreProc")
    same("@keyword.directive.define.c", "Define")
    same("@keyword.modifier.c", "@type.qualifier")
    same("@keyword.return.c", "@keyword.return")
    same("@number.c", "@number")
    same("@string.c", "@string")
    same("@lsp.type.function.c", "@function")
  end)

  t.it("links Rust-specific groups to shared core groups", function()
    setup_theme()

    local function same(group, target)
      t.eq(t.get_hl(group).fg, t.get_hl(target).fg, group .. " -> " .. target)
    end

    same("rustConditional", "@keyword.conditional")
    same("rustRepeat", "@keyword.repeat")
    same("rustKeyword", "@keyword")
    same("rustStructure", "Structure")
    same("rustFuncName", "@function")
    same("rustFuncCall", "@function.call")
    same("rustType", "@type")
    same("rustTrait", "@type")
    same("rustStorage", "@type.qualifier")
    same("rustBoolean", "@boolean")
    same("rustNumber", "@number")
    same("rustString", "@string")
    same("rustCharacter", "Character")
    same("rustAttribute", "Special")
    same("rustCommentLine", "@comment")
    t.truthy(t.get_hl("rustCommentLine").italic)
    same("rustTodo", "Todo")
    t.truthy(t.get_hl("rustTodo").bold)
    t.truthy(t.get_hl("rustTodo").italic)

    same("@variable.rust", "@variable")
    same("@variable.member.rust", "@property")
    same("@variable.parameter.rust", "@parameter")
    t.truthy(t.get_hl("@variable.parameter.rust").italic)
    same("@constant.rust", "@constant")
    same("@boolean.rust", "@boolean")
    same("@number.rust", "@number")
    same("@string.rust", "@string")
    same("@type.rust", "@type")
    same("@type.builtin.rust", "@type.builtin")
    same("@function.rust", "@function")
    same("@function.call.rust", "@function.call")
    same("@function.macro.rust", "@function.macro")
    same("@keyword.rust", "@keyword")
    same("@keyword.import.rust", "@include")
    same("@keyword.type.rust", "@keyword")
    same("@keyword.modifier.rust", "@type.qualifier")
    same("@keyword.function.rust", "@keyword.function")
    same("@keyword.return.rust", "@keyword.return")
    same("@lsp.type.function.rust", "@function")
    same("@lsp.type.struct.rust", "@type")
    same("@lsp.type.enumMember.rust", "@constant")
  end)

  t.it("resolves semantic shorthand references via the 500 alias", function()
    t.reset_state()
    vim.o.background = "dark"

    local xeno = require("xeno")
    xeno.setup(t.test_config({
      background = "#1f2335",
      accent = "#7aa2f7",
      green = "#6ee7b7",
      highlights = {
        syntax = {
          Number = { fg = "@green" },
        },
      },
    }))

    t.eq(t.get_hl("Number").fg, xeno.colors.green)
    t.eq(xeno.colors.green_500, xeno.colors.green)
  end)

  t.it("preserves @-prefixed highlight links while resolving real custom colors", function()
    t.reset_state()
    vim.o.background = "dark"

    local xeno = require("xeno")
    xeno.color("lavender_mist", "#e0bbff")
    xeno.setup(t.test_config({
      background = "#1f2335",
      accent = "#7aa2f7",
      highlights = {
        syntax = {
          ["@punctuation"] = { fg = "#a5b4fc" },
          ["@punctuation.bracket"] = { link = "@punctuation" },
          ["@variable"] = { fg = "#cdd6f4" },
          ["@lsp.type.variable"] = { link = "@variable" },
          Identifier = { fg = "@lavender_mist" },
        },
      },
    }))

    t.eq(t.get_hl("@punctuation").fg, "#a5b4fc")
    t.eq(t.get_hl("@punctuation.bracket").fg, "#a5b4fc")
    t.eq(t.get_hl("@lsp.type.variable").fg, "#cdd6f4")
    t.eq(t.get_hl("Identifier").fg, xeno.colors.lavender_mist_500)
  end)

  t.it("applies plugin highlight consumers that depend on palette semantics", function()
    local xeno = setup_theme()

    t.eq(t.get_hl("BufferLineBufferSelected").bg, xeno.colors.background_900)
    t.eq(t.get_hl("BufferLineBufferSelected").fg, xeno.colors.foreground_50)
    t.eq(t.get_hl("GrugFarNormal").fg, xeno.colors.foreground_100)
    t.eq(t.get_hl("MarkviewPalette0").bg, xeno.colors.background_900)
    t.eq(t.get_hl("MarkviewPalette0").fg, xeno.colors.foreground_300)
    t.eq(t.get_hl("NeoTreeNormal").bg, xeno.colors.background_900)
    t.eq(t.get_hl("NeoTreeNormal").fg, xeno.colors.foreground_200)
    t.eq(t.get_hl("NvimTreeNormal").bg, xeno.colors.background_900)
    t.eq(t.get_hl("NvimTreeNormal").fg, xeno.colors.foreground_100)
  end)
end)
