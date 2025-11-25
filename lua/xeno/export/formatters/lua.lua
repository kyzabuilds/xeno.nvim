local M = {}

local utils = require("xeno.export.utils")
local lua_template = require("xeno.export.templates.lua")

local fmt = string.format

-- Extract color categories from xeno's generated palette structure
local function organize_color_palette(colors)
  local organized = {
    base = {},
    accent = {},
    syntax_base = {},
    syntax_accent = {},
    custom = {},
    semantic = {},
  }

  -- Standard scale levels for proper ordering
  local scale_levels = { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 }

  for color_name, color_value in pairs(colors) do
    local name, level = color_name:match("^([^_]+_?[^_]*)_(%d+)$")
    if name and level then
      level = tonumber(level)
      if level and name == "base" then
        organized.base[level] = color_value
      elseif level and name == "accent" then
        organized.accent[level] = color_value
      elseif level and name == "syntax_base" then
        organized.syntax_base[level] = color_value
      elseif level and name == "syntax_accent" then
        organized.syntax_accent[level] = color_value
      elseif level then
        -- Custom colors (red_stone, martina_olive, etc.)
        if not organized.custom[name] then
          organized.custom[name] = {}
        end
        if organized.custom[name] then
          organized.custom[name][level] = color_value
        end
      end
    else
      -- Semantic colors (red, green, blue, etc.)
      organized.semantic[color_name] = color_value
    end
  end

  return organized, scale_levels
end

-- Format color definitions in structured format
local function format_color_definitions(colors)
  local lines = {}
  local organized, scale_levels = organize_color_palette(colors)

  -- Helper function to add color scale section
  local function add_color_scale(title, colors_table, prefix)
    if next(colors_table) then
      table.insert(lines, "")
      table.insert(lines, fmt("  -- %s", title))

      for _, level in ipairs(scale_levels) do
        if colors_table[level] then
          local color_name = fmt("%s_%d", prefix, level)
          table.insert(lines, fmt('  %s = "%s",', color_name, utils.format_hex_color(colors_table[level])))
        end
      end
    end
  end

  -- Add base colors
  add_color_scale("Base colors", organized.base, "base")

  -- Add accent colors
  add_color_scale("Accent colors", organized.accent, "accent")

  -- Add syntax base colors (with variation)
  add_color_scale("Syntax base colors", organized.syntax_base, "syntax_base")

  -- Add syntax accent colors (with variation)
  add_color_scale("Syntax accent colors", organized.syntax_accent, "syntax_accent")

  -- Add semantic colors first (these have priority)
  if next(organized.semantic) then
    table.insert(lines, "")
    table.insert(lines, "  -- Semantic colors")

    local semantic_names = {}
    for name in pairs(organized.semantic) do
      table.insert(semantic_names, name)
    end
    table.sort(semantic_names)

    for _, name in ipairs(semantic_names) do
      table.insert(lines, fmt('  %s = "%s",', name, utils.format_hex_color(organized.semantic[name])))
    end
  end

  -- Add custom colors (sorted by name)
  if next(organized.custom) then
    local custom_names = {}
    for name in pairs(organized.custom) do
      table.insert(custom_names, name)
    end
    table.sort(custom_names)

    for _, name in ipairs(custom_names) do
      local color_scale = organized.custom[name]
      table.insert(lines, "")
      table.insert(lines, fmt("  -- %s colors", name))

      for _, level in ipairs(scale_levels) do
        if color_scale[level] then
          local color_name = fmt("%s_%d", name, level)
          table.insert(lines, fmt('  %s = "%s",', color_name, utils.format_hex_color(color_scale[level])))
        end
      end
    end
  end

  return table.concat(lines, "\n")
end

-- Create a reverse lookup table from color values to names for highlights
local function create_color_lookup(colors)
  local lookup = {}

  for color_name, color_value in pairs(colors) do
    if type(color_value) == "string" and color_value:match("^#[0-9a-fA-F]+$") then
      lookup[color_value:upper()] = color_name
    end
  end

  return lookup
end

-- Format highlight group for Lua with color variable references
local function format_highlight_group(group_name, attrs, color_lookup)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end

  -- Handle link highlights specially
  if attrs.link then
    return fmt("hi('%s', { link = '%s' })", group_name, attrs.link)
  end

  local parts = {}

  -- Process color attributes with proper lookup before normalization
  -- This prevents valid colors from being converted to #000000
  if attrs.fg then
    -- First try to look up the color as-is
    local fg_normalized = utils.format_hex_color(attrs.fg)
    local var_name = color_lookup[fg_normalized:upper()]
    if var_name then
      table.insert(parts, fmt("fg = colors.%s", var_name))
    else
      -- If not found and it's not already black, debug log it
      if vim.env.XENO_DEBUG_EXPORT and fg_normalized ~= "#000000" then
        print(fmt("xeno.export debug: fg %s not found in lookup for group %s", fg_normalized, group_name))
      end
      table.insert(parts, fmt('fg = "%s"', fg_normalized))
    end
  end
  if attrs.bg then
    -- First try to look up the color as-is
    local bg_normalized = utils.format_hex_color(attrs.bg)
    local var_name = color_lookup[bg_normalized:upper()]
    if var_name then
      table.insert(parts, fmt("bg = colors.%s", var_name))
    else
      -- If not found and it's not already black, debug log it
      if vim.env.XENO_DEBUG_EXPORT and bg_normalized ~= "#000000" then
        print(fmt("xeno.export debug: bg %s not found in lookup for group %s", bg_normalized, group_name))
      end
      table.insert(parts, fmt('bg = "%s"', bg_normalized))
    end
  end
  if attrs.sp then
    -- First try to look up the color as-is
    local sp_normalized = utils.format_hex_color(attrs.sp)
    local var_name = color_lookup[sp_normalized:upper()]
    if var_name then
      table.insert(parts, fmt("sp = colors.%s", var_name))
    else
      table.insert(parts, fmt('sp = "%s"', sp_normalized))
    end
  end

  -- Now handle style attributes
  local normalized = utils.normalize_highlight_attrs(attrs)

  -- Add style attributes
  local style_attrs = { "bold", "italic", "underline", "undercurl", "strikethrough", "reverse", "standout" }
  for _, attr in ipairs(style_attrs) do
    if normalized[attr] ~= nil then
      table.insert(parts, fmt("%s = %s", attr, tostring(normalized[attr])))
    end
  end

  if #parts == 0 then
    return ""
  end

  return fmt("hi('%s', { %s })", group_name, table.concat(parts, ", "))
end

-- Format all highlights with color variable references
local function format_all_highlights(highlights, colors)
  if not highlights or not next(highlights) then
    return ""
  end

  local color_lookup = create_color_lookup(colors)
  local lines = {}

  -- Separate linked highlights from regular highlights
  local regular_groups = {}
  local linked_groups = {}

  for group, attrs in pairs(highlights) do
    if attrs.link then
      table.insert(linked_groups, { group = group, attrs = attrs })
    else
      table.insert(regular_groups, { group = group, attrs = attrs })
    end
  end

  -- Sort both groups for consistent output
  table.sort(regular_groups, function(a, b)
    return a.group < b.group
  end)
  table.sort(linked_groups, function(a, b)
    return a.group < b.group
  end)

  -- Process regular highlights first
  for _, item in ipairs(regular_groups) do
    local formatted = format_highlight_group(item.group, item.attrs, color_lookup)
    if formatted ~= "" then
      table.insert(lines, formatted)
    end
  end

  -- Add a comment separator if we have both types
  if #regular_groups > 0 and #linked_groups > 0 then
    table.insert(lines, "")
    table.insert(lines, "-- Linked highlights")
  end

  -- Process linked highlights after regular highlights
  for _, item in ipairs(linked_groups) do
    local formatted = format_highlight_group(item.group, item.attrs, color_lookup)
    if formatted ~= "" then
      table.insert(lines, formatted)
    end
  end

  return table.concat(lines, "\n")
end

-- Format highlights using the dynamic colors variable for variant-aware exports
local function format_dynamic_highlights(highlights, organized_colors)
  if not highlights or not next(highlights) then
    return ""
  end

  local lines = {}

  -- Create comprehensive color lookup with preference for simpler names
  -- We need to ensure all colors in the highlights can be looked up
  local color_lookup = {}
  local xeno = package.loaded["xeno"]

  -- Helper function to add colors to lookup, preferring simpler color names
  -- When multiple color names map to the same hex value, prefer:
  -- 1. Non-syntax names (base_300 over syntax_base_300)
  -- 2. Shorter names (red over semantic_red)
  local function add_to_lookup(name, color)
    if type(color) == "string" and color:match("^#[0-9a-fA-F]+$") then
      local hex_upper = color:upper()
      if not color_lookup[hex_upper] then
        color_lookup[hex_upper] = name
      else
        local current = color_lookup[hex_upper]
        local should_replace = false

        -- Prefer non-syntax names: base_900 over syntax_base_900
        if current:match("^syntax_") and not name:match("^syntax_") then
          should_replace = true
        -- Prefer shorter names
        elseif #name < #current then
          should_replace = true
        end

        if should_replace then
          color_lookup[hex_upper] = name
        end
      end
    end
  end

  -- Build comprehensive lookup from multiple sources
  -- First, try to use the variant-specific colors from export
  if organized_colors.variant_colors then
    local variant = vim.o.background or "dark"
    local variant_palette = organized_colors.variant_colors[variant]
    if variant_palette then
      for name, color in pairs(variant_palette) do
        add_to_lookup(name, color)
      end
    end
  end

  -- Add base/accent/syntax colors from organized colors (includes current setup)
  for name, color in pairs(organized_colors.base_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.accent_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.syntax_base_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.syntax_accent_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.custom_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.semantic_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.opaque_colors or {}) do
    add_to_lookup(name, color)
  end

  -- Also include xeno.colors for compatibility (but don't override organized_colors)
  if xeno and xeno.colors then
    if vim.env.XENO_DEBUG_EXPORT then
      print(fmt("xeno.export debug: xeno.colors has %d entries", vim.tbl_count(xeno.colors) or 0))
    end
    for name, color in pairs(xeno.colors) do
      if type(color) == "string" and color:match("^#[0-9a-fA-F]+$") then
        -- Only add if not already in lookup from organized_colors
        if not color_lookup[color:upper()] then
          add_to_lookup(name, color)
        end
      end
    end
  else
    print("xeno.export debug: xeno.colors not available!")
  end

  -- Separate linked highlights from regular highlights
  local regular_groups = {}
  local linked_groups = {}

  for group, attrs in pairs(highlights) do
    if attrs.link then
      table.insert(linked_groups, { group = group, attrs = attrs })
    else
      table.insert(regular_groups, { group = group, attrs = attrs })
    end
  end

  -- Sort both groups for consistent output
  table.sort(regular_groups, function(a, b)
    return a.group < b.group
  end)
  table.sort(linked_groups, function(a, b)
    return a.group < b.group
  end)

  -- Process regular highlights first
  for _, item in ipairs(regular_groups) do
    local formatted = format_highlight_group(item.group, item.attrs, color_lookup)
    if formatted ~= "" then
      table.insert(lines, "  " .. formatted)
    end
  end

  -- Add a comment separator if we have both types
  if #regular_groups > 0 and #linked_groups > 0 then
    table.insert(lines, "")
    table.insert(lines, "  -- Linked highlights")
  end

  -- Process linked highlights after regular highlights
  for _, item in ipairs(linked_groups) do
    local formatted = format_highlight_group(item.group, item.attrs, color_lookup)
    if formatted ~= "" then
      table.insert(lines, "  " .. formatted)
    end
  end

  return table.concat(lines, "\n")
end

-- Main formatting function
function M.format_colorscheme(export_data)
  local template = lua_template.template
  local replacements = {}

  -- Header comment
  replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, "--")

  -- Theme name
  local theme_name = utils.sanitize_name("xeno_exported_theme")
  replacements["{{THEME_NAME}}"] = theme_name

  -- Check if we have variant-aware data structure
  if export_data.colors.variant_colors then
    -- Generate separate color definitions for each variant
    replacements["{{LIGHT_COLOR_DEFINITIONS}}"] = utils.generate_variant_color_definitions(export_data.colors, "light", "lua")
    replacements["{{DARK_COLOR_DEFINITIONS}}"] = utils.generate_variant_color_definitions(export_data.colors, "dark", "lua")

    -- Generate dynamic highlights that use the colors variable
    replacements["{{EDITOR_HIGHLIGHTS}}"] = format_dynamic_highlights(export_data.highlights, export_data.colors)
  else
    -- Fallback to original format for backward compatibility
    replacements["{{LIGHT_COLOR_DEFINITIONS}}"] = format_color_definitions(export_data.raw_colors or export_data.colors)
    replacements["{{DARK_COLOR_DEFINITIONS}}"] = format_color_definitions(export_data.raw_colors or export_data.colors)
    replacements["{{EDITOR_HIGHLIGHTS}}"] = format_all_highlights(export_data.highlights, export_data.raw_colors or export_data.colors)
  end

  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end

  return result
end

return M
