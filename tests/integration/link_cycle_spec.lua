local t = require("tests.helpers")

-- A user that redefines a concrete group name and also links a treesitter
-- capture back to it creates a link cycle (Keyword -> @keyword -> Keyword).
-- Passed straight to Neovim this hangs redraw; the merger must sever the cycle,
-- fall back to the base highlight so the group keeps a color, and let setup()
-- finish successfully.
t.it("recovers from circular highlight links instead of freezing", function()
  t.reset_state()

  local xeno = require("xeno")
  xeno.setup(t.test_config({
    background = "#181622",
    accent = "#9b84db",
    highlights = {
      syntax = {
        Keyword = { fg = "@accent.200" },
        ["@keyword"] = { link = "Keyword" },
        -- This overrides the concrete Keyword above, closing the loop.
        ["Keyword"] = { link = "@keyword" },
      },
    },
  }))

  -- The cycle is severed: neither group still links back into the loop.
  local kw = vim.api.nvim_get_hl(0, { name = "Keyword" })
  local ts = vim.api.nvim_get_hl(0, { name = "@keyword" })
  t.falsy(kw.link == "@keyword" and ts.link == "Keyword", "link cycle should be broken")

  -- And the recovered group keeps a working color from the base theme.
  t.truthy(t.get_hl("Keyword").fg, "Keyword should fall back to a concrete base color")
end)
