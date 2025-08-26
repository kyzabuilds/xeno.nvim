local M = {}
local api, g, cmd, fn = vim.api, vim.g, vim.cmd, vim.fn

function M.apply_highlights(highlights, config)
  cmd("highlight clear")
  if fn.exists("syntax_on") then
    cmd("syntax reset")
  end

  if config.transparent then
    if highlights.Normal then
      highlights.Normal.bg = "NONE"
    end
    if highlights.NormalNC then
      highlights.NormalNC.bg = "NONE"
    end
    if highlights.WinBar then
      highlights.WinBar.bg = "NONE"
    end
    if highlights.WinBarNC then
      highlights.WinBarNC.bg = "NONE"
    end
  end

  for group, attrs in pairs(highlights) do
    if attrs.clear then
      api.nvim_cmd({ cmd = "highlight", args = { "clear", group } }, {})
    end

    attrs.clear = nil
    api.nvim_set_hl(0, group, attrs)
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

