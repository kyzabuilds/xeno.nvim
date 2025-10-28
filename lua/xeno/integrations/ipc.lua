local M = {}

-- IPC adapter for external access to xeno theme data
-- Uses Neovim's built-in RPC server for minimal implementation

local function get_color_palette()
  local xeno = require("xeno")
  return xeno.colors or {}
end

local function get_theme_config()
  local xeno = require("xeno")
  return xeno._global_config or {}
end

local function get_theme_status()
  return {
    name = vim.g.colors_name or "unknown",
    background = vim.o.background,
    has_colors = require("xeno").colors ~= nil,
  }
end

local function get_highlights()
  local xeno = require("xeno")
  return xeno._generated_highlights or {}
end

-- Setup IPC interface by exposing functions globally
function M.setup_ipc(config)
  config = config or {}

  if not config.enabled then
    return
  end

  -- Expose xeno data through global namespace for RPC access
  _G.xeno_ipc = {
    -- Get full color palette (returns Lua table)
    get_colors = function()
      return get_color_palette()
    end,

    -- Get current theme configuration (returns Lua table)
    get_config = function()
      return get_theme_config()
    end,

    -- Get theme status (returns Lua table)
    get_status = function()
      return get_theme_status()
    end,

    -- Get all generated highlight groups (returns Lua table)
    get_highlights = function()
      return get_highlights()
    end,

    -- Get specific color by reference (returns string)
    get_color = function(ref)
      local colors = get_color_palette()
      return colors[ref] or ""
    end,

    -- Get server address for client convenience (returns Lua table)
    get_server = function()
      local addr = vim.v.servername
      return { address = addr, pid = vim.fn.getpid() }
    end,
  }

  -- Log server address if debug mode is enabled
  if config.debug then
    vim.notify(
      string.format("xeno.nvim IPC: Server available at %s", vim.v.servername),
      vim.log.levels.INFO
    )
  end
end

return M
