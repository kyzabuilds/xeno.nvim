local M = {}
local utils = require("xeno.core.utils")
local fmt = string.format

--- Detect and recover from circular highlight links.
--- A link chain that loops back on itself (e.g. a user redefining `Keyword` so
--- that `@keyword -> Keyword -> @keyword`) makes Neovim's redraw follow the chain
--- forever and hangs the editor. We only ever see links that stay inside our own
--- table; links to external/built-in groups terminate and are ignored. When a
--- cycle is found we discard the offending override and restore that group's base
--- (pre-override) definition so it keeps a working color, then warn. Base
--- highlights are authored acyclic, so the restore can't re-introduce a loop.
--- @param target_table table The merged highlights, sanitized in place
--- @param base table The base highlights to fall back to
local function break_link_cycles(target_table, base)
  local function walk(group, seen)
    local attrs = target_table[group]
    if type(attrs) ~= "table" or attrs.link == nil then
      return
    end
    if seen[group] then
      vim.notify(
        fmt("xeno.nvim: circular highlight link at '%s'; restoring its base highlight", group),
        vim.log.levels.WARN
      )
      target_table[group] = base[group] and vim.deepcopy(base[group]) or {}
      return
    end
    seen[group] = true
    walk(attrs.link, seen)
  end

  for group in pairs(target_table) do
    walk(group, {})
  end
end

--- Deep merge highlight groups, with user overrides taking precedence
--- @param base table Base highlight group
--- @param override table Override highlight group
--- @return table Merged highlight group
function M.merge_highlight_group(base, override)
  if not base then
    return override or {}
  end
  if not override then
    return base
  end

  -- A user-provided link replaces the whole group because highlight links
  -- cannot be combined with concrete attrs.
  if override.link ~= nil then
    return { link = override.link }
  end

  local merged = utils.extend("force", base, override)

  -- If the base group was a link and the override provides concrete attrs,
  -- drop the inherited link so the attrs can take effect.
  if base.link ~= nil then
    merged.link = nil
  end

  return merged
end

--- Merge all highlights with user overrides, supporting highlight references
--- @param base_highlights table Base highlights from generators
--- @param user_highlights table User highlight overrides
--- @param colors table Color palette for resolving references
--- @return table Merged highlights
function M.merge_all_highlights(base_highlights, user_highlights, colors)
  if not user_highlights or type(user_highlights) ~= "table" then
    return base_highlights or {}
  end

  local merged = vim.deepcopy(base_highlights or {})
  local resolver = require("xeno.core.resolver")

  -- Helper function to process highlight groups with reference resolution
  local function process_highlights(highlights_table, target_table)
    for group, attrs in pairs(highlights_table) do
      -- First resolve color references only
      local resolved_attrs = resolver.resolve_highlights(attrs, colors, nil)
      target_table[group] = M.merge_highlight_group(target_table[group], resolved_attrs)
    end
  end

  -- Resolve xeno.opaque() thunks now that `colors` is the fully-generated palette
  -- for the current variant (including custom families). utils.opaque resolves the
  -- fg/bg color references and applies the bg fallback chain, returning a hex string.
  local function resolve_opaque_thunks(target_table)
    for _, attrs in pairs(target_table) do
      if type(attrs) == "table" then
        for key, value in pairs(attrs) do
          if type(value) == "table" and value.__xeno_opaque then
            attrs[key] = utils.opaque(value.fg, value.opacity, value.bg, colors)
          end
        end
      end
    end
  end

  -- Helper function to resolve highlight references after all groups are merged
  local function resolve_highlight_references(target_table)
    local changed = true
    local max_iterations = 10 -- Prevent infinite loops
    local iterations = 0

    while changed and iterations < max_iterations do
      changed = false
      iterations = iterations + 1

      for group, attrs in pairs(target_table) do
        local new_attrs = {}
        local group_changed = false

        for attr_key, attr_value in pairs(attrs) do
          if resolver.is_highlight_reference(attr_value) then
            local resolved = resolver.resolve_highlight_reference(attr_value, attr_key, target_table)
            if resolved ~= attr_value then
              new_attrs[attr_key] = resolved
              group_changed = true
              changed = true
            else
              new_attrs[attr_key] = attr_value
            end
          else
            new_attrs[attr_key] = attr_value
          end
        end

        if group_changed then
          target_table[group] = new_attrs
        end
      end
    end

    if iterations >= max_iterations then
      vim.notify(
        "xeno.nvim: Maximum iterations reached while resolving highlight references. Some references may be circular.",
        vim.log.levels.WARN
      )
    end
  end

  -- Process editor highlights
  if user_highlights.editor then
    process_highlights(user_highlights.editor, merged)
  end

  -- Process syntax highlights
  if user_highlights.syntax then
    process_highlights(user_highlights.syntax, merged)
  end

  -- Resolve opaque thunks to hex before highlight references, so { from = ... }
  -- copies a concrete value rather than an unresolved thunk.
  resolve_opaque_thunks(merged)

  -- After all merging is done, resolve highlight references
  resolve_highlight_references(merged)

  -- Recover from any circular links a user override may have introduced so the
  -- theme still initializes instead of hanging Neovim's redraw.
  break_link_cycles(merged, base_highlights)
  return merged
end

--- Extract and flatten user highlights for processing
--- @param config table The user configuration
--- @return table|nil Flattened highlights or nil if none
function M.extract_user_highlights(config)
  if not config or not config.highlights then
    return nil
  end

  return config.highlights
end

return M
