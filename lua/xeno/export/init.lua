local M = {}

local utils = require("xeno.core.utils")
local highlight_generator = require("xeno.highlights")
local defaults = require("xeno.config.defaults")
local export_utils = require("xeno.export.utils")
local lua_formatter = require("xeno.export.formatters.lua")
local vim_formatter = require("xeno.export.formatters.vim")

local fmt = string.format

-- Default export configuration
local DEFAULT_EXPORT_CONFIG = {
  format = "lua",
  output = "~/.config/nvim/colors/",
  filename = nil,
  include_plugins = true,
  include_terminal = true,
  include_metadata = true,
  minify = false,
  export_both_variants = true,  -- Export both light and dark mode support
}

-- Validate export configuration
local function validate_export_config(config)
  config = config or {}
  
  -- Validate format
  if config.format and config.format ~= "lua" and config.format ~= "vim" then
    return nil, fmt("Invalid format '%s'. Must be 'lua' or 'vim'", config.format)
  end
  
  -- Validate output directory exists or can be created
  if config.output then
    local expanded_output = vim.fn.expand(config.output)
    if not export_utils.ensure_directory(expanded_output) then
      return nil, fmt("Cannot create or access output directory: %s", expanded_output)
    end
  end
  
  return true
end

-- Generate color data for a specific theme variant
local function generate_color_data_for_variant(theme_config, variant)
  local palette_generator = require("xeno.core.palette")
  local temp_variant = vim.o.background
  
  -- Temporarily set the background to generate the right palette
  vim.o.background = variant
  local colors = palette_generator.generate_palette(theme_config)
  vim.o.background = temp_variant  -- Restore original
  
  local color_data = {
    base_colors = {},
    accent_colors = {},
    syntax_colors = {},
    semantic_colors = {},
    custom_colors = {},
  }
  
  -- Extract base color scale
  local scale_levels = { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 }
  for _, level in ipairs(scale_levels) do
    color_data.base_colors[level] = colors[fmt("base_%d", level)]
  end
  
  -- Extract accent color scale
  for _, level in ipairs(scale_levels) do
    color_data.accent_colors[level] = colors[fmt("accent_%d", level)]
  end
  
  -- Extract syntax variations
  for _, level in ipairs(scale_levels) do
    color_data.syntax_colors[fmt("syntax_base_%d", level)] = colors[fmt("syntax_base_%d", level)]
    color_data.syntax_colors[fmt("syntax_accent_%d", level)] = colors[fmt("syntax_accent_%d", level)]
  end
  
  -- Extract semantic colors
  local semantic_names = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }
  for _, name in ipairs(semantic_names) do
    if colors[name] then
      color_data.semantic_colors[name] = colors[name]
    end
  end
  
  -- Extract custom colors (if any)
  if theme_config._custom_colors then
    for name, hex_value in pairs(theme_config._custom_colors) do
      -- Include both the raw custom color and its scale if generated
      color_data.custom_colors[name] = hex_value
      
      -- Include scale variations if they exist
      for _, level in ipairs(scale_levels) do
        local scale_key = fmt("%s_%d", name, level)
        if colors[scale_key] then
          color_data.custom_colors[scale_key] = colors[scale_key]
        end
      end
    end
  end
  
  return color_data, colors
end

-- Extract color data from current xeno theme (legacy function for compatibility)
local function extract_color_data(xeno_colors, custom_colors)
  if not xeno_colors then
    return nil, "No xeno colors available. Please run xeno.setup() first"
  end
  
  local color_data = {
    base_colors = {},
    accent_colors = {},
    syntax_colors = {},
    semantic_colors = {},
    custom_colors = {},
  }
  
  -- Extract base color scale
  local scale_levels = { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 }
  for _, level in ipairs(scale_levels) do
    color_data.base_colors[level] = xeno_colors[fmt("base_%d", level)]
  end
  
  -- Extract accent color scale
  for _, level in ipairs(scale_levels) do
    color_data.accent_colors[level] = xeno_colors[fmt("accent_%d", level)]
  end
  
  -- Extract syntax variations
  for _, level in ipairs(scale_levels) do
    color_data.syntax_colors[fmt("syntax_base_%d", level)] = xeno_colors[fmt("syntax_base_%d", level)]
    color_data.syntax_colors[fmt("syntax_accent_%d", level)] = xeno_colors[fmt("syntax_accent_%d", level)]
  end
  
  -- Extract semantic colors
  local semantic_names = { "red", "green", "yellow", "orange", "blue", "purple", "cyan" }
  for _, name in ipairs(semantic_names) do
    if xeno_colors[name] then
      color_data.semantic_colors[name] = xeno_colors[name]
    end
  end
  
  -- Extract custom colors (if any)
  if custom_colors then
    for name, hex_value in pairs(custom_colors) do
      -- Include both the raw custom color and its scale if generated
      color_data.custom_colors[name] = hex_value
      
      -- Include scale variations if they exist
      for _, level in ipairs(scale_levels) do
        local scale_key = fmt("%s_%d", name, level)
        if xeno_colors[scale_key] then
          color_data.custom_colors[scale_key] = xeno_colors[scale_key]
        end
      end
    end
  end
  
  return color_data
end

-- Generate highlight data for a specific theme variant  
local function generate_highlight_data_for_variant(colors, config, variant)
  -- Temporarily set background for highlight generation
  local temp_variant = vim.o.background
  vim.o.background = variant
  
  -- Generate base highlights using the same logic as setup
  local highlights = highlight_generator.generate_base_highlights(colors, config)
  
  -- Restore original background
  vim.o.background = temp_variant
  
  -- Organize highlights by category for better structure in output
  local organized_highlights = {
    editor = {},
    syntax = {},
    treesitter = {},
    lsp = {},
    plugins = {},
    other = {},
  }
  
  -- Categorize highlights
  for group, attrs in pairs(highlights) do
    if group:match("^@") then
      organized_highlights.treesitter[group] = attrs
    elseif group:match("^Diagnostic") or group:match("^Lsp") then
      organized_highlights.lsp[group] = attrs
    elseif group:match("^Comment$") or group:match("^String$") or group:match("^Function$") or 
           group:match("^Keyword$") or group:match("^Type$") or group:match("^Constant$") or
           group:match("^Special$") or group:match("^PreProc$") or group:match("^Identifier$") then
      organized_highlights.syntax[group] = attrs
    elseif group:match("^Normal$") or group:match("^Visual") or group:match("^Cursor") or
           group:match("^StatusLine") or group:match("^LineNr") or group:match("^SignColumn") or
           group:match("^Float") or group:match("^Pmenu") then
      organized_highlights.editor[group] = attrs
    elseif group:match("^Telescope") or group:match("^Cmp") or group:match("^GitSigns") or
           group:match("^BufferLine") or group:match("^WhichKey") or group:match("^NvimTree") then
      organized_highlights.plugins[group] = attrs
    else
      organized_highlights.other[group] = attrs
    end
  end
  
  return organized_highlights
end

-- Extract highlight data from current theme (legacy function for compatibility)
local function extract_highlight_data(colors, config)
  -- Generate base highlights using the same logic as setup
  local highlights = highlight_generator.generate_base_highlights(colors, config)
  
  -- Organize highlights by category for better structure in output
  local organized_highlights = {
    editor = {},
    syntax = {},
    treesitter = {},
    lsp = {},
    plugins = {},
    other = {},
  }
  
  -- Categorize highlights
  for group, attrs in pairs(highlights) do
    if group:match("^@") then
      organized_highlights.treesitter[group] = attrs
    elseif group:match("^Diagnostic") or group:match("^Lsp") then
      organized_highlights.lsp[group] = attrs
    elseif group:match("^Comment$") or group:match("^String$") or group:match("^Function$") or 
           group:match("^Keyword$") or group:match("^Type$") or group:match("^Constant$") or
           group:match("^Special$") or group:match("^PreProc$") or group:match("^Identifier$") then
      organized_highlights.syntax[group] = attrs
    elseif group:match("^Normal$") or group:match("^Visual") or group:match("^Cursor") or
           group:match("^StatusLine") or group:match("^LineNr") or group:match("^SignColumn") or
           group:match("^Float") or group:match("^Pmenu") then
      organized_highlights.editor[group] = attrs
    elseif group:match("^Telescope") or group:match("^Cmp") or group:match("^GitSigns") or
           group:match("^BufferLine") or group:match("^WhichKey") or group:match("^NvimTree") then
      organized_highlights.plugins[group] = attrs
    else
      organized_highlights.other[group] = attrs
    end
  end
  
  return organized_highlights
end

-- Generate metadata for the exported theme
local function generate_metadata(config, base_color, accent_color)
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local variant = utils.get_variant() == 1 and "dark" or "light"
  
  return {
    timestamp = timestamp,
    variant = variant,
    base_color = base_color or "#000000",
    accent_color = accent_color or "#7AA2F7",
    xeno_version = "1.0.0", -- Could be extracted from plugin version
    variation = config.variation or 0,
    contrast = config.contrast or 0,
  }
end

-- Main export function
function M.export_theme(config)
  config = utils.extend("force", DEFAULT_EXPORT_CONFIG, config or {})
  
  -- Validate configuration
  local ok, err = validate_export_config(config)
  if not ok then
    return nil, err
  end
  
  -- Check if xeno is currently loaded
  local xeno = package.loaded["xeno"]
  if not xeno or not xeno._global_config then
    return nil, "xeno.nvim theme is not currently loaded. Please run xeno.setup() first"
  end
  
  -- Use current global config for theme generation
  local theme_config = utils.extend("force", defaults.config, xeno._global_config or {})
  
  local export_data, format_err, content
  
  if config.export_both_variants then
    -- Generate both light and dark variants
    local dark_color_data, dark_colors = generate_color_data_for_variant(theme_config, "dark")
    local light_color_data, light_colors = generate_color_data_for_variant(theme_config, "light")
    
    local dark_highlights = generate_highlight_data_for_variant(dark_colors, theme_config, "dark")
    local light_highlights = generate_highlight_data_for_variant(light_colors, theme_config, "light")
    
    -- Generate metadata based on dark variant (traditional default)
    local base_color = dark_color_data.base_colors[900] or "#000000"
    local accent_color = dark_color_data.accent_colors[500] or "#7AA2F7"
    local metadata = generate_metadata(theme_config, base_color, accent_color)
    
    -- Prepare dual-variant export data
    export_data = {
      dark = {
        colors = dark_color_data,
        highlights = dark_highlights,
      },
      light = {
        colors = light_color_data, 
        highlights = light_highlights,
      },
      metadata = metadata,
      config = {
        include_plugins = config.include_plugins,
        include_terminal = config.include_terminal,
        include_metadata = config.include_metadata,
        minify = config.minify,
        export_both_variants = true,
      }
    }
  else
    -- Legacy mode: export only current variant
    local custom_colors = xeno._global_config and xeno._global_config._custom_colors or {}
    local color_data, color_err = extract_color_data(xeno.colors, custom_colors)
    if not color_data then
      return nil, color_err
    end
    
    local highlight_data = extract_highlight_data(xeno.colors, theme_config)
    
    -- Generate metadata
    local base_color = color_data.base_colors[900] or "#000000"
    local accent_color = color_data.accent_colors[500] or "#7AA2F7"
    local metadata = generate_metadata(theme_config, base_color, accent_color)
    
    -- Prepare single-variant export data (legacy format)
    export_data = {
      colors = color_data,
      highlights = highlight_data,
      metadata = metadata,
      config = {
        include_plugins = config.include_plugins,
        include_terminal = config.include_terminal,
        include_metadata = config.include_metadata,
        minify = config.minify,
        export_both_variants = false,
      }
    }
  end
  
  -- Generate the colorscheme file
  local formatter = config.format == "vim" and vim_formatter or lua_formatter
  content, format_err = formatter.format_colorscheme(export_data)
  if not content then
    return nil, fmt("Error formatting colorscheme: %s", format_err)
  end
  
  -- Determine output filename
  local filename = config.filename
  if not filename then
    filename = export_utils.generate_filename(config.format, export_data.metadata)
  end
  
  -- Ensure filename has correct extension
  local extension = config.format == "vim" and ".vim" or ".lua"
  if not filename:match("%." .. config.format .. "$") and not filename:match("%.lua$") and not filename:match("%.vim$") then
    filename = filename .. extension
  end
  
  -- Write to file
  local output_dir = vim.fn.expand(config.output)
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
    variants_exported = config.export_both_variants and {"dark", "light"} or {utils.get_variant() == 1 and "dark" or "light"},
  }
end

return M