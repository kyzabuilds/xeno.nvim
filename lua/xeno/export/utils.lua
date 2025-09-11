local M = {}

local fmt = string.format

-- Join path components, handling different OS path separators
function M.join_path(...)
  local parts = { ... }
  local path = table.concat(parts, "/")
  return path:gsub("//+", "/") -- Clean up double slashes
end

-- Ensure a directory exists, create if it doesn't
function M.ensure_directory(path)
  if not path or path == "" then
    return false
  end

  -- Expand ~ and environment variables
  local expanded_path = vim.fn.expand(path)

  -- Check if directory exists
  local stat = vim.loop.fs_stat(expanded_path)
  if stat and stat.type == "directory" then
    return true
  end

  -- Try to create directory
  local success = vim.fn.mkdir(expanded_path, "p")
  return success == 1
end

-- Write content to file with error handling
function M.write_file(file_path, content)
  if not file_path or not content then
    return false, "Invalid file path or content"
  end

  -- Ensure parent directory exists
  local parent_dir = vim.fn.fnamemodify(file_path, ":h")
  if not M.ensure_directory(parent_dir) then
    return false, fmt("Cannot create parent directory: %s", parent_dir)
  end

  -- Write file
  local file = io.open(file_path, "w")
  if not file then
    return false, fmt("Cannot open file for writing: %s", file_path)
  end

  local success, err = file:write(content)
  file:close()

  if not success then
    return false, fmt("Error writing file: %s", err or "unknown error")
  end

  return true
end

-- Generate a filename based on theme properties
function M.generate_filename(format, metadata)
  local timestamp = os.date("%Y%m%d_%H%M%S")

  -- Extract color info for filename
  local base_suffix = metadata.base_color:gsub("#", ""):sub(1, 6)
  local accent_suffix = metadata.accent_color:gsub("#", ""):sub(1, 6)

  -- Create descriptive filename
  local name_parts = {
    "xeno",
    metadata.variant or "dark",
    base_suffix,
    accent_suffix,
  }

  -- Add variation/contrast info if significant
  if metadata.variation and metadata.variation ~= 0 then
    table.insert(name_parts, fmt("var%.1f", metadata.variation))
  end
  if metadata.contrast and metadata.contrast ~= 0 then
    table.insert(name_parts, fmt("con%.1f", metadata.contrast))
  end

  local base_name = table.concat(name_parts, "_")
  local extension = format == "vim" and ".vim" or ".lua"

  return base_name .. extension
end

-- Sanitize a string for use in code (variable names, etc.)
function M.sanitize_name(name)
  if not name or type(name) ~= "string" then
    return "invalid_name"
  end

  -- Replace invalid characters with underscores
  local sanitized = name:gsub("[^%w_]", "_")

  -- Ensure it starts with a letter or underscore
  if not sanitized:match("^[%a_]") then
    sanitized = "_" .. sanitized
  end

  return sanitized
end

-- Format a hex color for output (ensure # prefix, validate)
function M.format_hex_color(color)
  if not color or type(color) ~= "string" then
    return "#000000"
  end

  -- Add # prefix if missing
  if not color:match("^#") then
    color = "#" .. color
  end

  -- Validate hex format and length
  if color:match("^#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$") then
    -- 3-digit hex, expand to 6-digit
    local r, g, b = color:sub(2, 2), color:sub(3, 3), color:sub(4, 4)
    return fmt("#%s%s%s%s%s%s", r, r, g, g, b, b)
  elseif color:match("^#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$") then
    -- 6-digit hex, return as-is (but uppercase)
    return color:upper()
  else
    -- Invalid format, return black as fallback
    return "#000000"
  end
end

-- Sort colors by scale levels for organized output
function M.sort_color_scale(colors, prefix)
  local sorted = {}
  local scale_levels = { 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 }

  for _, level in ipairs(scale_levels) do
    local key = fmt("%s_%d", prefix, level)
    if colors[key] then
      table.insert(sorted, { level = level, key = key, color = colors[key] })
    end
  end

  return sorted
end

-- Group highlights by category patterns
function M.categorize_highlight(group_name)
  if group_name:match("^@") then
    return "treesitter"
  elseif group_name:match("^Diagnostic") or group_name:match("^Lsp") then
    return "lsp"
  elseif
    group_name:match("^Comment$")
    or group_name:match("^String$")
    or group_name:match("^Function$")
    or group_name:match("^Keyword$")
    or group_name:match("^Type$")
    or group_name:match("^Constant$")
    or group_name:match("^Special$")
    or group_name:match("^PreProc$")
    or group_name:match("^Identifier$")
  then
    return "syntax"
  elseif
    group_name:match("^Normal$")
    or group_name:match("^Visual")
    or group_name:match("^Cursor")
    or group_name:match("^StatusLine")
    or group_name:match("^LineNr")
    or group_name:match("^SignColumn")
    or group_name:match("^Float")
    or group_name:match("^Pmenu")
  then
    return "editor"
  elseif
    group_name:match("^Telescope")
    or group_name:match("^Cmp")
    or group_name:match("^GitSigns")
    or group_name:match("^BufferLine")
    or group_name:match("^WhichKey")
    or group_name:match("^NvimTree")
  then
    return "plugins"
  else
    return "other"
  end
end

-- Convert highlight attributes to a standardized format
function M.normalize_highlight_attrs(attrs)
  if type(attrs) ~= "table" then
    return {}
  end

  local normalized = {}

  -- Copy color attributes
  if attrs.fg then
    normalized.fg = M.format_hex_color(attrs.fg)
  end
  if attrs.bg then
    normalized.bg = M.format_hex_color(attrs.bg)
  end
  if attrs.sp then
    normalized.sp = M.format_hex_color(attrs.sp)
  end

  -- Copy style attributes
  local style_attrs = { "bold", "italic", "underline", "undercurl", "strikethrough", "reverse", "standout" }
  for _, attr in ipairs(style_attrs) do
    if attrs[attr] ~= nil then
      normalized[attr] = attrs[attr]
    end
  end

  -- Handle combined style attribute
  if attrs.style then
    if type(attrs.style) == "string" then
      -- Parse comma-separated style string
      for style in attrs.style:gmatch("[^,]+") do
        local trimmed = style:match("^%s*(.-)%s*$") -- trim whitespace
        normalized[trimmed] = true
      end
    elseif type(attrs.style) == "table" then
      for _, style in ipairs(attrs.style) do
        normalized[style] = true
      end
    end
  end

  return normalized
end

-- Create a comment header with metadata
function M.create_header_comment(metadata, comment_char)
  comment_char = comment_char or "--"
  local lines = {
    fmt("%s ========================================", comment_char),
    fmt("%s xeno.nvim exported theme", comment_char),
    fmt("%s Generated: %s", comment_char, metadata.timestamp),
    fmt("%s Base: %s | Accent: %s", comment_char, metadata.base_color, metadata.accent_color),
  }

  if metadata.variation and metadata.variation ~= 0 then
    table.insert(lines, fmt("%s Variation: %.1f", comment_char, metadata.variation))
  end
  if metadata.contrast and metadata.contrast ~= 0 then
    table.insert(lines, fmt("%s Contrast: %.1f", comment_char, metadata.contrast))
  end

  table.insert(lines, fmt("%s ========================================", comment_char))

  return table.concat(lines, "\n")
end

-- Escape string for inclusion in generated code
function M.escape_string(str)
  if not str or type(str) ~= "string" then
    return '""'
  end

  -- Escape quotes and backslashes
  return '"' .. str:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

-- Minify Lua code by removing unnecessary whitespace
function M.minify_lua(content)
  if not content then
    return ""
  end

  -- Simple minification: remove extra whitespace and empty lines
  local lines = {}
  for line in content:gmatch("[^\n]+") do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed ~= "" and not trimmed:match("^%-%-") then -- Skip empty lines and comments
      lines[#lines + 1] = trimmed
    end
  end

  return table.concat(lines, "\n")
end

-- Minify Vim script by removing unnecessary whitespace
function M.minify_vim(content)
  if not content then
    return ""
  end

  -- Simple minification: remove extra whitespace and empty lines
  local lines = {}
  for line in content:gmatch("[^\n]+") do
    local trimmed = line:match("^%s*(.-)%s*$")
    if trimmed ~= "" and not trimmed:match('^"') then -- Skip empty lines and comments
      lines[#lines + 1] = trimmed
    end
  end

  return table.concat(lines, "\n")
end

-- Generate variant-specific color definitions for the given variant
function M.generate_variant_color_definitions(organized_colors, variant, format_type)
  local lines = {}
  format_type = format_type or "lua"

  -- Helper function based on format type
  local function format_color_line(name, color, is_last)
    if format_type == "vim" then
      local separator = is_last and "" or ","
      return string.format("      \\ '%s': '%s'%s", name, M.format_hex_color(color), separator)
    else -- lua
      local separator = is_last and "" or ","
      return string.format('      %s = "%s"%s', name, M.format_hex_color(color), separator)
    end
  end

  -- Collect all colors from the appropriate variant
  local all_colors = {}
  local variant_colors = organized_colors.variant_colors and organized_colors.variant_colors[variant]

  if variant_colors then
    -- Use variant-specific colors
    for name, color in pairs(variant_colors) do
      local category = "semantic"
      if name:match("^base_%d+$") then
        category = "base"
      elseif name:match("^accent_%d+$") then
        category = "accent"
      elseif name:match("^syntax_base_%d+$") then
        category = "syntax_base"
      elseif name:match("^syntax_accent_%d+$") then
        category = "syntax_accent"
      elseif name:match("^[^_]+_%d+$") then
        category = "custom"
      end
      table.insert(all_colors, { name = name, color = color, category = category })
    end
  else
    -- Fallback to organized colors
    for name, color in pairs(organized_colors.base_colors or {}) do
      table.insert(all_colors, { name = name, color = color, category = "base" })
    end

    for name, color in pairs(organized_colors.accent_colors or {}) do
      table.insert(all_colors, { name = name, color = color, category = "accent" })
    end

    for name, color in pairs(organized_colors.syntax_base_colors or {}) do
      table.insert(all_colors, { name = name, color = color, category = "syntax_base" })
    end

    for name, color in pairs(organized_colors.syntax_accent_colors or {}) do
      table.insert(all_colors, { name = name, color = color, category = "syntax_accent" })
    end

    for name, color in pairs(organized_colors.custom_colors or {}) do
      table.insert(all_colors, { name = name, color = color, category = "custom" })
    end

    for name, color in pairs(organized_colors.semantic_colors or {}) do
      table.insert(all_colors, { name = name, color = color, category = "semantic" })
    end
  end

  -- Sort colors for consistent output
  table.sort(all_colors, function(a, b)
    if a.category == b.category then
      return a.name < b.name
    end
    -- Order: base, accent, syntax_base, syntax_accent, custom, semantic
    local category_order = { base = 1, accent = 2, syntax_base = 3, syntax_accent = 4, custom = 5, semantic = 6 }
    return category_order[a.category] < category_order[b.category]
  end)

  -- Generate the formatted lines
  for i, item in ipairs(all_colors) do
    local is_last = i == #all_colors
    table.insert(lines, format_color_line(item.name, item.color, is_last))
  end

  return table.concat(lines, "\n")
end

return M
