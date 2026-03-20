local t = require("tests.helpers")

local function read_file(path)
  local file = assert(io.open(path, "r"))
  local content = file:read("*a")
  file:close()
  return content
end

local function eq_hex(actual, expected, message)
  t.eq(actual and actual:upper(), expected and expected:upper(), message)
end

local function palette_for(variant, config)
  local previous = vim.o.background
  vim.o.background = variant
  local colors = require("xeno.core.palette").generate_palette(config)
  vim.o.background = previous
  return colors
end

local function opaque_for(variant, base_color, opacity, palette)
  local previous = vim.o.background
  vim.o.background = variant
  local color = require("xeno.core.utils").opaque(base_color, opacity, nil, palette)
  vim.o.background = previous
  return color
end

local function export_dir()
  local dir = "/tmp/xeno.nvim-export-tests"
  vim.fn.mkdir(dir, "p")
  return dir
end

t.describe("export pipeline", function()
  t.it("exports a standalone lua theme that preserves references, links, and variant switching", function()
    t.reset_state()
    vim.o.background = "dark"

    local xeno = require("xeno")
    xeno.color("brand", "#b48ead")
    xeno.color("unused", "#ff6b6b")

    local config = t.test_config({
      background = "#1f2335",
      accent = "#7aa2f7",
      highlights = {
        editor = {
          Visual = { bg = "@brand.500", fg = "@foreground.100" },
          IncSearch = { fg = "red", bg = { from = "Visual" }, bold = true },
        },
        syntax = {
          String = { fg = "@brand.400" },
        },
      },
    })

    xeno.setup(config)

    local exported = assert(xeno.export({
      format = "lua",
      dir = export_dir(),
    }))
    local content = read_file(exported.path)

    t.truthy(content:find("brand_400", 1, true))
    t.truthy(content:find("brand_500", 1, true))
    t.falsy(content:find("unused_500", 1, true))
    t.truthy(content:find("background_600_005", 1, true))
    t.truthy(content:find("hi('@string', { link = 'String' })", 1, true))

    local palette_config = {
      background = config.background,
      accent = config.accent,
      _custom_colors = {
        brand = "#b48ead",
        unused = "#ff6b6b",
      },
    }
    local dark_palette = palette_for("dark", palette_config)
    local light_palette = palette_for("light", palette_config)

    t.reset_state()
    vim.o.background = "dark"
    dofile(exported.path)

    eq_hex(t.get_hl("Visual").bg, dark_palette.brand_500)
    eq_hex(t.get_hl("Visual").fg, dark_palette.foreground_100)
    eq_hex(t.get_hl("IncSearch").bg, dark_palette.brand_500)
    eq_hex(t.get_hl("IncSearch").fg, dark_palette.red)
    t.truthy(t.get_hl("IncSearch").bold)
    eq_hex(t.get_hl("String").fg, dark_palette.brand_400)

    vim.o.background = "light"
    vim.cmd("doautocmd OptionSet background")

    eq_hex(t.get_hl("Visual").bg, light_palette.brand_500)
    eq_hex(t.get_hl("Visual").fg, light_palette.foreground_100)
    eq_hex(t.get_hl("IncSearch").bg, light_palette.brand_500)
    eq_hex(t.get_hl("IncSearch").fg, light_palette.red)
    eq_hex(t.get_hl("String").fg, light_palette.brand_400)
  end)

  t.it("exports a theme with filetype-specific highlights and winhighlight setup", function()
    t.reset_state()
    vim.o.background = "dark"

    local xeno = require("xeno")
    local config = t.test_config({
      background = "#1f2335",
      accent = "#7aa2f7",
    })

    xeno.setup(config)

    -- Built-in neo-tree plugin provides a filetype highlight by default
    t.truthy(xeno.ft["neo-tree"], "neo-tree filetype highlight should be present")

    local exported = assert(xeno.export({
      format = "lua",
      dir = export_dir(),
    }))
    local content = read_file(exported.path)

    -- Check for filetype highlights and winhighlight setup in exported content
    t.truthy(content:find("hi('NeoTreeVisual'", 1, true), "Should have NeoTreeVisual highlight")
    t.truthy(content:find("ft_map['neo-tree'] = 'Visual:NeoTreeVisual'", 1, true), "Should have ft_map entry")
    t.truthy(content:find("xeno_ft_exported", 1, true), "Should have ft augroup")

    -- Test the exported theme behavior
    t.reset_state()
    vim.o.background = "dark"
    dofile(exported.path)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "filetype", "neo-tree")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    
    -- Explicitly trigger FileType to ensure autocmd fires
    vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
    
    -- Wait for schedule to apply winhighlight
    vim.wait(100, function() return vim.wo.winhighlight ~= "" end)
    
    t.eq(vim.wo.winhighlight, "Visual:NeoTreeVisual", "winhighlight should be set for neo-tree")
    t.truthy(t.get_hl("NeoTreeVisual").bg, "NeoTreeVisual highlight should be defined")
  end)

  t.it("exports opaque plugin highlight references for the active variant", function()
    t.reset_state()
    vim.o.background = "dark"

    local xeno = require("xeno")
    local config = t.test_config({
      background = "#1f2335",
      accent = "#7aa2f7",
    })

    xeno.setup(config)

    local exported = assert(xeno.export({
      format = "lua",
      dir = export_dir(),
    }))
    local content = read_file(exported.path)

    t.truthy(content:find('foreground_400_020 = "', 1, true), "Should export foreground_400_020 for dark variant")
    t.truthy(content:find('foreground_400_030 = "', 1, true), "Should export foreground_400_030 for dark variant")
    t.truthy(content:find('foreground_400_040 = "', 1, true), "Should export foreground_400_040 for dark variant")
    t.truthy(content:find('foreground_400_070 = "', 1, true), "Should export foreground_400_070 for dark variant")
    t.truthy(content:find('accent_500_020 = "', 1, true), "Should export accent_500_020 for dark variant")
    t.truthy(content:find('accent_500_025 = "', 1, true), "Should export accent_500_025 for dark variant")

    local dark_palette = palette_for("dark", {
      background = config.background,
      accent = config.accent,
    })

    t.reset_state()
    vim.o.background = "dark"
    dofile(exported.path)

    eq_hex(t.get_hl("GlanceIndent").fg, opaque_for("dark", dark_palette.foreground_400, 0.20, dark_palette))
    eq_hex(t.get_hl("GrugFarSelection").bg, opaque_for("dark", dark_palette.accent_500, 0.20, dark_palette))
    eq_hex(t.get_hl("GrugFarVisualBufrange").bg, opaque_for("dark", dark_palette.accent_500, 0.25, dark_palette))
    eq_hex(t.get_hl("IblChar").fg, opaque_for("dark", dark_palette.foreground_400, 0.30, dark_palette))
    eq_hex(t.get_hl("IblIndent").fg, opaque_for("dark", dark_palette.foreground_400, 0.30, dark_palette))
    eq_hex(t.get_hl("IblScope").fg, opaque_for("dark", dark_palette.foreground_400, 0.70, dark_palette))
    eq_hex(t.get_hl("IndentLine").fg, opaque_for("dark", dark_palette.foreground_400, 0.30, dark_palette))
    eq_hex(t.get_hl("IndentLineCurrent").fg, opaque_for("dark", dark_palette.foreground_400, 0.70, dark_palette))
    eq_hex(t.get_hl("NeoTreeIndentMarker").fg, opaque_for("dark", dark_palette.foreground_400, 0.40, dark_palette))
    eq_hex(t.get_hl("NvimTreeIndentMarker").fg, opaque_for("dark", dark_palette.foreground_400, 0.40, dark_palette))
    t.truthy(t.get_hl("IblScope").nocombine, "IblScope should preserve nocombine")
    t.truthy(t.get_hl("NeoTreeIndentMarker").nocombine, "NeoTreeIndentMarker should preserve nocombine")
    t.truthy(t.get_hl("NvimTreeIndentMarker").nocombine, "NvimTreeIndentMarker should preserve nocombine")
  end)
end)
