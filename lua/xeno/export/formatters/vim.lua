local M = {}

local utils = require("xeno.export.utils")
local vim_template = require("xeno.export.templates.vim")

local fmt = string.format

-- Format color definitions for Vim colorscheme
local function format_color_definitions(color_data, config)
  local lines = {
    "let s:colors = {",
  }
  
  -- Base colors
  if next(color_data.base_colors) then
    table.insert(lines, "  \\ 'base': {")
    local sorted_base = utils.sort_color_scale(color_data.base_colors, "base")
    for i, item in ipairs(sorted_base) do
      local color = utils.format_hex_color(item.color)
      local separator = i == #sorted_base and "" or ","
      table.insert(lines, fmt("  \\   '%d': '%s'%s", item.level, color, separator))
    end
    table.insert(lines, "  \\ },")
  end
  
  -- Accent colors
  if next(color_data.accent_colors) then
    table.insert(lines, "  \\ 'accent': {")
    local sorted_accent = utils.sort_color_scale(color_data.accent_colors, "accent")
    for i, item in ipairs(sorted_accent) do
      local color = utils.format_hex_color(item.color)
      local separator = i == #sorted_accent and "" or ","
      table.insert(lines, fmt("  \\   '%d': '%s'%s", item.level, color, separator))
    end
    table.insert(lines, "  \\ },")
  end
  
  -- Semantic colors
  if next(color_data.semantic_colors) then
    local semantic_order = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }
    for _, name in ipairs(semantic_order) do
      if color_data.semantic_colors[name] then
        local color = utils.format_hex_color(color_data.semantic_colors[name])
        table.insert(lines, fmt("  \\ '%s': '%s',", name, color))
      end
    end
  end
  
  -- Custom colors (flattened for vim script simplicity)
  if next(color_data.custom_colors) then
    for name, color in pairs(color_data.custom_colors) do
      local formatted_color = utils.format_hex_color(color)
      local sanitized_name = utils.sanitize_name(name)
      table.insert(lines, fmt("  \\ '%s': '%s',", sanitized_name, formatted_color))
    end
  end
  
  table.insert(lines, "\\ }")
  
  return table.concat(lines, "\n")
end

-- Format highlight group for Vim
local function format_highlight_group(group_name, attrs)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end
  
  local normalized = utils.normalize_highlight_attrs(attrs)
  if not next(normalized) then
    return ""
  end
  
  local cmd_parts = { fmt("highlight %s", group_name) }
  
  -- Add color attributes
  if normalized.fg then
    table.insert(cmd_parts, fmt("guifg=%s", normalized.fg))
  end
  if normalized.bg then
    table.insert(cmd_parts, fmt("guibg=%s", normalized.bg))
  end
  if normalized.sp then
    table.insert(cmd_parts, fmt("guisp=%s", normalized.sp))
  end
  
  -- Add style attributes
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
    table.insert(cmd_parts, fmt("gui=%s", table.concat(gui_attrs, ",")))
  end
  
  return table.concat(cmd_parts, " ")
end

-- Format highlights section for Vim
local function format_highlights_section(highlights, section_name)
  if not highlights or not next(highlights) then
    return ""
  end
  
  local lines = {}
  
  -- Sort highlight groups for consistent output
  local sorted_groups = {}
  for group, attrs in pairs(highlights) do
    table.insert(sorted_groups, { group = group, attrs = attrs })
  end
  table.sort(sorted_groups, function(a, b) return a.group < b.group end)
  
  for _, item in ipairs(sorted_groups) do
    local formatted = format_highlight_group(item.group, item.attrs)
    if formatted ~= "" then
      table.insert(lines, formatted)
    end
  end
  
  return table.concat(lines, "\n")
end

-- Format terminal colors for Vim
local function format_terminal_colors(color_data, config)
  if not config.include_terminal then
    return "\" Terminal colors disabled"
  end
  
  local lines = {
    "\" Set terminal colors",
    "if has('nvim')",
  }
  
  -- Define terminal color mappings
  local terminal_mappings = {
    { index = 0,  color = "base_950", fallback = "#000000", desc = "black" },
    { index = 1,  color = "red",      fallback = "#E86671", desc = "red" },
    { index = 2,  color = "green",    fallback = "#A9DC76", desc = "green" },
    { index = 3,  color = "yellow",   fallback = "#E7C547", desc = "yellow" },
    { index = 4,  color = "blue",     fallback = "#66B2FF", desc = "blue" },
    { index = 5,  color = "purple",   fallback = "#A37EE5", desc = "magenta" },
    { index = 6,  color = "cyan",     fallback = "#78DCE8", desc = "cyan" },
    { index = 7,  color = "base_200", fallback = "#FFFFFF", desc = "white" },
    { index = 8,  color = "base_700", fallback = "#666666", desc = "bright black" },
    { index = 9,  color = "red",      fallback = "#E86671", desc = "bright red" },
    { index = 10, color = "green",    fallback = "#A9DC76", desc = "bright green" },
    { index = 11, color = "yellow",   fallback = "#E7C547", desc = "bright yellow" },
    { index = 12, color = "blue",     fallback = "#66B2FF", desc = "bright blue" },
    { index = 13, color = "purple",   fallback = "#A37EE5", desc = "bright magenta" },
    { index = 14, color = "cyan",     fallback = "#78DCE8", desc = "bright cyan" },
    { index = 15, color = "base_50",  fallback = "#FFFFFF", desc = "bright white" },
  }
  
  for _, mapping in ipairs(terminal_mappings) do
    -- Try to find the color in our data, otherwise use fallback
    local color = mapping.fallback
    if mapping.color == "red" and color_data.semantic_colors.red then
      color = color_data.semantic_colors.red
    elseif mapping.color == "green" and color_data.semantic_colors.green then
      color = color_data.semantic_colors.green  
    elseif mapping.color == "yellow" and color_data.semantic_colors.yellow then
      color = color_data.semantic_colors.yellow
    elseif mapping.color == "blue" and color_data.semantic_colors.blue then
      color = color_data.semantic_colors.blue
    elseif mapping.color == "purple" and color_data.semantic_colors.purple then
      color = color_data.semantic_colors.purple
    elseif mapping.color == "cyan" and color_data.semantic_colors.cyan then
      color = color_data.semantic_colors.cyan
    elseif mapping.color:match("^base_") then
      local level = mapping.color:match("base_(%d+)")
      if level and color_data.base_colors[tonumber(level)] then
        color = color_data.base_colors[tonumber(level)]
      end
    end
    
    color = utils.format_hex_color(color)
    table.insert(lines, fmt("  let g:terminal_color_%d = '%s'", mapping.index, color))
  end
  
  table.insert(lines, "endif")
  
  return table.concat(lines, "\n")
end

-- Main formatting function
function M.format_colorscheme(export_data)
  local template = vim_template.template
  local replacements = {}
  
  -- Header comment
  if export_data.config.include_metadata then
    replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, '"')
  else
    replacements["{{HEADER_COMMENT}}"] = '" xeno.nvim exported theme'
  end
  
  -- Theme name
  local theme_name = utils.sanitize_name("xeno_exported_theme")
  replacements["{{THEME_NAME}}"] = theme_name
  
  -- Color definitions
  replacements["{{COLOR_DEFINITIONS}}"] = format_color_definitions(export_data.colors, export_data.config)
  
  -- Highlight sections
  local highlights = export_data.highlights
  replacements["{{EDITOR_HIGHLIGHTS}}"] = format_highlights_section(highlights.editor, "Editor")
  replacements["{{SYNTAX_HIGHLIGHTS}}"] = format_highlights_section(highlights.syntax, "Syntax")
  replacements["{{TREESITTER_HIGHLIGHTS}}"] = format_highlights_section(highlights.treesitter, "TreeSitter")
  replacements["{{LSP_HIGHLIGHTS}}"] = format_highlights_section(highlights.lsp, "LSP")
  
  if export_data.config.include_plugins then
    replacements["{{PLUGIN_HIGHLIGHTS}}"] = format_highlights_section(highlights.plugins, "Plugins")
  else
    replacements["{{PLUGIN_HIGHLIGHTS}}"] = '" Plugin highlights disabled'
  end
  
  replacements["{{OTHER_HIGHLIGHTS}}"] = format_highlights_section(highlights.other, "Other")
  
  -- Terminal colors
  replacements["{{TERMINAL_COLORS}}"] = format_terminal_colors(export_data.colors, export_data.config)
  
  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end
  
  -- Minify if requested
  if export_data.config.minify then
    result = utils.minify_vim(result)
  end
  
  return result
end

return M