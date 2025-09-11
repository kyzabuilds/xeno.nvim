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

-- Filter the xeno color palette to only include color families that are actually used
local function get_filtered_color_palette(highlights)
  local xeno = package.loaded["xeno"]
  if not xeno or not xeno.colors then
    return nil, "xeno.nvim colors not available. Please run xeno.setup() first"
  end

  local used_color_values, used_semantic_colors = extract_used_colors_from_highlights(highlights)
  local used_color_families = {}
  local filtered_colors = {}

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

  -- Second pass: Include all colors from the used families and referenced semantic colors
  for color_name, color_value in pairs(xeno.colors) do
    if type(color_value) == "string" and color_value:match("^#[0-9a-fA-F]+$") then
      local family = color_name:match("^(.-)_%d+$") or color_name
      local is_semantic = false

      -- Check if this is a semantic color
      for _, semantic in ipairs(semantic_colors) do
        if color_name == semantic then
          is_semantic = true
          break
        end
      end

      -- Include if:
      -- 1. It's from a used color family (color scale)
      -- 2. It's a semantic color that was referenced by name in the original config
      -- 3. It's directly used as a hex value in highlights
      if used_color_families[family] or not color_name:match("_") then
        -- For non-scale colors (semantic colors), include if:
        -- - It's a semantic color that was referenced by name in user config
        -- - It's a standard semantic color (for safety)
        -- - It's directly used as a hex value
        if not color_name:match("_%d+$") then
          if used_semantic_colors[color_name] or is_semantic or used_color_values[color_value:upper()] then
            filtered_colors[color_name] = color_value
          end
        else
          -- For scale colors, include entire family if any level is used
          filtered_colors[color_name] = color_value
        end
      end
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

-- Generate basic metadata for the exported theme
local function generate_metadata()
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local variant = vim.o.background or "dark"

  return {
    timestamp = timestamp,
    variant = variant,
    exported_by = "xeno.nvim export",
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

  -- Prepare export data with complete color palette
  local export_data = {
    highlights = current_highlights,
    colors = color_palette,
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
  }
end

return M
