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
