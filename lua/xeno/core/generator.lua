local M = {}
local utils = require("xeno.core.utils")
local fn = vim.fn
local fmt = string.format

--- Serialize a Lua value to string for file generation
--- @param value any The value to serialize
--- @param indent number Current indentation level
--- @return string Serialized value
local function serialize_value(value, indent)
  indent = indent or 0
  local indent_str = string.rep("  ", indent)
  local next_indent_str = string.rep("  ", indent + 1)

  if value == nil then
    return "nil"
  elseif type(value) == "boolean" then
    return tostring(value)
  elseif type(value) == "number" then
    return tostring(value)
  elseif type(value) == "string" then
    -- Escape quotes and special characters
    local escaped = value:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
    return fmt('"%s"', escaped)
  elseif type(value) == "table" then
    local parts = {}
    local is_array = #value > 0

    -- Check if it's an array-like table
    if is_array then
      for i, v in ipairs(value) do
        table.insert(parts, serialize_value(v, indent + 1))
      end
      if #parts == 0 then
        return "{}"
      end
      return fmt("{ %s }", table.concat(parts, ", "))
    else
      -- It's a dictionary-like table
      for k, v in pairs(value) do
        local key_str
        if type(k) == "string" and k:match("^[%a_][%w_]*$") then
          -- Simple identifier, no quotes needed
          key_str = k
        elseif type(k) == "string" then
          -- Complex string key, needs brackets
          key_str = fmt('["%s"]', k:gsub('"', '\\"'))
        else
          key_str = fmt("[%s]", serialize_value(k, 0))
        end

        table.insert(parts, fmt("%s%s = %s", next_indent_str, key_str, serialize_value(v, indent + 1)))
      end

      if #parts == 0 then
        return "{}"
      end
      return fmt("{\n%s\n%s}", table.concat(parts, ",\n"), indent_str)
    end
  else
    return fmt('"%s"', tostring(value))
  end
end

--- Generate the highlights configuration code
--- @param highlights table|nil The highlights configuration
--- @return string|nil The generated code or nil if no highlights
local function generate_highlights_code(highlights)
  if not highlights or type(highlights) ~= "table" then
    return nil
  end

  -- Check if highlights has any content
  local has_content = false
  for category, groups in pairs(highlights) do
    if type(groups) == "table" and next(groups) ~= nil then
      has_content = true
      break
    end
  end

  if not has_content then
    return nil
  end

  return serialize_value(highlights, 1)
end

function M.new_theme(name, config, global_config)
  local colorscheme_dir = fmt("%s/colors", fn.stdpath("config"))
  local colorscheme_path = fmt("%s/%s.lua", colorscheme_dir, name)

  fn.mkdir(colorscheme_dir, "p")

  local user_config = utils.extend("force", global_config or {}, config or {})

  -- Build the configuration code
  local config_parts = {}

  -- Add basic configuration
  table.insert(config_parts, fmt('  base = "%s"', user_config.base or user_config.background or "#030303"))
  table.insert(config_parts, fmt('  accent = "%s"', user_config.accent or "#7AA2F7"))
  table.insert(config_parts, fmt("  variation = %.1f", user_config.variation or 0.0))
  table.insert(config_parts, fmt("  contrast = %.1f", user_config.contrast or 0))
  table.insert(config_parts, fmt("  transparent = %s", user_config.transparent and "true" or "false"))

  -- Add custom colors if present
  if user_config.red then
    table.insert(config_parts, fmt('  red = "%s"', user_config.red))
  end
  if user_config.green then
    table.insert(config_parts, fmt('  green = "%s"', user_config.green))
  end
  if user_config.yellow then
    table.insert(config_parts, fmt('  yellow = "%s"', user_config.yellow))
  end
  if user_config.orange then
    table.insert(config_parts, fmt('  orange = "%s"', user_config.orange))
  end
  if user_config.blue then
    table.insert(config_parts, fmt('  blue = "%s"', user_config.blue))
  end
  if user_config.purple then
    table.insert(config_parts, fmt('  purple = "%s"', user_config.purple))
  end
  if user_config.cyan then
    table.insert(config_parts, fmt('  cyan = "%s"', user_config.cyan))
  end

  -- Add highlights if present
  local highlights_code = generate_highlights_code(user_config.highlights)
  if highlights_code then
    table.insert(config_parts, fmt("  highlights = %s", highlights_code))
  end

  local content = fmt(
    [=[
require("xeno").setup({
%s,
})
vim.g.colors_name = "%s"
]=],
    table.concat(config_parts, ",\n"),
    name
  )

  local file = io.open(colorscheme_path, "w")
  if file then
    file:write(content)
    file:close()
  else
    print(fmt("Failed to create colorscheme file: %s", colorscheme_path))
  end
end

return M
