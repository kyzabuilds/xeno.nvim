local t = require("tests.helpers")

-- Recreates the treesitter "pop-in" flash: before the treesitter highlighter
-- attaches, every token paints at Normal fg; treesitter then recolors each one.
-- Any token whose treesitter color differs from Normal is a visible pop.
-- These tests pin the offending tokens and confirm the LSP layer is neutralized
-- (semantic-token groups resolve to the same colors as treesitter, so they add
-- no further pop).

local SAMPLE = {
  "require('editor.keymaps')",
  "require('editor.options')",
  "require('editor.autocmds')",
  "require('editor.external_window').setup()",
  "",
  "package.path =",
  "  fmt('%s/.luarocks/share/lua/5.1/?/init.lua;%s/.luarocks/share/lua/5.1/?.lua;', vim.fn.expand('$HOME'), vim.fn.expand('$HOME'))",
  "package.cpath = fmt('%s/.luarocks/lib/lua/5.1/?/so', vim.fn.expand('$HOME'))",
}

local function setup_theme()
  t.reset_state()
  vim.o.background = "dark"

  local xeno = require("xeno")
  xeno.setup(t.test_config({
    background = "#1f2335",
    accent = "#7aa2f7",
  }))

  return xeno
end

-- Load the sample into a scratch lua buffer with treesitter highlighting active.
local function load_sample()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, SAMPLE)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = "lua"

  local ok = pcall(vim.treesitter.start, buf, "lua")
  if not ok then
    return nil
  end
  vim.treesitter.get_parser(buf, "lua"):parse()
  return buf
end

-- Resolved fg of the winning treesitter capture at a 0-indexed position.
local function ts_fg(buf, row, col)
  local caps = vim.treesitter.get_captures_at_pos(buf, row, col)
  for i = #caps, 1, -1 do
    local hl = t.get_hl("@" .. caps[i].capture)
    if hl.fg then
      return hl.fg, "@" .. caps[i].capture
    end
  end
  return nil
end

t.describe("treesitter pop-in", function()
  t.it("recolors known tokens away from Normal fg (the pop)", function()
    setup_theme()
    local buf = load_sample()
    if not buf then
      return -- lua parser unavailable; nothing to assert
    end

    local normal = t.get_hl("Normal").fg

    -- token: { row, col (0-indexed), expected capture }
    local tokens = {
      { 6, 82, "@variable" }, -- `vim`            -> dim foreground_400 (largest pop)
      { 5, 0, "@module.builtin" }, -- `package`   -> dim gray
      { 0, 9, "@string" }, -- `editor`            -> string accent
      { 3, 35, "@function.call" }, -- `setup`     -> function accent
      { 0, 0, "@function.builtin" }, -- `require`
      { 5, 8, "@variable.member" }, -- `path`
    }

    for _, tok in ipairs(tokens) do
      local fg, capture = ts_fg(buf, tok[1], tok[2])
      t.truthy(fg, string.format("expected a treesitter fg at [%d,%d]", tok[1], tok[2]))
      t.eq(capture, tok[3])
      t.ne(fg, normal, string.format("%s should differ from Normal fg (pop)", tok[3]))
    end
  end)

  t.it("makes @variable the largest pop (bright Normal -> dim foreground_400)", function()
    local xeno = setup_theme()
    local buf = load_sample()
    if not buf then
      return
    end

    local fg = ts_fg(buf, 6, 82) -- `vim`
    t.eq(fg, xeno.colors.foreground_400)
    t.ne(fg, t.get_hl("Normal").fg)
  end)

  t.it("neutralizes the LSP layer: semantic groups match treesitter colors", function()
    setup_theme()

    -- @lsp is cleared, so readonly mod/typemod links resolve to no override.
    t.falsy(t.get_hl("@lsp").fg)
    t.falsy(t.get_hl("@lsp.mod.readonly").fg)
    t.falsy(t.get_hl("@lsp.typemod.variable.readonly").fg)

    -- @lsp.type.* resolve to the same colors treesitter already painted,
    -- so semantic tokens add no further pop.
    t.eq(t.get_hl("@lsp.type.variable").fg, t.get_hl("@variable").fg)
    t.eq(t.get_hl("@lsp.type.function").fg, t.get_hl("@function").fg)
    t.eq(t.get_hl("@lsp.type.property").fg, t.get_hl("@property").fg)
  end)
end)
