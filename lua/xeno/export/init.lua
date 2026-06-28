local M = {}

local utils = require("xeno.core.utils")
local export_utils = require("xeno.export.utils")
local lua_formatter = require("xeno.export.formatters.lua")

local fmt = string.format

-- Simplified export configuration
local DEFAULT_EXPORT_CONFIG = {
  format = "lua",
  dir = "~/.config/nvim/colors/",
}

-- Validate export configuration
local function validate_export_config(config)
  config = config or {}

  -- Validate format
  if config.format and config.format ~= "lua" then
    return nil, fmt("Invalid format '%s'. Only 'lua' export is supported", config.format)
  end

  -- Validate output directory exists or can be created
  if config.dir then
    local expanded_dir = vim.fn.expand(config.dir)
    if not export_utils.ensure_directory(expanded_dir) then
      return nil, fmt("Cannot create or access output directory: %s", expanded_dir)
    end
  end

  return true
end

local function normalize_color_reference_name(value)
  if type(value) ~= "string" then
    return nil
  end

  if value:match("^@") then
    return value:sub(2):gsub("%.", "_")
  end

  if value:match("^[%a_][%w_]*$") then
    return value
  end

  return nil
end

-- Extract which colors are actually used in the resolved highlights and track named color references
local function extract_used_colors_from_highlights(highlights)
  local used_colors = {}
  local used_named_colors = {}

  local function track_value(value)
    if type(value) ~= "string" then
      return
    end

    if value:match("^#[0-9a-fA-F]+$") then
      used_colors[value:upper()] = true
      return
    end

    local normalized_name = normalize_color_reference_name(value)
    if normalized_name then
      used_named_colors[normalized_name] = true
    end
  end

  for group_name, attrs in pairs(highlights) do
    track_value(attrs.fg)
    track_value(attrs.bg)
    track_value(attrs.sp)
  end

  return used_colors, used_named_colors
end

-- Detect custom color references in user configuration before resolution
local function extract_custom_color_references(config)
  local used_custom_colors = {}

  local function scan_value(value)
    if type(value) == "string" then
      -- Match custom color references like @my_color or @my_color.500
      local color_name = value:match("^@([%w_]+)")
      if color_name then
        used_custom_colors[color_name] = true
      end
    elseif type(value) == "table" then
      for k, v in pairs(value) do
        scan_value(v)
      end
    end
  end

  -- Scan all sections of the config that might contain color references
  if config and type(config) == "table" then
    scan_value(config)
  end

  return used_custom_colors
end

-- Filter the xeno color palette to only include color families that are actually used
local function get_filtered_color_palette(highlights, variant_palette)
  local xeno = package.loaded["xeno"]
  if not xeno or not xeno.colors then
    return nil, "xeno.nvim colors not available. Please run xeno.setup() first"
  end

  -- Use provided variant_palette for filtering, fall back to xeno.colors if not provided
  local palette_to_filter = variant_palette or xeno.colors

  local used_color_values, used_named_colors = extract_used_colors_from_highlights(highlights)
  local used_color_families = {}
  local used_custom_colors = {}
  local filtered_colors = {}

  -- Extract custom color references from the original user configuration
  if xeno._global_config then
    used_custom_colors = extract_custom_color_references(xeno._global_config)
  end

  -- Also check original user configuration for semantic color references
  if xeno._global_config and xeno._global_config.highlights then
    local function extract_semantic_from_config(config_section)
      if type(config_section) ~= "table" then
        return
      end
      for group_name, attrs in pairs(config_section) do
        if type(attrs) == "table" then
          for attr_name, attr_value in pairs(attrs) do
            if
              (attr_name == "fg" or attr_name == "bg" or attr_name == "sp")
              and type(attr_value) == "string"
              and not attr_value:match("^#[0-9a-fA-F]+$")
              and not attr_value:match("^@")
            then -- Not a color reference like @background.500
              used_named_colors[attr_value] = true
            end
          end
        end
      end
    end

    -- Check all highlight categories for semantic color references
    if xeno._global_config.highlights.syntax then
      extract_semantic_from_config(xeno._global_config.highlights.syntax)
    end
    if xeno._global_config.highlights.editor then
      extract_semantic_from_config(xeno._global_config.highlights.editor)
    end
    if xeno._global_config.highlights.plugins then
      for plugin_name, plugin_config in pairs(xeno._global_config.highlights.plugins) do
        if type(plugin_config) == "table" then
          extract_semantic_from_config(plugin_config)
        end
      end
    end
  end

  -- First pass: Determine which color families are being used
  for color_name, color_value in pairs(palette_to_filter) do
    if type(color_value) == "string" and color_value:match("^#[0-9a-fA-F]+$") then
      if used_color_values[color_value:upper()] then
        local family = color_name:match("^([^_]+_?[^_]*)_?%d*$") or color_name
        family = color_name:match("^(.-)_%d+$") or color_name
        used_color_families[family] = true
      end
    end
  end

  -- List of semantic color names that should always be included
  local semantic_colors = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }

  -- Second pass: Include all colors from the used families, referenced semantic colors, and used custom colors
  for color_name, color_value in pairs(palette_to_filter) do
    if type(color_value) == "string" and color_value:match("^#[0-9a-fA-F]+$") then
      local family = color_name:match("^(.-)_%d+$") or color_name
      local is_semantic = false
      local is_custom_color = false

      -- Check if this is a semantic color
      for _, semantic in ipairs(semantic_colors) do
        if color_name == semantic then
          is_semantic = true
          break
        end
      end

      -- Check if this is a custom color or part of a custom color family
      if used_custom_colors[family] then
        is_custom_color = true
      end

      -- Include if:
      -- 1. It's from a used color family (color scale)
      -- 2. It's a semantic color that was referenced by name in the original config
      -- 3. It's directly used as a hex value in highlights
      -- 4. It's part of a custom color family that was referenced
      if used_named_colors[color_name] or used_color_families[family] or is_custom_color or not color_name:match("_") then
        -- For non-scale colors (semantic colors), include if:
        -- - It's a semantic color that was referenced by name in user config
        -- - It's a standard semantic color (for safety)
        -- - It's directly used as a hex value
        if not color_name:match("_%d+$") then
          if used_named_colors[color_name] or is_semantic or used_color_values[color_value:upper()] then
            filtered_colors[color_name] = color_value
          end
        else
          -- For scale colors, include exact named references as well as full families.
          if used_named_colors[color_name] or is_custom_color or used_color_families[family] then
            filtered_colors[color_name] = color_value
          end
        end
      end
    end
  end

  -- Debug information for development
  if vim.env.XENO_DEBUG_EXPORT then
    local custom_color_count = 0
    local used_custom_count = 0
    if xeno._global_config and xeno._global_config._custom_colors then
      for name, _ in pairs(xeno._global_config._custom_colors) do
        custom_color_count = custom_color_count + 1
      end
    end
    for name, _ in pairs(used_custom_colors) do
      used_custom_count = used_custom_count + 1
    end
    print(fmt("xeno export: %d custom colors defined, %d used in theme", custom_color_count, used_custom_count))
    if used_custom_count > 0 then
      local used_names = {}
      for name, _ in pairs(used_custom_colors) do
        table.insert(used_names, name)
      end
      print(fmt("xeno export: Used custom colors: %s", table.concat(used_names, ", ")))
    end
  end

  return filtered_colors
end

-- Map TreeSitter highlights to traditional vim syntax highlights for better compatibility
local function apply_treesitter_links(highlights, user_config)
  if not user_config or not user_config.highlights or not user_config.highlights.syntax then
    return highlights
  end

  local user_syntax = user_config.highlights.syntax
  local treesitter_to_vim_map = {
    ["@string"] = "String",
    ["@string.regexp"] = "String",
    ["@string.escape"] = "String",
    ["@string.special"] = "String",
    ["@function"] = "Function",
    ["@function.builtin"] = "Function",
    ["@function.macro"] = "Function",
    ["@method"] = "Function",
    ["@conditional"] = "Conditional",
    ["@repeat"] = "Repeat",
    ["@keyword"] = "Keyword",
    ["@keyword.function"] = "Function",
    ["@keyword.return"] = "Return",
    ["@keyword.conditional"] = "Conditional",
    ["@keyword.repeat"] = "Repeat",
    ["@keyword.operator"] = "Operator",
    ["@type"] = "Type",
    ["@type.builtin"] = "Type",
    ["@type.definition"] = "Typedef",
    ["@constant"] = "Constant",
    ["@constant.builtin"] = "Constant",
    ["@constant.macro"] = "Define",
    ["@number"] = "Number",
    ["@boolean"] = "Boolean",
    ["@float"] = "Float",
    ["@comment"] = "Comment",
    ["@include"] = "Include",
    ["@define"] = "Define",
    ["@macro"] = "Macro",
    ["@preproc"] = "PreProc",
    ["@tag"] = "Tag",
    ["@label"] = "Label",
    ["@exception"] = "Exception",
    ["@variable"] = "Identifier",
    ["@parameter"] = "Identifier",
    ["@field"] = "Special",
    ["@property"] = "Special",
    ["@constructor"] = "Special",
    ["@namespace"] = "Identifier",
    ["@punctuation"] = "Delimiter",
    ["@punctuation.delimiter"] = "Delimiter",
    ["@punctuation.bracket"] = "Delimiter",
    ["@operator"] = "Operator",
    ["@error"] = "Error",
    ["@debug"] = "Debug",
  }

  for ts_group, vim_group in pairs(treesitter_to_vim_map) do
    if user_syntax[vim_group] and highlights[ts_group] and highlights[vim_group] then
      highlights[ts_group] = { link = vim_group }
    elseif highlights[ts_group] and not highlights[vim_group] then
      highlights[ts_group] = nil
    end
  end

  return highlights
end

-- Fallback: Get current highlights from Neovim API if xeno highlights unavailable
local function get_neovim_current_highlights()
  local highlights = {}

  -- Get all highlight groups using Neovim's API
  local all_highlights = vim.api.nvim_get_hl(0, {})

  for group_name, attrs in pairs(all_highlights) do
    if attrs.fg or attrs.bg or attrs.sp or attrs.bold or attrs.italic or attrs.underline or attrs.strikethrough then
      local hl_def = {}

      -- Convert numeric colors to hex format
      if attrs.fg then
        hl_def.fg = string.format("#%06x", attrs.fg)
      end
      if attrs.bg then
        hl_def.bg = string.format("#%06x", attrs.bg)
      end
      if attrs.sp then
        hl_def.sp = string.format("#%06x", attrs.sp)
      end

      -- Handle style attributes
      if attrs.bold then
        hl_def.bold = true
      end
      if attrs.italic then
        hl_def.italic = true
      end
      if attrs.underline then
        hl_def.underline = true
      end
      if attrs.strikethrough then
        hl_def.strikethrough = true
      end
      if attrs.reverse then
        hl_def.reverse = true
      end
      if attrs.standout then
        hl_def.standout = true
      end
      if attrs.undercurl then
        hl_def.undercurl = true
      end
      if attrs.underdouble then
        hl_def.underdouble = true
      end
      if attrs.underdotted then
        hl_def.underdotted = true
      end
      if attrs.underdashed then
        hl_def.underdashed = true
      end

      highlights[group_name] = hl_def
    end
  end

  return highlights
end

-- Generate variant-specific color palette using xeno's palette system
local function generate_variant_palette(foreground_color, background_color, accent_color, variant, user_config, filtered_custom_colors)
  local palette = require("xeno.core.palette")
  local opaque_registry = require("xeno.core.opaque_registry")

  -- Create a complete config matching the user's actual configuration
  local temp_config = {
    foreground = foreground_color,
    background = background_color,
    accent = accent_color,
    variation = user_config.variation or 0,
    chroma = user_config.chroma or 0,
    lightness = user_config.lightness or 0,
    contrast = user_config.contrast or 0,
    -- Include any custom colors from the current config
    _custom_colors = user_config._custom_colors,
    -- Apply filtering if provided
    _filtered_custom_colors = filtered_custom_colors,
  }

  -- Copy any semantic color overrides from user config
  local semantic_colors = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }
  for _, color_name in ipairs(semantic_colors) do
    if user_config[color_name] then
      temp_config[color_name] = user_config[color_name]
    end
  end

  -- Temporarily override the variant to generate the right palette
  local original_variant = vim.o.background
  vim.o.background = variant

  -- Enable export mode to capture opaque calls
  opaque_registry.set_export_mode(true)

  -- Generate the palette for this variant using xeno's actual mechanism
  local ok, variant_palette = pcall(palette.generate_palette, temp_config)

  -- Generate highlights to capture any opaque calls during highlight generation
  local variant_highlights = nil
  if ok and variant_palette then
    -- Use the highlights generator to capture opaque calls
    local highlights = require("xeno.highlights")
    local ok_h, h = pcall(highlights.generate_base_highlights, variant_palette, temp_config)
    if ok_h then
      variant_highlights = h
    end
  end

  -- Get any opaque colors that were registered during palette/highlight generation
  local opaque_colors = opaque_registry.get_opaque_colors(variant)

  -- Add opaque colors to the variant palette
  if variant_palette and opaque_colors then
    for name, info in pairs(opaque_colors) do
      variant_palette[name] = info.hex
    end
  end

  -- Disable export mode
  opaque_registry.set_export_mode(false)

  -- Restore original variant immediately
  vim.o.background = original_variant

  if not ok then
    vim.notify("xeno.nvim export: Error generating " .. variant .. " palette: " .. tostring(variant_palette), vim.log.levels.WARN)
    return {}, nil
  end

  return variant_palette or {}, variant_highlights
end

-- Organize colors by their usage in both light and dark variants
-- If current_variant_palette is provided, use it instead of regenerating
local function organize_colors_by_variant(color_palette, highlights, current_variant_palette, current_variant)
  -- Get the current xeno configuration - this is crucial for consistency
  local xeno = package.loaded["xeno"]
  local user_config = {}

  if xeno and xeno._global_config then
    user_config = vim.deepcopy(xeno._global_config)
  else
    -- Fallback defaults that match xeno's defaults
    user_config = {
      foreground = nil,
      background = "#030303",
      accent = "#7AA2F7",
      variation = 0,
      chroma = 0,
      lightness = 0,
      contrast = 0,
    }
  end

  local organized = {
    foreground_colors = {},
    background_colors = {},
    accent_colors = {},
    semantic_colors = {},
    custom_colors = {},
    opaque_colors = {}, -- Add opaque colors category
  }

  -- Separate current colors by type for reference
  for color_name, color_value in pairs(color_palette) do
    if color_name:match("^foreground_%d+$") then
      organized.foreground_colors[color_name] = color_value
    elseif color_name:match("^background_%d+$") then
      organized.background_colors[color_name] = color_value
    elseif color_name:match("^accent_%d+$") then
      organized.accent_colors[color_name] = color_value
    elseif
      color_name:match("^.+_%d%d%d$")
      and not color_name:match("^foreground_%d+$")
      and not color_name:match("^background_%d+$")
      and not color_name:match("^accent_%d+$")
    then
      -- Opaque colors (end with 3-digit opacity like _050, _025, etc.)
      organized.opaque_colors[color_name] = color_value
    elseif color_name:match("^[^_]+_%d+$") then
      -- Custom color scales (like "custom_red_500")
      organized.custom_colors[color_name] = color_value
    elseif not color_name:match("_%d+$") then
      organized.semantic_colors[color_name] = color_value
    end
  end

  -- Get the filtered custom colors from our usage detection
  local filtered_custom_colors = nil
  if user_config._custom_colors then
    local xeno = package.loaded["xeno"]
    if xeno and xeno._global_config then
      filtered_custom_colors = extract_custom_color_references(xeno._global_config)
    end
  end

  -- If a pre-generated palette is provided for the current variant, use it
  -- Otherwise, generate both variants as fallback
  local dark_palette, light_palette

  if current_variant_palette and current_variant then
    -- Use the provided palette for the current variant
    if current_variant == "dark" then
      dark_palette = current_variant_palette
      -- Generate light palette for completeness if needed
      light_palette = generate_variant_palette(
        user_config.foreground,
        user_config.background,
        user_config.accent,
        "light",
        user_config,
        filtered_custom_colors
      )
    else
      light_palette = current_variant_palette
      -- Generate dark palette for completeness if needed
      dark_palette = generate_variant_palette(
        user_config.foreground,
        user_config.background,
        user_config.accent,
        "dark",
        user_config,
        filtered_custom_colors
      )
    end
  else
    -- Fallback: Generate both palettes
    dark_palette =
      generate_variant_palette(user_config.foreground, user_config.background, user_config.accent, "dark", user_config, filtered_custom_colors)
    light_palette =
      generate_variant_palette(user_config.foreground, user_config.background, user_config.accent, "light", user_config, filtered_custom_colors)
  end

  -- Store variant-specific colors
  organized.variant_colors = {
    dark = dark_palette,
    light = light_palette,
  }

  -- If generation failed, use current colors for both variants as fallback
  if not next(dark_palette) or not next(light_palette) then
    vim.notify("xeno.nvim export: Variant palette generation failed, using current colors for both variants", vim.log.levels.WARN)
    organized.variant_colors.dark = color_palette
    organized.variant_colors.light = color_palette
  end

  return organized
end

-- Validate that variant colors were generated successfully
local function validate_variant_colors(organized_colors)
  -- Check if we have essential colors (including syntax variants)
  local required_colors = {
    "foreground_50",
    "foreground_200",
    "foreground_400",
    "background_500",
    "background_800",
    "background_950",
    "accent_50",
    "accent_300",
    "accent_600",
  }

  for _, variant in ipairs({ "dark", "light" }) do
    local colors = organized_colors.variant_colors[variant]
    for _, required in ipairs(required_colors) do
      if not colors[required] then
        return false, string.format("Missing required color %s in %s variant", required, variant)
      end
    end
  end

  return true
end

-- Generate basic metadata for the exported theme
local function generate_metadata()
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local variant = vim.o.background or "dark"

  -- Get xeno configuration for palette seed colors
  local xeno = package.loaded["xeno"]
  local foreground_color = "unknown"
  local background_color = "unknown"
  local accent_color = "unknown"
  local variation = 0
  local chroma = 0
  local lightness = 0
  local contrast = 0

  if xeno and xeno._global_config then
    foreground_color = xeno._global_config.foreground or foreground_color
    background_color = xeno._global_config.background or background_color
    accent_color = xeno._global_config.accent or accent_color
    variation = xeno._global_config.variation or variation
    chroma = xeno._global_config.chroma or chroma
    lightness = xeno._global_config.lightness or lightness
    contrast = xeno._global_config.contrast or contrast
  end

  return {
    timestamp = timestamp,
    variant = variant,
    foreground_color = foreground_color,
    background_color = background_color,
    accent_color = accent_color,
    variation = variation,
    chroma = chroma,
    lightness = lightness,
    contrast = contrast,
    exported_by = "xeno.nvim export",
    supports_variants = true, -- New flag for dynamic exports
  }
end

-- Main export function with simplified API
function M.export_theme(config)
  config = utils.extend("force", DEFAULT_EXPORT_CONFIG, config or {})

  -- Validate configuration
  local ok, err = validate_export_config(config)
  if not ok then
    return nil, err
  end

  -- Check if xeno is currently loaded
  local xeno = package.loaded["xeno"]
  if not xeno then
    return nil, "xeno.nvim theme is not currently loaded. Please run xeno.setup() first"
  end

  -- Get the current variant to determine which palette to use for resolution
  local current_variant = vim.o.background or "dark"

  -- Generate metadata first (we'll need it)
  local metadata = generate_metadata()
  metadata.theme_name = config.theme_name or "xeno"

  -- IMPORTANT: Generate variant-specific palettes BEFORE resolving highlights
  -- This ensures highlights are resolved with the correct colors for the current variant
  local user_config = xeno._global_config or {}

  -- Generate the current variant's palette and highlights together
  -- This ensures opaque colors are captured and highlights contain semantic references
  local variant_palette, current_highlights = generate_variant_palette(
    user_config.foreground,
    user_config.background or "#030303",
    user_config.accent or "#7AA2F7",
    current_variant,
    user_config,
    nil -- filtered_custom_colors
  )

  if not variant_palette or not next(variant_palette) then
    vim.notify(fmt("xeno.nvim export: Error generating %s variant palette", current_variant), vim.log.levels.WARN)
    variant_palette = xeno.colors -- Fallback to current colors
  end

  if not current_highlights then
    vim.notify("xeno.nvim export: Highlights generation failed. Using Neovim API fallback.", vim.log.levels.WARN)
    current_highlights = get_neovim_current_highlights()
  end

  -- Apply user overrides if present
  if xeno._global_config and xeno._global_config.highlights then
    local merger = require("xeno.core.merger")
    current_highlights = merger.merge_all_highlights(current_highlights, xeno._global_config.highlights, variant_palette)
  end

  -- Apply TreeSitter compatibility links
  current_highlights = apply_treesitter_links(current_highlights, xeno._global_config)

  -- Debug: Check what's in a sample highlight
  if vim.env.XENO_DEBUG_EXPORT then
    local normal = current_highlights["Normal"]
    if normal then
      print(fmt("xeno.export debug: Normal.fg = %s (type: %s)", normal.fg, type(normal.fg)))
      print(fmt("xeno.export debug: Normal.bg = %s (type: %s)", normal.bg, type(normal.bg)))
    end
  end

  -- Get only the colors that are actually used in the current highlights
  -- Pass the variant_palette so filtering matches the colors used in highlight resolution
  local color_palette, palette_err = get_filtered_color_palette(current_highlights, variant_palette)
  if not color_palette then
    return nil, fmt("Error getting color palette: %s", palette_err)
  end

  -- Organize colors by variant usage, passing the filtered palette for the current variant
  local organized_colors = organize_colors_by_variant(color_palette, current_highlights, color_palette, current_variant)

  -- Get file-type specific highlights for both variants
  local filetype_highlights = { dark = {}, light = {} }
  if xeno.ft and next(xeno.ft) then
    for _, variant in ipairs({ "dark", "light" }) do
      local v_palette = organized_colors.variant_colors[variant]
      if v_palette then
        for ft, generator_fn in pairs(xeno.ft) do
          local ok_ft, ft_hls = pcall(generator_fn, v_palette, user_config)
          if ok_ft and ft_hls then
            filetype_highlights[variant][ft] = ft_hls
          end
        end
      end
    end
  end

  -- Validate that variant color generation succeeded
  local valid, validation_error = validate_variant_colors(organized_colors)
  if not valid then
    return nil, fmt("Error validating variant colors: %s", validation_error)
  end

  -- Prepare export data with variant-aware color structure
  local export_data = {
    highlights = current_highlights,
    filetype_highlights = filetype_highlights,
    colors = organized_colors,
    raw_colors = color_palette, -- Keep original palette for backward compatibility
    metadata = metadata,
  }

  -- Generate the colorscheme file
  local formatter = lua_formatter
  local content, format_err = formatter.format_colorscheme(export_data)
  if not content then
    return nil, fmt("Error formatting colorscheme: %s", format_err)
  end

  -- Generate filename based on theme name and timestamp
  local theme_name = "xeno"
  local timestamp = os.date("%Y%m%d_%H%M%S")
  local filename = fmt("%s_%s_%s.%s", theme_name, vim.o.background, timestamp, config.format)

  -- Write to file
  local output_dir = vim.fn.expand(config.dir)
  local full_path = export_utils.join_path(output_dir, filename)

  local write_ok, write_err = export_utils.write_file(full_path, content)
  if not write_ok then
    return nil, write_err
  end

  return {
    path = full_path,
    filename = filename,
    format = config.format,
    size = #content,
    highlights_exported = vim.tbl_count(current_highlights),
    colors_exported = vim.tbl_count(color_palette),
    supports_variants = metadata.supports_variants,
  }
end

return M
