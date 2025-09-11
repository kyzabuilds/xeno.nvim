local M = {}

local utils = require("xeno.export.utils")
local lua_template = require("xeno.export.templates.lua")

local fmt = string.format

-- Extract color categories from xeno's generated palette structure
local function organize_color_palette(colors)
  local organized = {
    base = {},
    accent = {},
    custom = {},
    semantic = {}
  }
  
  -- Standard scale levels for proper ordering
  local scale_levels = {50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950}
  
  for color_name, color_value in pairs(colors) do
    local name, level = color_name:match("^([^_]+)_(%d+)$")
    if name and level then
      level = tonumber(level)
      if name == "base" then
        organized.base[level] = color_value
      elseif name == "accent" then
        organized.accent[level] = color_value
      else
        -- Custom colors (red_stone, martina_olive, etc.)
        if not organized.custom[name] then
          organized.custom[name] = {}
        end
        organized.custom[name][level] = color_value
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

  local normalized = utils.normalize_highlight_attrs(attrs)
  if not next(normalized) then
    return ""
  end

  local parts = {}

  -- Add color attributes using variable references
  if normalized.fg then
    local var_name = color_lookup[normalized.fg:upper()]
    if var_name then
      table.insert(parts, fmt('fg = colors.%s', var_name))
    else
      table.insert(parts, fmt('fg = "%s"', normalized.fg))
    end
  end
  if normalized.bg then
    local var_name = color_lookup[normalized.bg:upper()]
    if var_name then
      table.insert(parts, fmt('bg = colors.%s', var_name))
    else
      table.insert(parts, fmt('bg = "%s"', normalized.bg))
    end
  end
  if normalized.sp then
    local var_name = color_lookup[normalized.sp:upper()]
    if var_name then
      table.insert(parts, fmt('sp = colors.%s', var_name))
    else
      table.insert(parts, fmt('sp = "%s"', normalized.sp))
    end
  end

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


-- Main formatting function
function M.format_colorscheme(export_data)
  local template = lua_template.template
  local replacements = {}

  -- Header comment
  replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, "--")

  -- Theme name
  local theme_name = utils.sanitize_name("xeno_exported_theme")
  replacements["{{THEME_NAME}}"] = theme_name

  -- Color definitions with structured format
  replacements["{{COLOR_DEFINITIONS}}"] = format_color_definitions(export_data.colors)

  -- All highlights in one section with color variable references
  replacements["{{EDITOR_HIGHLIGHTS}}"] = format_all_highlights(export_data.highlights, export_data.colors)

  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end

  return result
end

return M

