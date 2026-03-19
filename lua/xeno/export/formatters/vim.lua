local M = {}

local utils = require("xeno.export.utils")
local vim_template = require("xeno.export.templates.vim")

local fmt = string.format

-- Format highlight group for Vim with color variable references
local function format_highlight_group(group_name, attrs, color_to_name)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end

  -- Build the command using execute with variable interpolation if any colors use variables
  local uses_variables = false
  local fg_part = ""
  local bg_part = ""
  local sp_part = ""
  local gui_part = ""

  -- Process color attributes with proper lookup before normalization
  -- This prevents valid colors from being converted to #000000
  if attrs.fg then
    -- First try to look up the color as-is
    local fg_normalized = utils.format_hex_color(attrs.fg)
    local var_name = color_to_name[fg_normalized:upper()]
    if var_name then
      fg_part = " guifg=' . s:colors[\"" .. var_name .. "\"] . '"
      uses_variables = true
    else
      fg_part = " guifg=" .. fg_normalized
    end
  end

  if attrs.bg then
    -- First try to look up the color as-is
    local bg_normalized = utils.format_hex_color(attrs.bg)
    local var_name = color_to_name[bg_normalized:upper()]
    if var_name then
      bg_part = " guibg=' . s:colors[\"" .. var_name .. "\"] . '"
      uses_variables = true
    else
      bg_part = " guibg=" .. bg_normalized
    end
  end

  if attrs.sp then
    -- First try to look up the color as-is
    local sp_normalized = utils.format_hex_color(attrs.sp)
    local var_name = color_to_name[sp_normalized:upper()]
    if var_name then
      sp_part = " guisp=' . s:colors[\"" .. var_name .. "\"] . '"
      uses_variables = true
    else
      sp_part = " guisp=" .. sp_normalized
    end
  end

  -- Now process style attributes
  local normalized = utils.normalize_highlight_attrs(attrs)

  -- Collect style attributes
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

  if #gui_attrs > 0 then
    gui_part = " gui=" .. table.concat(gui_attrs, ",")
  end

  if uses_variables then
    return fmt("execute 'highlight %s%s%s%s%s'", group_name, fg_part, bg_part, sp_part, gui_part)
  else
    -- Use simple highlight command for non-variable colors
    local cmd_parts = { fmt("highlight %s", group_name) }
    if normalized.fg then
      table.insert(cmd_parts, fmt("guifg=%s", normalized.fg))
    end
    if normalized.bg then
      table.insert(cmd_parts, fmt("guibg=%s", normalized.bg))
    end
    if normalized.sp then
      table.insert(cmd_parts, fmt("guisp=%s", normalized.sp))
    end
    if #gui_attrs > 0 then
      table.insert(cmd_parts, fmt("gui=%s", table.concat(gui_attrs, ",")))
    end
    return table.concat(cmd_parts, " ")
  end
end

-- Format highlights using the dynamic colors variable for variant-aware exports
local function format_dynamic_highlights_vim(highlights, organized_colors)
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

  -- Sort highlight groups for consistent output
  local sorted_groups = {}
  for group, attrs in pairs(highlights) do
    table.insert(sorted_groups, { group = group, attrs = attrs })
  end
  table.sort(sorted_groups, function(a, b)
    return a.group < b.group
  end)

  for _, item in ipairs(sorted_groups) do
    local formatted = format_highlight_group(item.group, item.attrs, color_lookup)
    if formatted ~= "" then
      table.insert(lines, "  " .. formatted)
    end
  end

  return table.concat(lines, "\n")
end

-- Main formatting function
function M.format_colorscheme(export_data)
  local template = vim_template.template
  local replacements = {}

  -- Header comment
  replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, '"')

  -- Theme name
  local theme_name = utils.sanitize_name("xeno_exported_theme")
  replacements["{{THEME_NAME}}"] = theme_name

  -- Check if we have variant-aware data structure
  if export_data.colors.variant_colors then
    -- Generate separate color definitions for each variant
    replacements["{{LIGHT_COLOR_DEFINITIONS_VIM}}"] = utils.generate_variant_color_definitions(export_data.colors, "light", "vim")
    replacements["{{DARK_COLOR_DEFINITIONS_VIM}}"] = utils.generate_variant_color_definitions(export_data.colors, "dark", "vim")

    -- Generate dynamic highlights that use the s:colors variable
    replacements["{{EDITOR_HIGHLIGHTS_VIM}}"] = format_dynamic_highlights_vim(export_data.highlights, export_data.colors)
  end

  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end

  return result
end

return M
