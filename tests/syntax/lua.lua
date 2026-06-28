-- Generic Lua sample for pop-in detection.
-- Covers the common captures whose treesitter color differs from the
-- pre-treesitter paint: @variable, @variable.member, @function.call,
-- @function.builtin, @module.builtin, @function.method.call, parameters.
return {
  filetype = "lua",
  lang = "lua",
  code = [[
local uv = vim.uv or vim.loop
local fmt = string.format

local Cache = {}
Cache.__index = Cache

function Cache.new(capacity)
  local self = setmetatable({}, Cache)
  self.capacity = capacity or 128
  self.entries = {}
  return self
end

function Cache:get(key, fallback)
  local value = self.entries[key]
  if value == nil then
    return fallback
  end
  return value
end

local function format_entry(key, value)
  return fmt("%s = %s", tostring(key), vim.inspect(value))
end

local function schedule_flush(cache)
  vim.schedule(function()
    local timer = uv.new_timer()
    timer:start(0, 0, function()
      for key, value in pairs(cache.entries) do
        print(format_entry(key, value))
      end
    end)
  end)
end

return {
  Cache = Cache,
  flush = schedule_flush,
}
]],
}
