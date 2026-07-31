local t = require("tests.helpers")

t.describe("core.resolver", function()
  t.it("resolves bare foreground references to the closest available level", function()
    local resolver = require("xeno.core.resolver")
    local colors = {
      foreground_50 = "#f8f8f2",
      foreground_100 = "#e6e6e6",
      foreground_200 = "#cccccc",
      foreground_300 = "#999999",
      foreground_400 = "#666666",
    }

    t.eq(resolver.extract_color_key("@foreground", colors), "foreground_400")
    t.eq(resolver.resolve_value("@foreground", colors), colors.foreground_400)
  end)

  t.it("keeps bare semantic and accent references on their 500 alias when available", function()
    local resolver = require("xeno.core.resolver")
    local colors = {
      accent_400 = "#4477dd",
      accent_500 = "#3366cc",
      accent_600 = "#2255bb",
      green = "#6ee7b7",
      green_500 = "#6ee7b7",
    }

    t.eq(resolver.extract_color_key("@accent", colors), "accent_500")
    t.eq(resolver.extract_color_key("@green", colors), "green_500")
    t.eq(resolver.resolve_value("@accent", colors), colors.accent_500)
    t.eq(resolver.resolve_value("@green", colors), colors.green_500)
  end)
end)
