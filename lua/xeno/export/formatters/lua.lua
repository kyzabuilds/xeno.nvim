local M = {}

local utils = require("xeno.export.utils")
local lua_template = require("xeno.export.templates.lua")

local fmt = string.format

-- Extract color categories from xeno's generated palette structure
local function organize_color_palette(colors)
  local organized = {
    foreground = {},
    background = {},
    accent = {},
    custom = {},
    semantic = {},
  }

  local family_levels = {
    foreground = { 50, 100, 200, 300, 400 },
    background = { 500, 600, 700, 800, 900, 950 },
    accent = { 50, 100, 200, 300, 400, 500, 600 },
  }

  for color_name, color_value in pairs(colors) do
    local name, level = color_name:match("^([^_]+_?[^_]*)_(%d+)$")
    if name and level then
      level = tonumber(level)
      if level and name == "foreground" then
        organized.foreground[level] = color_value
      elseif level and name == "background" then
        organized.background[level] = color_value
      elseif level and name == "accent" then
        organized.accent[level] = color_value
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

  return organized, family_levels
end

-- Format color definitions in structured format
local function format_color_definitions(colors)
  local lines = {}
  local organized, family_levels = organize_color_palette(colors)

  -- Helper function to add color scale section
  local function add_color_scale(title, colors_table, prefix, levels)
    if next(colors_table) then
      table.insert(lines, "")
      table.insert(lines, fmt("  -- %s", title))

      for _, level in ipairs(levels) do
        if colors_table[level] then
          local color_name = fmt("%s_%d", prefix, level)
          table.insert(lines, fmt('  %s = "%s",', color_name, utils.format_hex_color(colors_table[level])))
        end
      end
    end
  end

  add_color_scale("Foreground colors", organized.foreground, "foreground", family_levels.foreground)
  add_color_scale("Background colors", organized.background, "background", family_levels.background)

  add_color_scale("Accent colors", organized.accent, "accent", family_levels.accent)

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

      for _, level in ipairs(family_levels.accent) do
        if color_scale[level] then
          local color_name = fmt("%s_%d", name, level)
          table.insert(lines, fmt('  %s = "%s",', color_name, utils.format_hex_color(color_scale[level])))
        end
      end
    end
  end

  return table.concat(lines, "\n")
end

-- Format highlight group for Lua with color variable references
local function format_highlight_group(group_name, attrs, color_lookup)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end

  if attrs.link then
    return fmt("hi('%s', { link = '%s' })", group_name, attrs.link)
  end

  local parts = {}

  if attrs.fg then
    local fg_normalized = utils.format_hex_color(attrs.fg)
    local var_name = color_lookup[fg_normalized:upper()]
    if var_name then
      table.insert(parts, fmt("fg = colors.%s", var_name))
    else
      table.insert(parts, fmt('fg = "%s"', fg_normalized))
    end
  end
  if attrs.bg then
    local bg_normalized = utils.format_hex_color(attrs.bg)
    local var_name = color_lookup[bg_normalized:upper()]
    if var_name then
      table.insert(parts, fmt("bg = colors.%s", var_name))
    else
      table.insert(parts, fmt('bg = "%s"', bg_normalized))
    end
  end
  if attrs.sp then
    local sp_normalized = utils.format_hex_color(attrs.sp)
    local var_name = color_lookup[sp_normalized:upper()]
    if var_name then
      table.insert(parts, fmt("sp = colors.%s", var_name))
    else
      table.insert(parts, fmt('sp = "%s"', sp_normalized))
    end
  end

  local normalized = utils.normalize_highlight_attrs(attrs)
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

-- Format highlights using the dynamic colors variable for variant-aware exports
local function format_dynamic_highlights(highlights, organized_colors)
  if not highlights or not next(highlights) then
    return ""
  end

  local lines = {}

  local color_lookup = {}

  local function add_to_lookup(name, color)
    if type(color) == "string" and color:match("^#[0-9a-fA-F]+$") then
      local hex_upper = color:upper()
      if not color_lookup[hex_upper] then
        color_lookup[hex_upper] = name
      else
        local current = color_lookup[hex_upper]
        if #name < #current then
          color_lookup[hex_upper] = name
        end
      end
    end
  end

  if organized_colors.variant_colors then
    local variant = vim.o.background or "dark"
    local variant_palette = organized_colors.variant_colors[variant]
    if variant_palette then
      for name, color in pairs(variant_palette) do
        add_to_lookup(name, color)
      end
    end
  end

  for name, color in pairs(organized_colors.foreground_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.background_colors or {}) do
    add_to_lookup(name, color)
  end
  for name, color in pairs(organized_colors.accent_colors or {}) do
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
  end

  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end

  return result
end

return M
