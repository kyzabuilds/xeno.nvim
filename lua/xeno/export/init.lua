local M = {}

local utils = require("xeno.core.utils")
local export_utils = require("xeno.export.utils")
local lua_formatter = require("xeno.export.formatters.lua")
local vim_formatter = require("xeno.export.formatters.vim")

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
  if config.format and config.format ~= "lua" and config.format ~= "vim" then
    return nil, fmt("Invalid format '%s'. Must be 'lua' or 'vim'", config.format)
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

-- Extract which colors are actually used in the resolved highlights and track semantic color references
local function extract_used_colors_from_highlights(highlights)
  local used_colors = {}
  local used_semantic_colors = {}

  for group_name, attrs in pairs(highlights) do
    if attrs.fg then
      if attrs.fg:match("^#[0-9a-fA-F]+$") then
        used_colors[attrs.fg:upper()] = true
      else
        -- Track semantic color references (like 'green', 'red', etc.)
        used_semantic_colors[attrs.fg] = true
      end
    end
    if attrs.bg then
      if attrs.bg:match("^#[0-9a-fA-F]+$") then
        used_colors[attrs.bg:upper()] = true
      else
        -- Track semantic color references (like 'green', 'red', etc.)
        used_semantic_colors[attrs.bg] = true
      end
    end
    if attrs.sp then
      if attrs.sp:match("^#[0-9a-fA-F]+$") then
        used_colors[attrs.sp:upper()] = true
      else
        -- Track semantic color references (like 'green', 'red', etc.)
        used_semantic_colors[attrs.sp] = true
      end
    end
  end

  return used_colors, used_semantic_colors
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
local function get_filtered_color_palette(highlights)
  local xeno = package.loaded["xeno"]
  if not xeno or not xeno.colors then
    return nil, "xeno.nvim colors not available. Please run xeno.setup() first"
  end

  local used_color_values, used_semantic_colors = extract_used_colors_from_highlights(highlights)
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
            then -- Not a color reference like @base.500
              used_semantic_colors[attr_value] = true
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
  for color_name, color_value in pairs(xeno.colors) do
    if type(color_value) == "string" and color_value:match("^#[0-9a-fA-F]+$") then
      if used_color_values[color_value:upper()] then
        -- Extract the color family name (e.g., "red_stone" from "red_stone_300")
        local family = color_name:match("^([^_]+_?[^_]*)_?%d*$") or color_name
        -- Handle cases like "red_stone_300" -> "red_stone", or "base_500" -> "base"
        family = color_name:match("^(.-)_%d+$") or color_name
        used_color_families[family] = true
      end
    end
  end

  -- List of semantic color names that should always be included
  local semantic_colors = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }

  -- Second pass: Include all colors from the used families, referenced semantic colors, and used custom colors
  for color_name, color_value in pairs(xeno.colors) do
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
      if used_color_families[family] or is_custom_color or not color_name:match("_") then
        -- For non-scale colors (semantic colors), include if:
        -- - It's a semantic color that was referenced by name in user config
        -- - It's a standard semantic color (for safety)
        -- - It's directly used as a hex value
        if not color_name:match("_%d+$") then
          if used_semantic_colors[color_name] or is_semantic or used_color_values[color_value:upper()] then
            filtered_colors[color_name] = color_value
          end
        else
          -- For scale colors, include entire family if any level is used OR if it's a used custom color
          if is_custom_color or used_color_families[family] then
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

-- Get xeno's generated highlights with resolved colors
local function get_xeno_generated_highlights()
  local xeno = package.loaded["xeno"]
  if not xeno or not xeno._generated_highlights then
    return nil, "xeno.nvim highlights not available. Please run xeno.setup() first"
  end

  local resolver = require("xeno.core.resolver")
  local resolved_highlights = {}

  -- Resolve all color references in the generated highlights
  for group_name, attrs in pairs(xeno._generated_highlights) do
    if type(attrs) == "table" and next(attrs) then
      local resolved_attrs = {}

      -- Resolve color references
      for attr_name, attr_value in pairs(attrs) do
        if attr_name == "fg" or attr_name == "bg" or attr_name == "sp" then
          resolved_attrs[attr_name] = resolver.resolve_value(attr_value, xeno.colors)
        else
          -- Copy style attributes as-is
          resolved_attrs[attr_name] = attr_value
        end
      end

      -- Only include if we have actual attributes
      if next(resolved_attrs) then
        resolved_highlights[group_name] = resolved_attrs
      end
    end
  end

  -- Check if user has custom syntax highlights and make TreeSitter highlights link to them
  if xeno._global_config and xeno._global_config.highlights and xeno._global_config.highlights.syntax then
    local user_syntax = xeno._global_config.highlights.syntax

    -- Map TreeSitter highlights to traditional vim syntax highlights
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

    -- If user has defined a traditional vim syntax highlight, make TreeSitter equivalents link to it
    for ts_group, vim_group in pairs(treesitter_to_vim_map) do
      -- Only create link if:
      -- 1. User has defined this vim syntax highlight
      -- 2. The TreeSitter highlight exists in our resolved highlights
      -- 3. The target vim highlight exists in our resolved highlights
      if user_syntax[vim_group] and resolved_highlights[ts_group] and resolved_highlights[vim_group] then
        -- Replace TreeSitter highlight with a link to user's vim highlight
        resolved_highlights[ts_group] = { link = vim_group }
      elseif resolved_highlights[ts_group] and not resolved_highlights[vim_group] then
        -- If TreeSitter highlight exists but target vim group doesn't, remove the TreeSitter highlight
        -- to avoid broken links in the exported colorscheme
        resolved_highlights[ts_group] = nil
      end
    end
  end

  return resolved_highlights
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
local function generate_variant_palette(base_color, accent_color, variant, user_config, filtered_custom_colors)
  local palette = require("xeno.core.palette")
  local opaque_registry = require("xeno.core.opaque_registry")

  -- Create a complete config matching the user's actual configuration
  local temp_config = {
    base = base_color,
    accent = accent_color,
    variation = user_config.variation or 0,
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
  if ok and variant_palette then
    -- Use the highlights generator to capture opaque calls
    local highlights = require("xeno.highlights")
    pcall(highlights.generate_base_highlights, variant_palette, temp_config)
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
    return {}
  end

  return variant_palette or {}
end

-- Organize colors by their usage in both light and dark variants
local function organize_colors_by_variant(color_palette, highlights)
  -- Get the current xeno configuration - this is crucial for consistency
  local xeno = package.loaded["xeno"]
  local user_config = {}

  if xeno and xeno._global_config then
    user_config = vim.deepcopy(xeno._global_config)
  else
    -- Fallback defaults that match xeno's defaults
    user_config = {
      base = "#030303",
      accent = "#7AA2F7",
      variation = 0,
      contrast = 0,
    }
  end

  local organized = {
    base_colors = {},
    accent_colors = {},
    syntax_base_colors = {},
    syntax_accent_colors = {},
    semantic_colors = {},
    custom_colors = {},
    opaque_colors = {}, -- Add opaque colors category
  }

  -- Separate current colors by type for reference
  for color_name, color_value in pairs(color_palette) do
    if color_name:match("^base_%d+$") then
      organized.base_colors[color_name] = color_value
    elseif color_name:match("^accent_%d+$") then
      organized.accent_colors[color_name] = color_value
    elseif color_name:match("^syntax_base_%d+$") then
      organized.syntax_base_colors[color_name] = color_value
    elseif color_name:match("^syntax_accent_%d+$") then
      organized.syntax_accent_colors[color_name] = color_value
    elseif color_name:match("^.+_%d%d%d$") and not color_name:match("^base_%d+$") and not color_name:match("^accent_%d+$") and not color_name:match("^syntax_base_%d+$") and not color_name:match("^syntax_accent_%d+$") then
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

  -- Generate proper variant-specific palettes using xeno's actual mechanism
  local dark_palette = generate_variant_palette(user_config.base, user_config.accent, "dark", user_config, filtered_custom_colors)
  local light_palette = generate_variant_palette(user_config.base, user_config.accent, "light", user_config, filtered_custom_colors)

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
    "base_100",
    "base_300",
    "base_500",
    "base_800",
    "base_900",
    "accent_300",
    "accent_500",
    "syntax_base_300",
    "syntax_base_500",
    "syntax_base_700",
    "syntax_accent_300",
    "syntax_accent_500",
    "syntax_accent_700",
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

  return {
    timestamp = timestamp,
    variant = variant,
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

  -- Get xeno's generated highlights (with fallback to Neovim API)
  local current_highlights, err = get_xeno_generated_highlights()
  if not current_highlights then
    vim.notify(fmt("xeno.nvim export: %s. Using Neovim API fallback.", err), vim.log.levels.WARN)
    current_highlights = get_neovim_current_highlights()
  end

  -- Get only the colors that are actually used in the current highlights
  local color_palette, palette_err = get_filtered_color_palette(current_highlights)
  if not color_palette then
    return nil, fmt("Error getting color palette: %s", palette_err)
  end

  -- Generate metadata
  local metadata = generate_metadata()

  -- Organize colors by variant usage
  local organized_colors = organize_colors_by_variant(color_palette, current_highlights)

  -- Validate that variant color generation succeeded
  local valid, validation_error = validate_variant_colors(organized_colors)
  if not valid then
    return nil, fmt("Error validating variant colors: %s", validation_error)
  end

  -- Prepare export data with variant-aware color structure
  local export_data = {
    highlights = current_highlights,
    colors = organized_colors,
    raw_colors = color_palette, -- Keep original palette for backward compatibility
    metadata = metadata,
  }

  -- Generate the colorscheme file
  local formatter = config.format == "vim" and vim_formatter or lua_formatter
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
