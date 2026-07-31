local t = require("tests.helpers")
local utils = require("xeno.core.utils")

t.describe("core.utils", function()
  t.it("hex2rgb supports full and shorthand hex formats", function()
    t.deep_eq({ utils.hex2rgb("#7AA2F7") }, { 122, 162, 247 })
    t.deep_eq({ utils.hex2rgb("7AA2F7") }, { 122, 162, 247 })
    t.deep_eq({ utils.hex2rgb("#bad") }, { 187, 170, 221 })
    t.deep_eq({ utils.hex2rgb("bad") }, { 187, 170, 221 })
  end)

  t.it("hex2rgb rejects invalid values", function()
    t.deep_eq({ utils.hex2rgb("zzzzzz") }, { nil, nil, nil })
    t.deep_eq({ utils.hex2rgb(12) }, { nil, nil, nil })
  end)

  t.it("rgb2hex returns canonical lowercase formatting", function()
    t.eq(utils.rgb2hex(15.9, 160.4, 59.8), "#0fa03b")
  end)

  t.it("rgb2hex falls back to black when any component is nil", function()
    t.eq(utils.rgb2hex(nil, 10, 20), "#000000")
    t.eq(utils.rgb2hex(10, nil, 20), "#000000")
    t.eq(utils.rgb2hex(10, 20, nil), "#000000")
  end)

  t.it("rgb_clamp keeps values inside byte range", function()
    t.deep_eq({ utils.rgb_clamp(-10, 12.5, 999) }, { 0, 12.5, 255 })
    t.deep_eq({ utils.rgb_clamp(nil, 12, 24) }, { 0, 0, 0 })
  end)

  t.it("hex2oklch returns nil outputs for invalid input", function()
    t.deep_eq({ utils.hex2oklch("zzzzzz") }, { nil, nil, nil })
  end)

  t.it("oklch conversion is approximately stable for valid colors", function()
    local seed = "#7aa2f7"
    local L, C, H = utils.hex2oklch(seed)
    local roundtrip = utils.oklch2hex(L, C, H)
    local dr, dg, db = t.hex_channel_distance(seed, roundtrip)

    t.truthy(L and C and H)
    t.truthy(roundtrip:match("^#%x%x%x%x%x%x$"))
    t.truthy(dr <= 3 and dg <= 3 and db <= 3, string.format("roundtrip drift too large: %s -> %s", seed, roundtrip))
  end)

  t.it("relative_luminance matches wcag anchor cases", function()
    t.approx(utils.relative_luminance("#000000"), 0, 1e-9)
    t.approx(utils.relative_luminance("#ffffff"), 1, 1e-9)
    t.eq(utils.relative_luminance("zzzzzz"), nil)
  end)

  t.it("contrast_ratio matches wcag anchor cases", function()
    t.approx(utils.contrast_ratio("#000000", "#ffffff"), 21, 1e-9)
    t.approx(utils.contrast_ratio("#ffffff", "#000000"), 21, 1e-9)
    t.approx(utils.contrast_ratio("#777777", "#777777"), 1, 1e-9)
    t.eq(utils.contrast_ratio("zzzzzz", "#ffffff"), nil)
  end)
end)
