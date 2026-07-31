local t = require("tests.helpers")

t.describe("xeno.setup", function()
  t.it("runs headlessly, populates colors, and applies Normal", function()
    t.reset_state()
    vim.o.background = "dark"

    local xeno = require("xeno")
    xeno.setup(t.test_config({
      background = "#1f2335",
      accent = "#7aa2f7",
    }))

    t.truthy(xeno.colors)
    t.truthy(xeno.colors.background_950)
    t.truthy(xeno.colors.foreground_50)

    local normal = t.get_hl("Normal")
    t.eq(normal.bg, xeno.colors.background_950)
    t.eq(normal.fg, xeno.colors.foreground_50)
  end)
end)
