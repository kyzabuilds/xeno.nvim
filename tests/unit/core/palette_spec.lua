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
local ACCENT_CONTRAST_BASELINE = {
  [100] = 5.5,
  [200] = 5.0,
  [300] = 4.5,
}
local ACCENT_TEXT_LEVELS = { 100, 200, 300 }
local MIN_CONTRAST_REFERENCE = 4.5

-- background_800 sits at a fixed OKLCH lightness (0.24 dark / 0.84 light), so
-- the ratio achievable against it tops out around 15.5 / 12.8 respectively.
-- 6.0 is the largest round value whose scaled foreground_50 floor (12.0) is
-- still physically reachable in *both* variants; above ~6.4 light mode can only
-- degrade gracefully. See the extreme-value test for that path.
local SATISFIABLE_MIN_CONTRAST = 6.0

local function scaled_floor(baseline, level, min_contrast)
  local scaled = baseline[level] * (min_contrast / MIN_CONTRAST_REFERENCE)
  return math.min(21.0, math.max(1.0, scaled))
end

local function ratio_of(colors, key, bg_level)
  return utils.contrast_ratio(colors[key], colors[string.format("background_%s", bg_level)])
end

local function assert_family_floor(colors, prefix, baseline, levels, min_contrast, variant)
  for _, level in ipairs(levels) do
    local minimum = scaled_floor(baseline, level, min_contrast)
    local key = string.format("%s_%s", prefix, level)

    for _, bg_level in ipairs(TEXT_BACKGROUND_LEVELS) do
      local ratio = ratio_of(colors, key, bg_level)
      t.truthy(
        ratio >= minimum - 1e-9,
        string.format("%s %s on background_%s expected >= %.3f, got %.3f", variant, key, bg_level, minimum, ratio)
      )
    end
  end
end

local function is_hex(value)
  return type(value) == "string" and value:match("^#%x%x%x%x%x%x$") ~= nil
end

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
      t.eq(colors[key .. "_500"], colors[key], "missing semantic alias " .. key .. "_500")
    end
  end)

  t.it("maps semantic overrides onto their 500 aliases", function()
    local colors = with_variant("dark", {
      green = "#6ee7b7",
      red = "#f9a8d4",
    })

    t.eq(colors.green_500, colors.green)
    t.eq(colors.red_500, colors.red)
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

  t.it("adjusts palette saturation based on the chroma option", function()
    local config = {
      background = "#1f2335",
      accent = "#7aa2f7",
    }

    local base = with_variant("dark", config)
    local desaturated = with_variant("dark", t.test_config({ background = config.background, accent = config.accent, chroma = -0.5 }))
    local saturated = with_variant("dark", t.test_config({ background = config.background, accent = config.accent, chroma = 0.5 }))
    local grayscale = with_variant("dark", t.test_config({ background = config.background, accent = config.accent, chroma = -1.0 }))

    -- Check accent colors (usually have high chroma)
    t.truthy(t.hex_chroma(desaturated.accent_500) < t.hex_chroma(base.accent_500), "chroma -0.5 should decrease accent chroma")
    t.truthy(t.hex_chroma(saturated.accent_500) > t.hex_chroma(base.accent_500), "chroma 0.5 should increase accent chroma")
    t.approx(t.hex_chroma(grayscale.accent_500), 0, 5e-3, "chroma -1.0 should result in near-zero chroma")

    -- Check semantic colors
    t.truthy(t.hex_chroma(desaturated.red) < t.hex_chroma(base.red), "chroma -0.5 should decrease red chroma")
    t.truthy(t.hex_chroma(saturated.red) > t.hex_chroma(base.red), "chroma 0.5 should increase red chroma")
    t.approx(t.hex_chroma(grayscale.red), 0, 5e-3, "chroma -1.0 should result in near-zero chroma for red")
  end)

  t.it("adjusts palette brightness based on the lightness option while preserving text contrast", function()
    local config = {
      background = "#1f2335",
      accent = "#7aa2f7",
    }

    local base = with_variant("dark", config)
    local darker = with_variant("dark", t.test_config({ background = config.background, accent = config.accent, lightness = -0.35 }))
    local lighter = with_variant("dark", t.test_config({ background = config.background, accent = config.accent, lightness = 0.35 }))

    t.truthy(t.hex_lightness(darker.accent_500) < t.hex_lightness(base.accent_500), "lightness -0.35 should darken accent colors")
    t.truthy(t.hex_lightness(lighter.accent_500) > t.hex_lightness(base.accent_500), "lightness 0.35 should brighten accent colors")

    t.truthy(t.hex_lightness(darker.red) < t.hex_lightness(base.red), "lightness -0.35 should darken semantic colors")
    t.truthy(t.hex_lightness(lighter.red) > t.hex_lightness(base.red), "lightness 0.35 should brighten semantic colors")

    for _, colors in ipairs({ darker, lighter }) do
      for _, fg_level in ipairs(FOREGROUND_LEVELS) do
        t.truthy(
          foreground_ratio(colors, fg_level, 800) >= FOREGROUND_CONTRAST_MIN[fg_level],
          string.format("foreground_%s should remain legible on background_800 after lightness adjustments", fg_level)
        )
      end
    end
  end)

  t.it("leaves the palette untouched when min_contrast is unset", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local base = {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#7aa2f7",
        contrast = -0.3,
        _custom_colors = { fuchsia = "#ff00ff" },
      }

      local omitted = with_variant(variant, vim.deepcopy(base))
      local explicit_nil = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(base), { min_contrast = nil }))
      local invalid = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(base), { min_contrast = "seven" }))

      t.deep_eq(explicit_nil, omitted, variant .. ": explicit nil min_contrast should be a no-op")
      t.deep_eq(invalid, omitted, variant .. ": invalid min_contrast should fall back to default behavior")
    end
  end)

  t.it("reproduces the historical foreground floors when min_contrast equals the 4.5 reference", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local base = {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#7aa2f7",
        contrast = -0.6,
      }

      local omitted = with_variant(variant, vim.deepcopy(base))
      local referenced = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(base), { min_contrast = MIN_CONTRAST_REFERENCE }))

      t.deep_eq(
        family(referenced, "foreground", FOREGROUND_LEVELS),
        family(omitted, "foreground", FOREGROUND_LEVELS),
        variant .. ": min_contrast = 4.5 should reproduce the baseline foreground table"
      )
    end
  end)

  t.it("raises every foreground floor proportionally when min_contrast is set", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local colors = with_variant(variant, {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#7aa2f7",
        min_contrast = SATISFIABLE_MIN_CONTRAST,
      })

      assert_family_floor(colors, "foreground", FOREGROUND_CONTRAST_MIN, FOREGROUND_LEVELS, SATISFIABLE_MIN_CONTRAST, variant)

      -- The floor is additive: it must not undo the existing hierarchy.
      for _, level in ipairs(FOREGROUND_LEVELS) do
        t.truthy(
          ratio_of(colors, string.format("foreground_%s", level), 800) >= FOREGROUND_CONTRAST_MIN[level],
          string.format("%s foreground_%s should still clear its historical floor", variant, level)
        )
      end
    end
  end)

  t.it("applies the contrast floor to the accent text levels when min_contrast is set", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local config = {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#7aa2f7",
      }

      local unfloored = with_variant(variant, vim.deepcopy(config))
      local floored = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(config), { min_contrast = SATISFIABLE_MIN_CONTRAST }))

      assert_family_floor(floored, "accent", ACCENT_CONTRAST_BASELINE, ACCENT_TEXT_LEVELS, SATISFIABLE_MIN_CONTRAST, variant)

      -- Non-text accent levels double as background tints and must stay put.
      for _, level in ipairs({ 50, 400, 500, 600 }) do
        local key = string.format("accent_%s", level)
        t.eq(floored[key], unfloored[key], string.format("%s %s should not be contrast-floored", variant, key))
      end

      -- Floored levels must stay distinct from one another.
      t.ne(floored.accent_100, floored.accent_200, variant .. ": accent_100/200 collapsed")
      t.ne(floored.accent_200, floored.accent_300, variant .. ": accent_200/300 collapsed")
    end
  end)

  t.it("applies the accent contrast floor to custom color families", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local colors = with_variant(variant, {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#7aa2f7",
        min_contrast = SATISFIABLE_MIN_CONTRAST,
        _custom_colors = { fuchsia = "#ff00ff", moss = "#a3c98a" },
      })

      for _, name in ipairs({ "fuchsia", "moss" }) do
        assert_family_floor(colors, name, ACCENT_CONTRAST_BASELINE, ACCENT_TEXT_LEVELS, SATISFIABLE_MIN_CONTRAST, variant)
      end
    end
  end)

  t.it("reads min_contrast as a top-level setup option, not a properties knob", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local background = variant == "dark" and "#1f2335" or "#d9e1f2"

      t.reset_state()
      vim.o.background = variant
      local utils_module = require("xeno.core.utils")

      -- Top level survives normalization, keeps its value, and reaches the palette.
      local top_level = utils_module.normalize_properties({
        background = background,
        accent = "#7aa2f7",
        min_contrast = SATISFIABLE_MIN_CONTRAST,
        properties = { contrast = -0.3 },
      })
      t.eq(top_level.min_contrast, SATISFIABLE_MIN_CONTRAST)
      t.eq(top_level.contrast, -0.3, "properties knobs should still be lifted")

      local applied = require("xeno.core.palette").generate_palette(top_level)
      assert_family_floor(applied, "accent", ACCENT_CONTRAST_BASELINE, ACCENT_TEXT_LEVELS, SATISFIABLE_MIN_CONTRAST, variant)

      -- Nesting it under `properties` is not a supported position.
      local nested = utils_module.normalize_properties({
        background = background,
        accent = "#7aa2f7",
        properties = { min_contrast = SATISFIABLE_MIN_CONTRAST },
      })
      t.eq(nested.min_contrast, nil, variant .. ": properties.min_contrast should not be lifted")
    end
  end)

  t.it("clamps out-of-range min_contrast values instead of erroring", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local config = {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#ff0000",
      }

      local clamped_high = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(config), { min_contrast = 99.0 }))
      local at_max = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(config), { min_contrast = 21.0 }))
      local clamped_low = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(config), { min_contrast = 0.1 }))
      local at_min = with_variant(variant, vim.tbl_extend("force", vim.deepcopy(config), { min_contrast = 1.0 }))

      t.deep_eq(clamped_high, at_max, variant .. ": min_contrast above 21.0 should clamp")
      t.deep_eq(clamped_low, at_min, variant .. ": min_contrast below 1.0 should clamp")
    end
  end)

  t.it("degrades gracefully for unreachable min_contrast values on a saturated hue", function()
    for _, variant in ipairs({ "dark", "light" }) do
      local colors = with_variant(variant, {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#ff0000",
        min_contrast = 21.0,
        _custom_colors = { fuchsia = "#ff00ff" },
      })

      for _, spec in ipairs({
        { prefix = "foreground", levels = FOREGROUND_LEVELS },
        { prefix = "accent", levels = ACCENT_LEVELS },
        { prefix = "fuchsia", levels = ACCENT_LEVELS },
      }) do
        for _, level in ipairs(spec.levels) do
          local key = string.format("%s_%s", spec.prefix, level)
          t.truthy(is_hex(colors[key]), string.format("%s %s should still be a valid hex, got %s", variant, key, tostring(colors[key])))
        end
      end

      -- Best effort still means "as far as the gamut allows", not "unchanged".
      local relaxed = with_variant(variant, {
        background = variant == "dark" and "#1f2335" or "#d9e1f2",
        accent = "#ff0000",
      })
      t.truthy(
        ratio_of(colors, "accent_300", 800) > ratio_of(relaxed, "accent_300", 800),
        variant .. ": an unreachable floor should still push accent_300 toward more contrast"
      )
    end
  end)
end)
