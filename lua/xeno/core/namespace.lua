local M = {}
local api = vim.api

-- Store namespace IDs for reuse
local namespaces = {}

--- Create or get a highlight namespace
--- @param name string The namespace name
--- @return number The namespace ID
function M.get_namespace(name)
  if not namespaces[name] then
    namespaces[name] = api.nvim_create_namespace("xeno_" .. name)
  end
  return namespaces[name]
end

--- Apply highlights to a specific namespace
--- @param namespace_name string The namespace name
--- @param highlights table The highlights to apply
function M.apply_to_namespace(namespace_name, highlights)
  local ns_id = M.get_namespace(namespace_name)

  for group, attrs in pairs(highlights) do
    if attrs.clear then
      -- Clear the highlight in this namespace
      api.nvim_set_hl(ns_id, group, {})
      attrs.clear = nil
    elseif attrs.link then
      -- Handle linked groups in namespace
      api.nvim_set_hl(ns_id, group, { link = attrs.link })
    else
      -- Normal highlight definition in namespace
      api.nvim_set_hl(ns_id, group, attrs)
    end
  end

  return ns_id
end

--- Set the highlight namespace for a window
--- @param win_id number The window ID (0 for current window)
--- @param namespace_name string The namespace name
function M.set_window_namespace(win_id, namespace_name)
  local ns_id = M.get_namespace(namespace_name)
  api.nvim_win_set_hl_ns(win_id, ns_id)
  return ns_id
end

--- Clear a namespace
--- @param namespace_name string The namespace name
function M.clear_namespace(namespace_name)
  if namespaces[namespace_name] then
    -- Clear all highlights in this namespace by setting them to empty
    -- Note: There's no direct way to clear a namespace, so we rely on Neovim's cleanup
    namespaces[namespace_name] = nil
  end
end

--- Get all registered namespace names
--- @return table List of namespace names
function M.get_namespace_names()
  local names = {}
  for name, _ in pairs(namespaces) do
    table.insert(names, name)
  end
  return names
end

return M
