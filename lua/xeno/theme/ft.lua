local M = {}
local api = vim.api

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

--- Setup filetype-specific window highlights
--- @param ft_config table<string, function> Map of filetype to highlight generator function
--- @param colors table The color palette
--- @param config table Global configuration
function M.setup(ft_config, colors, config)
  if not ft_config or next(ft_config) == nil then
    return
  end

  local ft_map = {}

  -- Pre-generate highlight groups and winhighlight strings
  for filetype, generator in pairs(ft_config) do
    local highlights = generator(colors, config)
    local winhighlight_parts = {}

    -- Convert filetype to PascalCase for the prefix
    local prefix = to_pascal_case(filetype)

    local groups = {}
    for group in pairs(highlights) do
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
      local attrs = highlights[group]
      -- Create the global highlight group (e.g., NeoTreeVisual)
      local global_name = prefix .. group
      -- Create the global highlight group
      api.nvim_set_hl(0, global_name, attrs)
      -- Map the local group to the global group
      table.insert(winhighlight_parts, group .. ":" .. global_name)
    end

    if #winhighlight_parts > 0 then
      ft_map[filetype] = table.concat(winhighlight_parts, ",")
    end
  end

  -- Create a single autocmd to handle all registered filetypes
  local group = api.nvim_create_augroup("xeno_ft", { clear = true })

  api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
    group = group,
    pattern = "*",
    callback = function()
      local ft = vim.bo.filetype
      local wh_string = ft_map[ft]
      if not wh_string then
        return
      end

      -- Defer so we win against plugins (e.g. neo-tree) that replace
      -- winhighlight wholesale in their own synchronous BufWinEnter handler.
      local win = api.nvim_get_current_win()
      vim.schedule(function()
        if not api.nvim_win_is_valid(win) then
          return
        end
        local current = vim.wo[win].winhighlight
        if string.find(current, wh_string, 1, true) then
          return
        end
        vim.wo[win].winhighlight = current ~= "" and (current .. "," .. wh_string) or wh_string
      end)
    end,
  })
end

return M
