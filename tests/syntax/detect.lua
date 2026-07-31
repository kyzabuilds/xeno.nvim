-- Generic "pop-in" detector.
--
-- A pop-in is the visible flash that happens when a buffer first loads: the
-- text is painted once with the pre-treesitter highlighter (vim regex syntax,
-- or just `Normal` when no syntax matches), then re-painted a frame later when
-- the treesitter highlighter attaches. Wherever those two colors differ, that
-- token visibly snaps from one color to another.
--
-- This module measures both frames without rendering:
--   * frame 1 (pre-treesitter): the winning vim-syntax color via `synID`
--   * frame 2 (treesitter):      the winning treesitter capture's resolved fg,
--                                 derived straight from the highlights query so
--                                 the treesitter highlighter never has to be
--                                 attached (attaching it disables vim syntax)
-- and returns every token whose color changes between them.
--
-- It is language-agnostic: a spec just provides a filetype, a parser language,
-- and the source code to inspect.

local M = {}

-- nvim-treesitter ships the parsers/queries for non-bundled languages (tsx,
-- typescript, ...). Make them reachable so the detector works headlessly.
local function ensure_treesitter_runtime()
  local data = vim.fn.stdpath("data")
  local candidates = {
    data .. "/lazy/nvim-treesitter",
    data .. "/site/pack/packer/start/nvim-treesitter",
    data .. "/site/pack/packer/opt/nvim-treesitter",
  }
  for _, dir in ipairs(candidates) do
    if vim.fn.isdirectory(dir) == 1 then
      vim.opt.runtimepath:append(dir) -- parser/<lang>.so
      vim.opt.runtimepath:append(dir .. "/runtime") -- runtime/queries/<lang>/
    end
  end
end

local function to_hex(n)
  if not n then return nil end
  return string.format("#%06x", n)
end

-- Resolve a highlight group to its final fg, following links.
local function group_fg(name)
  if not name or name == "" then return nil end
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok then return nil end
  return hl.fg
end

local function resolved_capture_fg(capture, lang)
  local lang_capture = capture .. "." .. lang
  local fg = group_fg(lang_capture)
  if fg then
    return fg, lang_capture
  end

  return group_fg(capture), capture
end

-- Frame 1: top of the vim-syntax stack at a 0-indexed position.
local function syntax_at(row0, col0)
  local id = vim.fn.synID(row0 + 1, col0 + 1, true)
  if id == 0 then return nil, "Normal" end
  local name = vim.fn.synIDattr(id, "name")
  local fg = vim.fn.synIDattr(vim.fn.synIDtrans(id), "fg#")
  if fg == "" then return nil, (name ~= "" and name or "Normal") end
  return tonumber(fg:sub(2), 16), (name ~= "" and name or "Normal")
end

local TS_PRIORITY = (vim.hl and vim.hl.priorities and vim.hl.priorities.treesitter)
  or (vim.highlight and vim.highlight.priorities and vim.highlight.priorities.treesitter)
  or 100

--- Detect pop-ins for one spec.
--- @param spec table { filetype=string, lang=string, code=string }
--- @return number|nil normal_fg, table tokens  where each token is
---   { text, row, col, pre, post, pre_group, post_capture, pops }
function M.detect(spec)
  ensure_treesitter_runtime()

  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(spec.code:gsub("^\n", ""), "\n", { plain = true })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = spec.filetype
  vim.cmd("syntax on")
  vim.cmd("redraw")

  local normal_fg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg

  local parser = assert(vim.treesitter.get_parser(buf, spec.lang), "no parser for " .. spec.lang)
  local root = parser:parse()[1]:root()
  local query = assert(vim.treesitter.query.get(spec.lang, "highlights"), "no highlights query for " .. spec.lang)

  -- Walk the highlights query. For each single-line word-like leaf token,
  -- remember the winning capture (highest priority; later capture wins a tie).
  local by_pos, order = {}, {}
  for id, node, metadata in query:iter_captures(root, buf, 0, -1) do
    local row0, col0, erow = node:range()
    if row0 == erow then
      local text = vim.treesitter.get_node_text(node, buf)
      if text:match("^[%w_]+$") then
        local key = row0 .. ":" .. col0
        local entry = by_pos[key]
        if not entry then
          entry = { text = text, row = row0, col = col0, capture = nil, prio = -1 }
          by_pos[key] = entry
          order[#order + 1] = entry
        end
        local prio = TS_PRIORITY
        local meta = metadata and metadata[id]
        if meta and meta.priority then prio = tonumber(meta.priority) or prio end
        if prio >= entry.prio then
          entry.prio = prio
          entry.capture = "@" .. query.captures[id]
        end
      end
    end
  end

  local tokens = {}
  for _, entry in ipairs(order) do
    local pre, pre_group = syntax_at(entry.row, entry.col)
    local post, post_capture = resolved_capture_fg(entry.capture, spec.lang)
    tokens[#tokens + 1] = {
      text = entry.text,
      row = entry.row,
      col = entry.col,
      pre = pre or normal_fg,
      post = post or normal_fg,
      pre_group = pre_group,
      post_capture = post_capture,
      pops = (pre or normal_fg) ~= (post or normal_fg),
    }
  end

  table.sort(tokens, function(a, b)
    if a.row ~= b.row then return a.row < b.row end
    return a.col < b.col
  end)

  return normal_fg, tokens
end

--- Print a human-readable report for one spec. Returns the pop count.
--- @param name string display name
--- @param spec table same as M.detect
function M.report(name, spec)
  local normal_fg, tokens = M.detect(spec)

  print(string.format("== %s  [filetype=%s lang=%s]  Normal fg=%s ==",
    name, spec.filetype, spec.lang, to_hex(normal_fg)))
  print(string.format("  %-6s %-22s %-9s %-26s -> %-9s %s",
    "pos", "token", "frame1", "(syntax)", "frame2", "(ts capture)"))

  local pops = 0
  for _, t in ipairs(tokens) do
    if t.pops then
      pops = pops + 1
      print(string.format("  %-6s %-22s %-9s %-26s -> %-9s %s",
        t.row .. ":" .. t.col, t.text, to_hex(t.pre), t.pre_group, to_hex(t.post), t.post_capture))
    end
  end
  print(string.format("  -> %d popping token(s) of %d inspected\n", pops, #tokens))
  return pops
end

return M
