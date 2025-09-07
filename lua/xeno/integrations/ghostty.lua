local M = {}

local function is_ghostty()
  return os.getenv("TERM_PROGRAM") == "ghostty" or os.getenv("GHOSTTY_RESOURCES_DIR") ~= nil
end

local function send_osc(sequence)
  if vim.fn.has("nvim") == 1 then
    vim.api.nvim_chan_send(2, sequence)
  else
    io.stderr:write(sequence)
    io.stderr:flush()
  end
end

local function hex_to_osc_color(hex_color)
  local clean_hex = hex_color:gsub("^#", "")
  local r = tonumber(clean_hex:sub(1, 2), 16)
  local g = tonumber(clean_hex:sub(3, 4), 16)
  local b = tonumber(clean_hex:sub(5, 6), 16)

  r = math.floor((r / 255) * 65535)
  g = math.floor((g / 255) * 65535)
  b = math.floor((b / 255) * 65535)

  return string.format("rgb:%04x/%04x/%04x", r, g, b)
end

local function get_config_path()
  local home = os.getenv("HOME")
  if not home then
    return nil
  end

  local xdg_config = os.getenv("XDG_CONFIG_HOME")
  return (xdg_config and xdg_config .. "/ghostty/config") or home .. "/.config/ghostty/config"
end

local function update_config(colors)
  local path = get_config_path()
  if not path then
    vim.notify("xeno.nvim: Could not determine Ghostty config path", vim.log.levels.ERROR)
    return
  end

  local dir = path:match("^(.*)/[^/]*$")
  if dir then
    os.execute("mkdir -p '" .. dir .. "'")
  end

  local file = io.open(path, "r")
  local content = file and file:read("*all") or ""
  if file then
    file:close()
  end

  content = content:gsub("# xeno%.nvim theme colors.-# End xeno%.nvim theme colors\n?", "")
  content = content:gsub("%s+$", "")
  if content ~= "" then
    content = content .. "\n"
  end

  local theme_block = table.concat({
    "",
    "# xeno.nvim theme colors",
    "background = " .. colors.base_900:gsub("^#", ""),
    "foreground = " .. colors.base_300:gsub("^#", ""),
    "cursor-color = " .. colors.accent_500:gsub("^#", ""),
    "# End xeno.nvim theme colors",
    "",
  }, "\n")

  file = io.open(path, "w")
  if file then
    file:write(content .. theme_block)
    file:close()
  else
    vim.notify("xeno.nvim: Failed to write Ghostty config file at " .. path, vim.log.levels.ERROR)
  end
end

function M.setup_ghostty_colors(colors, config)
  config = config or {}
  if not config.enabled or not is_ghostty() then
    return
  end

  if config.update_config then
    update_config(colors)
  end

  send_osc(string.format("\027]11;%s\027\\", hex_to_osc_color(colors.base_900)))
  send_osc(string.format("\027]10;%s\027\\", hex_to_osc_color(colors.base_300)))
end

function M.setup_ghostty_palette(colors)
  if not is_ghostty() then
    return
  end

  M.setup_ghostty_colors(colors)

  local palette = {
    [0] = colors.base_900,
    [1] = colors.red,
    [2] = colors.green,
    [3] = colors.yellow,
    [4] = colors.blue,
    [5] = colors.purple,
    [6] = colors.cyan,
    [7] = colors.base_300,
    [8] = colors.base_500,
    [9] = colors.red,
    [10] = colors.green,
    [11] = colors.yellow,
    [12] = colors.blue,
    [13] = colors.purple,
    [14] = colors.cyan,
    [15] = colors.base_100,
  }

  for index, color in pairs(palette) do
    send_osc(string.format("\027]4;%d;%s\027\\", index, hex_to_osc_color(color)))
  end
end

function M.reset_ghostty_colors()
  if not is_ghostty() then
    return
  end
  send_osc("\027]111\027\\")
  send_osc("\027]110\027\\")
  send_osc("\027]112\027\\")
end

return M
