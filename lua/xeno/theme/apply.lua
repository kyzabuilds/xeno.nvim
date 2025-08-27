local M = {}
local api, g, cmd, fn = vim.api, vim.g, vim.cmd, vim.fn

--- Apply transparency settings to specific highlight groups
--- @param highlights table The highlights table to modify
--- @param transparent boolean Whether to apply transparency
local function apply_transparency(highlights, transparent)
  if not transparent then
    return
  end

  local transparent_groups = {
    "Normal",
    "NormalNC",
    "WinBar",
    "WinBarNC",
    "SignColumn",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "NotifyBackground",
  }

  for _, group in ipairs(transparent_groups) do
    if highlights[group] then
      highlights[group].bg = "NONE"
    end
  end
end

function M.apply_highlights(highlights, config)
  cmd("highlight clear")
  if fn.exists("syntax_on") then
    cmd("syntax reset")
  end

  -- Apply transparency if configured
  apply_transparency(highlights, config.transparent)

  -- Apply each highlight group
  for group, attrs in pairs(highlights) do
    if attrs.clear then
      api.nvim_cmd({ cmd = "highlight", args = { "clear", group } }, {})
      attrs.clear = nil
    elseif attrs.link then
      -- Handle linked groups
      api.nvim_cmd({ cmd = "highlight", args = { "link", group, attrs.link } }, {})
    else
      -- Normal highlight definition
      api.nvim_set_hl(0, group, attrs)
    end
  end
end

function M.setup_autocmds(user_config)
  local xeno_augroup = api.nvim_create_augroup("xeno.nvim", { clear = true })

  api.nvim_create_autocmd({ "ColorScheme" }, {
    callback = function()
      if g.colors_name == "xeno" then
        require("xeno").setup(user_config)
      end
    end,
    group = xeno_augroup,
  })

  api.nvim_create_autocmd({ "ColorSchemePre" }, {
    callback = function()
      api.nvim_cmd({ cmd = "highlight", args = { "clear" } }, {})
    end,
    group = xeno_augroup,
  })
end

return M
