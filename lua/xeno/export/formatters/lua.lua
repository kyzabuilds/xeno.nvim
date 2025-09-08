local M = {}

local utils = require("xeno.export.utils")
local lua_template = require("xeno.export.templates.lua")

local fmt = string.format

-- Format color definitions for specific variant
local function format_color_definitions_variant(color_data, variant_name, config)
  local lines = {}
  
  -- Base colors
  if next(color_data.base_colors) then
    table.insert(lines, fmt("  -- %s base color scale", variant_name:gsub("^%l", string.upper)))
    local sorted_base = utils.sort_color_scale(color_data.base_colors, "base")
    for _, item in ipairs(sorted_base) do
      local color = utils.format_hex_color(item.color)
      table.insert(lines, fmt('  base_%d = "%s",', item.level, color))
    end
    table.insert(lines, "")
  end
  
  -- Accent colors
  if next(color_data.accent_colors) then
    table.insert(lines, fmt("  -- %s accent color scale", variant_name:gsub("^%l", string.upper)))
    local sorted_accent = utils.sort_color_scale(color_data.accent_colors, "accent")
    for _, item in ipairs(sorted_accent) do
      local color = utils.format_hex_color(item.color)
      table.insert(lines, fmt('  accent_%d = "%s",', item.level, color))
    end
    table.insert(lines, "")
  end
  
  -- Syntax variations (if included)
  if next(color_data.syntax_colors) then
    table.insert(lines, fmt("  -- %s syntax color variations", variant_name:gsub("^%l", string.upper)))
    for key, color in pairs(color_data.syntax_colors) do
      local formatted_color = utils.format_hex_color(color)
      table.insert(lines, fmt('  %s = "%s",', key, formatted_color))
    end
    table.insert(lines, "")
  end
  
  -- Semantic colors
  if next(color_data.semantic_colors) then
    table.insert(lines, fmt("  -- %s semantic colors", variant_name:gsub("^%l", string.upper)))
    local semantic_order = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }
    for _, name in ipairs(semantic_order) do
      if color_data.semantic_colors[name] then
        local color = utils.format_hex_color(color_data.semantic_colors[name])
        table.insert(lines, fmt('  %s = "%s",', name, color))
      end
    end
    table.insert(lines, "")
  end
  
  -- Custom colors
  if next(color_data.custom_colors) then
    table.insert(lines, fmt("  -- %s custom colors", variant_name:gsub("^%l", string.upper)))
    for name, color in pairs(color_data.custom_colors) do
      local formatted_color = utils.format_hex_color(color)
      table.insert(lines, fmt('  %s = "%s",', utils.sanitize_name(name), formatted_color))
    end
  end
  
  return table.concat(lines, "\n")
end

-- Format color definitions for Lua colorscheme (backwards compatible)
local function format_color_definitions(color_data, config)
  return format_color_definitions_variant(color_data, "theme", config)
end

-- Format highlight group for Lua
local function format_highlight_group(group_name, attrs)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end
  
  local normalized = utils.normalize_highlight_attrs(attrs)
  if not next(normalized) then
    return ""
  end
  
  local parts = {}
  
  -- Add color attributes
  if normalized.fg then table.insert(parts, fmt('fg = "%s"', normalized.fg)) end
  if normalized.bg then table.insert(parts, fmt('bg = "%s"', normalized.bg)) end
  if normalized.sp then table.insert(parts, fmt('sp = "%s"', normalized.sp)) end
  
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

-- Format highlights section
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

-- Format terminal colors for Lua
local function format_terminal_colors(color_data, config)
  if not config.include_terminal then
    return "-- Terminal colors disabled"
  end
  
  local lines = {
    "-- Set terminal colors",
    "if vim.fn.has('nvim') == 1 then",
  }
  
  -- Define terminal color mappings
  local terminal_mappings = {
    { index = 0,  color_key = "base_950", fallback = "#000000", desc = "black" },
    { index = 1,  color_key = "red",      fallback = "#E86671", desc = "red" },
    { index = 2,  color_key = "green",    fallback = "#A9DC76", desc = "green" },
    { index = 3,  color_key = "yellow",   fallback = "#E7C547", desc = "yellow" },
    { index = 4,  color_key = "blue",     fallback = "#66B2FF", desc = "blue" },
    { index = 5,  color_key = "purple",   fallback = "#A37EE5", desc = "magenta" },
    { index = 6,  color_key = "cyan",     fallback = "#78DCE8", desc = "cyan" },
    { index = 7,  color_key = "base_200", fallback = "#FFFFFF", desc = "white" },
    { index = 8,  color_key = "base_700", fallback = "#666666", desc = "bright black" },
    { index = 9,  color_key = "red",      fallback = "#E86671", desc = "bright red" },
    { index = 10, color_key = "green",    fallback = "#A9DC76", desc = "bright green" },
    { index = 11, color_key = "yellow",   fallback = "#E7C547", desc = "bright yellow" },
    { index = 12, color_key = "blue",     fallback = "#66B2FF", desc = "bright blue" },
    { index = 13, color_key = "purple",   fallback = "#A37EE5", desc = "bright magenta" },
    { index = 14, color_key = "cyan",     fallback = "#78DCE8", desc = "bright cyan" },
    { index = 15, color_key = "base_50",  fallback = "#FFFFFF", desc = "bright white" },
  }
  
  for _, mapping in ipairs(terminal_mappings) do
    -- Try to find the color in our data, otherwise use fallback
    local color = mapping.fallback
    if mapping.color_key:match("^base_") then
      local level = tonumber(mapping.color_key:match("base_(%d+)"))
      if level and color_data.base_colors[level] then
        color = color_data.base_colors[level]
      end
    elseif color_data.semantic_colors[mapping.color_key] then
      color = color_data.semantic_colors[mapping.color_key]
    end
    
    color = utils.format_hex_color(color)
    table.insert(lines, fmt('  vim.g.terminal_color_%d = "%s"', mapping.index, color))
  end
  
  table.insert(lines, "end")
  
  return table.concat(lines, "\n")
end

-- Main formatting function
function M.format_colorscheme(export_data)
  local template = lua_template.template
  local replacements = {}
  
  -- Header comment
  if export_data.config.include_metadata then
    replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, "--")
  else
    replacements["{{HEADER_COMMENT}}"] = "-- xeno.nvim exported theme"
  end
  
  -- Theme name
  local theme_name = utils.sanitize_name("xeno_exported_theme")
  replacements["{{THEME_NAME}}"] = theme_name
  
  -- Check if this is dual-variant export
  if export_data.config.export_both_variants and export_data.dark and export_data.light then
    -- Generate theme-switching colorscheme
    
    -- Color definitions for both variants
    local dark_colors = format_color_definitions_variant(export_data.dark.colors, "dark", export_data.config)
    local light_colors = format_color_definitions_variant(export_data.light.colors, "light", export_data.config)
    
    replacements["{{COLOR_DEFINITIONS}}"] = fmt([[
local colors = {}

local function get_colors()
  local variant = vim.o.background == "light" and "light" or "dark"
  
  if variant == "light" then
    return {
%s
    }
  else
    return {
%s
    }
  end
end]], light_colors, dark_colors)
    
    -- Generate highlight functions for both variants
    local dark_highlights = export_data.dark.highlights
    local light_highlights = export_data.light.highlights
    
    -- Generate highlight application functions
    local function format_variant_highlights(highlights, variant_name)
      local sections = {
        fmt("  -- %s editor highlights", variant_name:gsub("^%l", string.upper)),
        format_highlights_section(highlights.editor, "Editor"),
        "",
        fmt("  -- %s syntax highlights", variant_name:gsub("^%l", string.upper)),
        format_highlights_section(highlights.syntax, "Syntax"),
        "",
        fmt("  -- %s treesitter highlights", variant_name:gsub("^%l", string.upper)),
        format_highlights_section(highlights.treesitter, "TreeSitter"),
        "",
        fmt("  -- %s LSP highlights", variant_name:gsub("^%l", string.upper)),
        format_highlights_section(highlights.lsp, "LSP"),
      }
      
      if export_data.config.include_plugins then
        table.insert(sections, "")
        table.insert(sections, fmt("  -- %s plugin highlights", variant_name:gsub("^%l", string.upper)))
        table.insert(sections, format_highlights_section(highlights.plugins, "Plugins"))
      end
      
      table.insert(sections, "")
      table.insert(sections, fmt("  -- %s other highlights", variant_name:gsub("^%l", string.upper)))
      table.insert(sections, format_highlights_section(highlights.other, "Other"))
      
      return table.concat(sections, "\n")
    end
    
    local apply_highlights = fmt([[
local function apply_highlights()
  colors = get_colors()
  local variant = vim.o.background == "light" and "light" or "dark"
  
  if variant == "light" then
%s
  else
%s
  end
end]], format_variant_highlights(light_highlights, "light"), format_variant_highlights(dark_highlights, "dark"))
    
    -- Combine all highlight sections into one dynamic function
    replacements["{{EDITOR_HIGHLIGHTS}}"] = apply_highlights
    replacements["{{SYNTAX_HIGHLIGHTS}}"] = ""
    replacements["{{TREESITTER_HIGHLIGHTS}}"] = ""
    replacements["{{LSP_HIGHLIGHTS}}"] = ""
    replacements["{{PLUGIN_HIGHLIGHTS}}"] = ""
    replacements["{{OTHER_HIGHLIGHTS}}"] = ""
    
    -- Terminal colors (use dark variant as default, but make it theme-aware)
    replacements["{{TERMINAL_COLORS}}"] = fmt([[
-- Set terminal colors (theme-aware)
if vim.fn.has('nvim') == 1 then
  local colors = get_colors()
  %s
end]], format_terminal_colors(export_data.dark.colors, export_data.config):gsub("if vim.fn.has%('nvim'%) == 1 then\n", ""):gsub("\nend$", ""))
    
  else
    -- Single variant export (legacy mode)
    
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
      replacements["{{PLUGIN_HIGHLIGHTS}}"] = "-- Plugin highlights disabled"
    end
    
    replacements["{{OTHER_HIGHLIGHTS}}"] = format_highlights_section(highlights.other, "Other")
    
    -- Terminal colors
    replacements["{{TERMINAL_COLORS}}"] = format_terminal_colors(export_data.colors, export_data.config)
  end
  
  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end
  
  -- Minify if requested
  if export_data.config.minify then
    result = utils.minify_lua(result)
  end
  
  return result
end

return M