local M = {
  cases = {},
  scope = {},
}

local function join_scope(name)
  if #M.scope == 0 then
    return name
  end

  return table.concat(M.scope, " / ") .. " / " .. name
end

local function fail(message, level)
  error(message, (level or 1) + 1)
end

local function inspect(value)
  return vim.inspect(value, { newline = " ", indent = "" })
end

function M.describe(name, fn)
  table.insert(M.scope, name)
  local ok, err = pcall(fn)
  table.remove(M.scope)

  if not ok then
    fail(err, 2)
  end
end

function M.it(name, fn)
  table.insert(M.cases, {
    name = join_scope(name),
    fn = fn,
  })
end

function M.eq(actual, expected, message)
  if actual ~= expected then
    fail(message or string.format("expected %s, got %s", inspect(expected), inspect(actual)), 2)
  end
end

function M.ne(actual, expected, message)
  if actual == expected then
    fail(message or string.format("did not expect %s", inspect(actual)), 2)
  end
end

function M.deep_eq(actual, expected, message)
  if not vim.deep_equal(actual, expected) then
    fail(message or string.format("expected %s, got %s", inspect(expected), inspect(actual)), 2)
  end
end

function M.truthy(value, message)
  if not value then
    fail(message or string.format("expected truthy value, got %s", inspect(value)), 2)
  end
end

function M.falsy(value, message)
  if value then
    fail(message or string.format("expected falsy value, got %s", inspect(value)), 2)
  end
end

function M.approx(actual, expected, tolerance, message)
  tolerance = tolerance or 1e-6
  if math.abs(actual - expected) > tolerance then
    fail(message or string.format("expected %s within %s, got %s", expected, tolerance, actual), 2)
  end
end

function M.sorted_keys(tbl, matcher)
  local keys = {}

  for key in pairs(tbl) do
    if not matcher or matcher(key) then
      table.insert(keys, key)
    end
  end

  table.sort(keys, function(a, b)
    local a_prefix, a_level = a:match("^(.-)_(%d+)$")
    local b_prefix, b_level = b:match("^(.-)_(%d+)$")

    if a_prefix and b_prefix and a_prefix == b_prefix then
      return tonumber(a_level) < tonumber(b_level)
    end

    return a < b
  end)
  return keys
end

function M.family(prefix, levels)
  local keys = {}

  for _, level in ipairs(levels) do
    table.insert(keys, string.format("%s_%s", prefix, level))
  end

  return keys
end

function M.pick(tbl, keys)
  local out = {}

  for _, key in ipairs(keys) do
    out[key] = tbl[key]
  end

  return out
end

function M.hex_to_rgb(hex)
  return require("xeno.core.utils").hex2rgb(hex)
end

function M.hex_channel_distance(a, b)
  local ar, ag, ab = M.hex_to_rgb(a)
  local br, bg, bb = M.hex_to_rgb(b)

  return math.abs(ar - br), math.abs(ag - bg), math.abs(ab - bb)
end

function M.hex_lightness(hex)
  local L = require("xeno.core.utils").hex2oklch(hex)
  return L
end

function M.hex_chroma(hex)
  local _, C = require("xeno.core.utils").hex2oklch(hex)
  return C
end

local function to_hex(value)
  if type(value) ~= "number" then
    return value
  end

  return string.format("#%06x", value)
end

function M.get_hl(name, opts)
  local hl = vim.api.nvim_get_hl(0, vim.tbl_extend("force", {
    name = name,
    link = false,
  }, opts or {}))

  local normalized = vim.deepcopy(hl)
  normalized.fg = to_hex(normalized.fg)
  normalized.bg = to_hex(normalized.bg)
  normalized.sp = to_hex(normalized.sp)

  return normalized
end

function M.reset_state()
  for name in pairs(package.loaded) do
    if name:match("^xeno") then
      package.loaded[name] = nil
    end
  end

  pcall(vim.api.nvim_del_augroup_by_name, "xeno.nvim")
  vim.cmd("highlight clear")
  vim.g.colors_name = nil

  for index = 0, 15 do
    vim.g["terminal_color_" .. index] = nil
  end

  vim.o.background = "dark"
end

function M.test_config(overrides)
  return vim.tbl_deep_extend("force", {
    integrations = {
      ghostty = {
        enabled = false,
        update_config = false,
      },
    },
  }, overrides or {})
end

return M
