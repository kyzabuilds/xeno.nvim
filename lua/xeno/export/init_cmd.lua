local M = {}

local xeno = require("xeno")
local export = require("xeno.export")
local utils = require("xeno.core.utils")

function M.export()
  local default_name = "xeno-" .. vim.fn.strftime("%Y-%m-%d-%H-%M")

  vim.ui.input({
    prompt = "Enter theme name: ",
    default = default_name,
  }, function(input)
    if not input or input == "" then
      return
    end

    local config = {
      dir = vim.fn.expand("~/.config/nvim/colors/"),
      theme_name = input,
    }

    local result, err = export.export_theme(config)

    if not result then
      vim.notify("Export failed: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    -- Rename the file to the user-provided name
    local old_path = result.path
    local new_filename = input .. ".lua"
    local new_path = vim.fn.fnamemodify(old_path, ":h") .. "/" .. new_filename

    -- Need to ensure we don't try to rename if the names are the same (which shouldn't happen but good practice)
    if old_path ~= new_path then
      local success, rename_err = pcall(os.rename, old_path, new_path)
      if not success then
        vim.notify("Failed to rename file: " .. tostring(rename_err), vim.log.levels.ERROR)
        return
      end
    end

    vim.notify("Theme exported to: " .. new_path)

    -- Navigate to the theme file
    vim.cmd("edit " .. vim.fn.fnameescape(new_path))
  end)
end

return M
