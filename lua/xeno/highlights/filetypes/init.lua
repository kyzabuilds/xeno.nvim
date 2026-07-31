local M = {}

local filetypes = {
  require("xeno.highlights.filetypes.c"),
  require("xeno.highlights.filetypes.java"),
  require("xeno.highlights.filetypes.lua"),
  require("xeno.highlights.filetypes.rust"),
  require("xeno.highlights.filetypes.typescript"),
}

function M.generate(colors)
  local result = {}
  for _, ft in ipairs(filetypes) do
    for group, attrs in pairs(ft.generate(colors)) do
      result[group] = attrs
    end
  end
  return result
end

return M
