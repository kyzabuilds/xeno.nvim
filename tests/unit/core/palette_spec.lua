local t = require("tests.helpers")
local utils = require("xeno.core.utils")

local FOREGROUND_LEVELS = { 50, 100, 200, 300, 400 }
local BACKGROUND_LEVELS = { 500, 600, 700, 800, 900, 950 }
local ACCENT_LEVELS = { 50, 100, 200, 300, 400, 500, 600 }
local SEMANTIC_KEYS = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }
local TEXT_BACKGROUND_LEVELS = { 800, 900, 950 }
local FOREGROUND_CONTRAST_MIN = {
  [50] = 9.0,
  [100] = 8.8,
  [200] = 8.0,
  [300] = 6.0,
  [400] = 4.5,
}

local function family(colors, prefix, levels)
  return t.pick(colors, t.family(prefix, levels))
end

local function with_variant(background, config)
  t.reset_state()
  vim.o.background = background
  return require("xeno.core.palette").generate_palette(config or {})
end

local function foreground_ratio(colors, fg_level, bg_level)
  return utils.contrast_ratio(colors[string.format("foreground_%s", fg_level)], colors[string.format("background_%s", bg_level)])
end

t.describe("core.palette", function()
  t.it("generates exact family keys and semantic colors for dark mode", function()
    local colors = with_variant("dark")

    t.deep_eq(
      t.sorted_keys(colors, function(key)
        return key:match("^foreground_")
      end),
      t.family("foreground", FOREGROUND_LEVELS)
    )
    t.deep_eq(
      t.sorted_keys(colors, function(key)
        return key:match("^background_")
      end),
      t.family("background", BACKGROUND_LEVELS)
    )
    t.deep_eq(
      t.sorted_keys(colors, function(key)
        return key:match("^accent_")
      end),
      t.family("accent", ACCENT_LEVELS)
    )

    for _, key in ipairs(SEMANTIC_KEYS) do
      t.truthy(colors[key], "missing semantic color " .. key)
    end
  end)

  t.it("is deterministic for a fixed config and variant", function()
    local config = {
      background = "#101820",
      foreground = "#d8dee9",
      accent = "#7aa2f7",
      contrast = 0.25,
    }

    local first = with_variant("dark", config)
    local second = with_variant("dark", vim.deepcopy(config))

    t.deep_eq(first, second)
  end)

  t.it("derives foreground from background when foreground is omitted", function()
    local background = "#1f2335"
    local omitted = with_variant("dark", { background = background })
    local explicit = with_variant("dark", { background = background, foreground = background })

    t.deep_eq(family(omitted, "foreground", FOREGROUND_LEVELS), family(explicit, "foreground", FOREGROUND_LEVELS))
  end)

  t.it("uses an explicit valid foreground instead of the background-derived seed", function()
    local background = "#1f2335"
    local derived = with_variant("dark", { background = background })
    local explicit = with_variant("dark", { background = background, foreground = "#f0d197" })

    t.ne(explicit.foreground_50, derived.foreground_50)
    t.deep_eq(family(explicit, "background", BACKGROUND_LEVELS), family(derived, "background", BACKGROUND_LEVELS))
  end)

  t.it("falls back to derived foreground behavior when explicit foreground is invalid", function()
    local config = { background = "#1f2335" }
    local derived = with_variant("dark", config)
    local invalid = with_variant("dark", { background = config.background, foreground = "zzzzzz" })

    t.deep_eq(family(invalid, "foreground", FOREGROUND_LEVELS), family(derived, "foreground", FOREGROUND_LEVELS))
  end)

  t.it("falls back to the default background seed when background is invalid", function()
    local default_palette = with_variant("dark")
    local invalid = with_variant("dark", { background = "zzzzzz" })

    t.deep_eq(family(invalid, "background", BACKGROUND_LEVELS), family(default_palette, "background", BACKGROUND_LEVELS))
    t.deep_eq(family(invalid, "foreground", FOREGROUND_LEVELS), family(default_palette, "foreground", FOREGROUND_LEVELS))
  end)

  t.it("falls back to the default accent seed when accent is invalid", function()
    local default_palette = with_variant("dark")
    local invalid = with_variant("dark", { accent = "zzzzzz" })

    t.deep_eq(family(invalid, "accent", ACCENT_LEVELS), family(default_palette, "accent", ACCENT_LEVELS))
  end)

  t.it("generates complete palettes for dark and light variants", function()
    local dark = with_variant("dark")
    local light = with_variant("light")

    for _, key in ipairs(vim.list_extend(vim.list_extend(
      t.family("foreground", FOREGROUND_LEVELS),
      t.family("background", BACKGROUND_LEVELS)
    ), t.family("accent", ACCENT_LEVELS))) do
      t.truthy(dark[key], "missing dark key " .. key)
      t.truthy(light[key], "missing light key " .. key)
    end
  end)

  t.it("preserves current dark-mode semantic orientation", function()
    local colors = with_variant("dark")
    t.truthy(t.hex_lightness(colors.foreground_50) > t.hex_lightness(colors.background_950))
  end)

  t.it("preserves current light-mode semantic orientation", function()
    local colors = with_variant("light")
    t.truthy(t.hex_lightness(colors.foreground_50) < t.hex_lightness(colors.background_950))
  end)

  t.it("keeps foreground emphasis ordered for dark and light variants", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local colors = with_variant(variant, { background = variant == "dark" and "#1f2335" or "#d9e1f2" })
      local previous_lightness = nil
      local previous_ratio = nil
      local previous_level = nil

      for _, level in ipairs(FOREGROUND_LEVELS) do
        local lightness = t.hex_lightness(colors[string.format("foreground_%s", level)])
        local ratio = foreground_ratio(colors, level, 800)

        if previous_lightness ~= nil then
          if variant == "dark" then
            t.truthy(previous_lightness > lightness, string.format("%s foreground_%s should be lighter than foreground_%s", variant, previous_level, level))
          else
            t.truthy(previous_lightness < lightness, string.format("%s foreground_%s should be darker than foreground_%s", variant, previous_level, level))
          end

          t.truthy(previous_ratio > ratio, string.format("%s contrast hierarchy should decrease from foreground_%s to foreground_%s", variant, previous_level, level))
        end

        previous_lightness = lightness
        previous_ratio = ratio
        previous_level = level
      end
    end
  end)

  t.it("preserves foreground legibility when surface contrast is reduced in dark mode", function()
    local base = with_variant("dark", { background = "#1f2335", contrast = 0 })
    local reduced = with_variant("dark", { background = "#1f2335", contrast = -0.6 })

    t.truthy(
      math.abs(t.hex_lightness(base.background_800) - t.hex_lightness(base.background_950))
        > math.abs(t.hex_lightness(reduced.background_800) - t.hex_lightness(reduced.background_950)),
      "background surfaces should become lower contrast"
    )
    t.truthy(
      t.hex_lightness(reduced.foreground_300) > t.hex_lightness(base.foreground_300),
      "dark foreground should get lighter to compensate"
    )
    t.truthy(
      foreground_ratio(reduced, 400, 800) >= FOREGROUND_CONTRAST_MIN[400],
      "foreground_400 should stay legible on background_800"
    )
  end)

  t.it("preserves foreground legibility when surface contrast is reduced in light mode", function()
    local base = with_variant("light", { background = "#d9e1f2", contrast = 0 })
    local reduced = with_variant("light", { background = "#d9e1f2", contrast = -0.6 })

    t.truthy(
      math.abs(t.hex_lightness(base.background_800) - t.hex_lightness(base.background_950))
        > math.abs(t.hex_lightness(reduced.background_800) - t.hex_lightness(reduced.background_950)),
      "background surfaces should become lower contrast"
    )
    t.truthy(
      t.hex_lightness(reduced.foreground_300) < t.hex_lightness(base.foreground_300),
      "light foreground should get darker to compensate"
    )
    t.truthy(
      foreground_ratio(reduced, 400, 800) >= FOREGROUND_CONTRAST_MIN[400],
      "foreground_400 should stay legible on background_800"
    )
  end)

  t.it("enforces explicit foreground contrast thresholds against text backgrounds in dark and light themes", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local colors = with_variant(variant, {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        contrast = -0.6,
      })

      for _, fg_level in ipairs(FOREGROUND_LEVELS) do
        for _, bg_level in ipairs(TEXT_BACKGROUND_LEVELS) do
          local ratio = foreground_ratio(colors, fg_level, bg_level)
          local min_ratio = FOREGROUND_CONTRAST_MIN[fg_level]
          t.truthy(
            ratio >= min_ratio,
            string.format("%s foreground_%s on background_%s expected >= %.1f, got %.3f", variant, fg_level, bg_level, min_ratio, ratio)
          )
        end
      end
    end
  end)

  t.it("keeps explicit foreground seeds distinct while preserving contrast thresholds", function()
    local derived = with_variant("dark", {
      background = "#1f2335",
      contrast = -0.6,
    })
    local explicit = with_variant("dark", {
      background = "#1f2335",
      foreground = "#f0d197",
      contrast = -0.6,
    })

    t.ne(explicit.foreground_100, derived.foreground_100)

    for _, fg_level in ipairs(FOREGROUND_LEVELS) do
      t.truthy(
        foreground_ratio(explicit, fg_level, 800) >= FOREGROUND_CONTRAST_MIN[fg_level],
        string.format("explicit foreground_%s should satisfy minimum contrast", fg_level)
      )
    end
  end)
end)
