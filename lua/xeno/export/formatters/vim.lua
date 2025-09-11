local M = {}

local utils = require("xeno.export.utils")
local vim_template = require("xeno.export.templates.vim")

local fmt = string.format

-- Create xeno-style color names using numbered scale system (fixed duplicate indices)
local function create_xeno_color_names(used_colors, highlights)
  local color_to_name = {}
  local used_names = {} -- Track used names to prevent duplicates
  
  -- Helper to calculate color brightness
  local function get_brightness(hex)
    local r = tonumber(hex:sub(2, 3), 16) or 0
    local g = tonumber(hex:sub(4, 5), 16) or 0
    local b = tonumber(hex:sub(6, 7), 16) or 0
    return (r * 0.299 + g * 0.587 + b * 0.114)
  end
  
  -- Helper to check if color is grayscale
  local function is_grayscale(hex)
    local r = tonumber(hex:sub(2, 3), 16) or 0
    local g = tonumber(hex:sub(4, 5), 16) or 0
    local b = tonumber(hex:sub(6, 7), 16) or 0
    return math.abs(r - g) < 15 and math.abs(g - b) < 15 and math.abs(r - b) < 15
  end
  
  -- Helper to get unique name
  local function get_unique_name(base_name)
    if not used_names[base_name] then
      used_names[base_name] = true
      return base_name
    end
    -- If name already used, append incrementing suffix
    local counter = 2
    while used_names[base_name .. "_" .. counter] do
      counter = counter + 1
    end
    local unique_name = base_name .. "_" .. counter
    used_names[unique_name] = true
    return unique_name
  end
  
  -- Helper to detect semantic colors
  local function is_semantic_color(color, highlights)
    local group_text = ""
    for group_name, attrs in pairs(highlights) do
      if attrs.fg == color or attrs.bg == color or attrs.sp == color then
        group_text = group_text .. " " .. group_name:lower()
      end
    end
    
    if group_text:match("error") or group_text:match("diagnostic.*error") then
      return "red"
    elseif group_text:match("warn") or group_text:match("diagnostic.*warn") then
      return "yellow"
    elseif group_text:match("info") or group_text:match("hint") or group_text:match("ok") then
      return "green"
    end
    return nil
  end
  
  -- Separate colors into categories
  local grayscale_colors = {}
  local colored_colors = {}
  local semantic_colors = {}
  
  for color in pairs(used_colors) do
    local semantic = is_semantic_color(color, highlights)
    if semantic then
      semantic_colors[color] = semantic
    elseif is_grayscale(color) then
      table.insert(grayscale_colors, {color = color, brightness = get_brightness(color)})
    else
      table.insert(colored_colors, {color = color, brightness = get_brightness(color)})
    end
  end
  
  -- Sort by brightness
  table.sort(grayscale_colors, function(a, b) return a.brightness > b.brightness end)
  table.sort(colored_colors, function(a, b) return a.brightness > b.brightness end)
  
  -- Assign base_X names to grayscale colors with proper level distribution
  local base_levels = {50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950}
  for i, item in ipairs(grayscale_colors) do
    local level_index = math.min(i, #base_levels)
    local level = base_levels[level_index]
    if not level then
      -- If we have more colors than levels, create additional levels
      level = 950 + (i - #base_levels) * 10
    end
    local name = get_unique_name("base_" .. level)
    color_to_name[item.color] = name
  end
  
  -- Assign accent_X names to colored colors with proper level distribution
  local accent_levels = {100, 200, 300, 400, 500, 600, 700, 800, 900, 950}
  for i, item in ipairs(colored_colors) do
    local level_index = math.min(i, #accent_levels)
    local level = accent_levels[level_index]
    if not level then
      -- If we have more colors than levels, create additional levels
      level = 950 + (i - #accent_levels) * 10
    end
    local name = get_unique_name("accent_" .. level)
    color_to_name[item.color] = name
  end
  
  -- Assign semantic color names with uniqueness
  for color, semantic in pairs(semantic_colors) do
    color_to_name[color] = get_unique_name(semantic)
  end
  
  -- Add syntax-specific variations for complex themes
  local total_colors = #grayscale_colors + #colored_colors
  if total_colors > 15 then
    -- Assign some colors to syntax_base_X (middle range of grayscale colors)
    local syntax_base_levels = {100, 200, 300, 400, 500}
    local syntax_start = math.max(1, math.floor(#grayscale_colors * 0.3))
    local syntax_count = math.min(5, #grayscale_colors - syntax_start)
    
    for i = 1, syntax_count do
      local color_index = syntax_start + i
      if grayscale_colors[color_index] then
        local level = syntax_base_levels[i]
        local name = get_unique_name("syntax_base_" .. level)
        color_to_name[grayscale_colors[color_index].color] = name
      end
    end
    
    -- Assign some colors to syntax_accent_X (early range of colored colors)
    local syntax_accent_levels = {100, 200, 300}
    local accent_syntax_start = math.max(1, math.floor(#colored_colors * 0.2))
    local accent_syntax_count = math.min(3, #colored_colors - accent_syntax_start)
    
    for i = 1, accent_syntax_count do
      local color_index = accent_syntax_start + i
      if colored_colors[color_index] then
        local level = syntax_accent_levels[i]
        local name = get_unique_name("syntax_accent_" .. level)
        color_to_name[colored_colors[color_index].color] = name
      end
    end
  end
  
  return color_to_name
end

-- Format color definitions with meaningful names for Vim
local function format_color_definitions(used_colors, color_to_name)
  local lines = {
    "let s:colors = {",
  }

  if next(used_colors) then
    -- Sort by variable name for consistent output
    local sorted_entries = {}
    for color, _ in pairs(used_colors) do
      local var_name = color_to_name[color] or "unknown"
      table.insert(sorted_entries, {color = color, name = var_name})
    end
    table.sort(sorted_entries, function(a, b) return a.name < b.name end)
    
    for i, entry in ipairs(sorted_entries) do
      local separator = i == #sorted_entries and "" or ","
      table.insert(lines, fmt("  \\ '%s': '%s'%s", entry.name, utils.format_hex_color(entry.color), separator))
    end
  end

  table.insert(lines, "\\ }")

  return table.concat(lines, "\n")
end

-- Format highlight group for Vim with color variable references  
local function format_highlight_group(group_name, attrs, color_to_name)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end

  local normalized = utils.normalize_highlight_attrs(attrs)
  if not next(normalized) then
    return ""
  end

  -- Collect style attributes first
  local gui_attrs = {}
  local style_attrs = { "bold", "italic", "underline", "undercurl", "strikethrough", "reverse", "standout" }
  local has_explicit_false = false

  -- Check if any attribute is explicitly set to false
  for _, attr in ipairs(style_attrs) do
    if normalized[attr] == false then
      has_explicit_false = true
      break
    end
  end

  -- If we have explicit false values, start with NONE to clear defaults
  if has_explicit_false then
    table.insert(gui_attrs, "NONE")
  end

  -- Add only the attributes that are explicitly true
  for _, attr in ipairs(style_attrs) do
    if normalized[attr] == true then
      table.insert(gui_attrs, attr)
    end
  end

  -- Build the command using execute with variable interpolation if any colors use variables
  local uses_variables = false
  local fg_part = ""
  local bg_part = ""
  local sp_part = ""
  local gui_part = ""

  if normalized.fg then
    local var_name = color_to_name[normalized.fg]
    if var_name then
      fg_part = " guifg=' . s:colors[\"" .. var_name .. "\"] . '"
      uses_variables = true
    else
      fg_part = " guifg=" .. normalized.fg
    end
  end

  if normalized.bg then
    local var_name = color_to_name[normalized.bg]
    if var_name then
      bg_part = " guibg=' . s:colors[\"" .. var_name .. "\"] . '"
      uses_variables = true
    else
      bg_part = " guibg=" .. normalized.bg
    end
  end

  if normalized.sp then
    local var_name = color_to_name[normalized.sp]
    if var_name then
      sp_part = " guisp=' . s:colors[\"" .. var_name .. "\"] . '"
      uses_variables = true
    else
      sp_part = " guisp=" .. normalized.sp
    end
  end

  if #gui_attrs > 0 then
    gui_part = " gui=" .. table.concat(gui_attrs, ",")
  end

  if uses_variables then
    return fmt("execute 'highlight %s%s%s%s%s'", group_name, fg_part, bg_part, sp_part, gui_part)
  else
    -- Use simple highlight command for non-variable colors
    local cmd_parts = { fmt("highlight %s", group_name) }
    if normalized.fg then table.insert(cmd_parts, fmt("guifg=%s", normalized.fg)) end
    if normalized.bg then table.insert(cmd_parts, fmt("guibg=%s", normalized.bg)) end
    if normalized.sp then table.insert(cmd_parts, fmt("guisp=%s", normalized.sp)) end
    if #gui_attrs > 0 then table.insert(cmd_parts, fmt("gui=%s", table.concat(gui_attrs, ","))) end
    return table.concat(cmd_parts, " ")
  end
end

-- Format all highlights for Vim with color variable references
local function format_all_highlights(highlights, color_to_name)
  if not highlights or not next(highlights) then
    return ""
  end

  local lines = {}

  -- Sort highlight groups for consistent output
  local sorted_groups = {}
  for group, attrs in pairs(highlights) do
    table.insert(sorted_groups, { group = group, attrs = attrs })
  end
  table.sort(sorted_groups, function(a, b)
    return a.group < b.group
  end)

  for _, item in ipairs(sorted_groups) do
    local formatted = format_highlight_group(item.group, item.attrs, color_to_name)
    if formatted ~= "" then
      table.insert(lines, formatted)
    end
  end

  return table.concat(lines, "\n")
end


-- Main formatting function
function M.format_colorscheme(export_data)
  local template = vim_template.template
  local replacements = {}

  -- Create xeno-style color names using numbered scale system
  local color_to_name = create_xeno_color_names(export_data.colors, export_data.highlights)

  -- Header comment
  replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, '"')

  -- Theme name
  local theme_name = utils.sanitize_name("xeno_exported_theme")
  replacements["{{THEME_NAME}}"] = theme_name

  -- Color definitions with meaningful names
  replacements["{{COLOR_DEFINITIONS}}"] = format_color_definitions(export_data.colors, color_to_name)

  -- All highlights in one section with color variable references
  replacements["{{EDITOR_HIGHLIGHTS}}"] = format_all_highlights(export_data.highlights, color_to_name)

  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end

  return result
end

return M

