local M = {}

local utils = require("xeno.export.utils")
local lua_template = require("xeno.export.templates.lua")

local fmt = string.format

-- Format highlight group for Lua with color variable references
local function format_highlight_group(group_name, attrs, color_lookup)
  if not attrs or type(attrs) ~= "table" or not next(attrs) then
    return ""
  end

  if attrs.link then
    return fmt("hi('%s', { link = '%s' })", group_name, attrs.link)
  end

  local parts = {}

  -- Helper to resolve color value (either hex or reference)
  local function resolve_attr(value)
    if not value then
      return nil
    end

    -- Handle semantic references starting with @ (e.g., @background_600_020)
    if type(value) == "string" and value:match("^@") then
      local var_name = value:sub(2):gsub("%.", "_")
      return fmt("colors.%s", var_name)
    end

    -- Regular hex color lookup
    local normalized = utils.format_hex_color(value)
    local var_name = color_lookup[normalized:upper()]
    if var_name then
      return fmt("colors.%s", var_name)
    end

    return fmt('"%s"', normalized)
  end

  if attrs.fg then
    local resolved = resolve_attr(attrs.fg)
    if resolved then
      table.insert(parts, fmt("fg = %s", resolved))
    end
  end
  if attrs.bg then
    local resolved = resolve_attr(attrs.bg)
    if resolved then
      table.insert(parts, fmt("bg = %s", resolved))
    end
  end
  if attrs.sp then
    local resolved = resolve_attr(attrs.sp)
    if resolved then
      table.insert(parts, fmt("sp = %s", resolved))
    end
  end

  local normalized = utils.normalize_highlight_attrs(attrs)
  local style_attrs = { "bold", "italic", "underline", "undercurl", "strikethrough", "reverse", "standout", "nocombine" }
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

-- Convert kebab-case or snake_case to PascalCase
local function to_pascal_case(str)
  str = str:gsub("[-_]", " ")
  str = str:gsub("(%w)(%w*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
  return str:gsub("%s+", "")
end

local ft_group_priority = {
  StatusLine = 1,
  StatusLineNC = 2,
  fzf1 = 3,
  fzf2 = 4,
  fzf3 = 5,
}

-- Format file-type specific highlights with winhighlight autocmd
local function format_filetype_highlights(filetype_highlights, organized_colors)
  if not filetype_highlights or not next(filetype_highlights) then
    return ""
  end

  local variant = vim.o.background or "dark"
  local highlights = filetype_highlights[variant]
  if not highlights or not next(highlights) then
    return ""
  end

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

  -- Populate color lookup table
  if organized_colors.variant_colors then
    local variant_palette = organized_colors.variant_colors[variant]
    if variant_palette then
      for name, color in pairs(variant_palette) do
        add_to_lookup(name, color)
      end
    end
  end

  local lines = {}
  table.insert(lines, "")
  table.insert(lines, "  -- Filetype highlights and winhighlight setup")
  table.insert(lines, "  local ft_map = {}")

  -- Get sorted filetypes for consistent output
  local filetypes = {}
  for ft in pairs(highlights) do
    table.insert(filetypes, ft)
  end
  table.sort(filetypes)

  for _, ft in ipairs(filetypes) do
    local ft_hls = highlights[ft]
    local prefix = to_pascal_case(ft)
    local winhighlight_parts = {}

    table.insert(lines, string.format("  -- %s", ft))

    -- Get sorted groups for consistent output
    local groups = {}
    for group in pairs(ft_hls) do
      table.insert(groups, group)
    end
    table.sort(groups, function(a, b)
      local pa, pb = ft_group_priority[a] or 100, ft_group_priority[b] or 100
      if pa ~= pb then
        return pa < pb
      end
      return a < b
    end)

    for _, group in ipairs(groups) do
      local attrs = ft_hls[group]
      local global_name = prefix .. group
      local formatted = format_highlight_group(global_name, attrs, color_lookup)
      if formatted ~= "" then
        table.insert(lines, "  " .. formatted)
        table.insert(winhighlight_parts, group .. ":" .. global_name)
      end
    end

    if #winhighlight_parts > 0 then
      table.insert(lines, string.format("  ft_map['%s'] = '%s'", ft, table.concat(winhighlight_parts, ",")))
    end
  end

  -- Add the winhighlight autocmd logic
  table.insert(lines, "")
  table.insert(lines, "  -- Create autocmd for winhighlight")
  table.insert(lines, "  local group = vim.api.nvim_create_augroup('xeno_ft_exported', { clear = true })")
  table.insert(lines, "  vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter', 'WinEnter' }, {")
  table.insert(lines, "    group = group,")
  table.insert(lines, "    pattern = '*',")
  table.insert(lines, "    callback = function()")
  table.insert(lines, "      local ft = vim.bo.filetype")
  table.insert(lines, "      local wh_string = ft_map[ft]")
  table.insert(lines, "      if wh_string then")
  table.insert(lines, "        vim.schedule(function()")
  table.insert(lines, "          if not vim.api.nvim_buf_is_valid(0) then return end")
  table.insert(lines, "          if vim.bo.filetype ~= ft then return end")
  table.insert(lines, "          local current = vim.wo.winhighlight")
  table.insert(lines, "          if not string.find(current, wh_string, 1, true) then")
  table.insert(lines, "            if current ~= '' then")
  table.insert(lines, "              vim.wo.winhighlight = current .. ',' .. wh_string")
  table.insert(lines, "            else")
  table.insert(lines, "              vim.wo.winhighlight = wh_string")
  table.insert(lines, "            end")
  table.insert(lines, "          end")
  table.insert(lines, "        end)")
  table.insert(lines, "      end")
  table.insert(lines, "    end,")
  table.insert(lines, "  })")

  return table.concat(lines, "\n")
end

-- Main formatting function
function M.format_colorscheme(export_data)
  local template = lua_template.template
  local replacements = {}

  -- Header comment
  replacements["{{HEADER_COMMENT}}"] = utils.create_header_comment(export_data.metadata, "--")

  -- Theme name
  local theme_name = export_data.metadata.theme_name or "xeno_exported_theme"
  replacements["{{THEME_NAME}}"] = theme_name

  -- Check if we have variant-aware data structure
  if export_data.colors.variant_colors then
    -- Generate separate color definitions for each variant
    replacements["{{LIGHT_COLOR_DEFINITIONS}}"] = utils.generate_variant_color_definitions(export_data.colors, "light")
    replacements["{{DARK_COLOR_DEFINITIONS}}"] = utils.generate_variant_color_definitions(export_data.colors, "dark")

    -- Generate dynamic highlights that use the colors variable
    replacements["{{EDITOR_HIGHLIGHTS}}"] = format_dynamic_highlights(export_data.highlights, export_data.colors)

    -- Generate file-type specific highlights
    replacements["{{FILETYPE_HIGHLIGHTS}}"] = format_filetype_highlights(export_data.filetype_highlights, export_data.colors)
  end

  -- Apply replacements
  local result = template
  for placeholder, replacement in pairs(replacements) do
    result = result:gsub(placeholder:gsub("([%(%)])", "%%%1"), replacement)
  end

  return result
end

return M
