# Building themes with xeno

xeno doesn't ship hand-picked hex per highlight. You give it a few **seed
colors** and a few **perceptual knobs**; it generates whole OKLCH color *scales*
(light→dark) and maps them onto editor + syntax groups. Your job: pick good
seeds, tune the knobs, override the handful of syntax groups that need a specific
intent — without breaking the rules that keep a theme coherent and flash-free.

Read once start to finish; after that the **Checklist** is enough.

---

## 1. Setup

```lua
local xeno = require('xeno')

xeno.setup({ background = '#1B1B1B', accent = '#523889', ... })  -- ACTIVE theme, loads on startup. Call once.
xeno.theme('my-theme', { background = '...', accent = '...' })   -- NAMED scheme, `:colorscheme my-theme`. Call any number.
xeno.color('ocean_blue', '#A6DBFF')                              -- custom FAMILY → `@ocean_blue.level`. MUST precede any theme using it.
```

`xeno.theme` merges over `xeno.setup`, so shared settings (transparency,
integrations, decorations) live in `setup` and each theme specifies only what
differs.

### Config shape

```lua
{
  background = '#1a1b26',   -- seeds `background_*` (and `foreground_*`, if foreground unset)
  accent     = '#7aa2f7',   -- seeds `accent_*`
  foreground = '#c0caf5',   -- OPTIONAL. seeds `foreground_*`. defaults to the background hue.

  properties = {            -- perceptual knobs (§3). all default to 0.
    contrast = -0.10, variation = 0.00, chroma = 0.10, lightness = 0.50,
  },

  min_contrast = nil,       -- OPTIONAL accessibility floor (1.0–21.0). off by default.

  highlights = {
    editor  = { ... },   -- UI: LineNr, Visual, StatusLine, Pmenu, ...
    syntax  = { ... },   -- code: @keyword, @function, String, Type, ...
    plugins = { ... },   -- plugins: Telescope*, CmpItem*, GitSigns*, ...
  },
}
```

`editor`, `syntax`, `plugins` are the **only** valid highlight categories;
anything else is rejected.

---

## 2. The palette

### Families and levels

Each seed produces a scale of shades, referenced as `@family.level`. **Only these
exact levels exist** — a non-existent level (`@accent.700`, `@foreground.500`)
silently falls back to `#000000`.

| Family | Levels |
| --- | --- |
| `foreground` | `50 100 200 300 400` |
| `background` | `500 600 700 800 900 950` |
| `accent`, custom (`xeno.color`) | `50 100 200 300 400 500 600` |
| semantic (`red`/`green`/`blue`/…) | bare name only (`@red`); also `name_500` |

Lightness per level (dark variant), lower number = lighter:

```
50→0.97  100→0.93  200→0.82  300→0.70  400→0.62
500→0.50  600→0.34  700→0.26  800→0.24  900→0.18  950→0.14
```

So `@accent.50` ≈ white, `@background.950` ≈ black. **Low numbers for prominent
foreground text, high numbers for backgrounds.**

A good theme uses the *range*, not just one or two levels per family — each
step down the scale should read as a deliberate step in visual weight, not an
accident of what was closest to hand:

| Level band | Reads as | Typical use |
| --- | --- | --- |
| `50`/`100` | brightest, most eye-catching | deliberate emphasis: literals you want to pop — numbers, strings, booleans, constants |
| `200`/`300` | clear, legible, "normal code color" | the bulk of syntax — keywords, functions, types, properties |
| `400` | receded, quiet | comments, punctuation, low-priority variables |
| `500`/`600` | near-background weight | rarely used as `fg`; mostly `bg` on custom/accent families for subtle fills |

**Shade `100` in particular is your emphasis lever.** It's brighter than the
"normal" `200`/`300` band but not as flat/white as `50`, so it reads as
"important" without looking like an error highlight. Reach for it on tokens you
want to visually lead the eye — numbers and strings are the classic case, since
they're semantically distinct from surrounding logic and benefit from standing
out at a glance. Don't apply it broadly, though — if everything is `100`,
nothing pops; reserve it for the two or three token kinds that should actually
lead.

### Referencing in a spec

A highlight value is a normal `nvim_set_hl` table, except `fg`/`bg`/`sp` accept
`@family.level` references:

```lua
['@string']  = { fg = '@green.100' },     -- explicit bright shade for emphasis
['@keyword'] = { fg = '@accent' },        -- no level → nearest shade to 500 (see gotcha below)
['Type']     = { link = '@type' },        -- a real link; link targets are NOT reinterpreted
['@spell']   = { clear = true },          -- apply an empty group
['LineNr']   = { fg = '@background.500' }, -- background family used as fg is fine
```

**No-level gotcha:** `@family` with no level resolves to the shade nearest L 0.50
(~500). If your seed is already bright (a pastel green at L≈0.82), level 500 is
*much darker* than the seed, so `@green` renders dim. For bright seeds on
prominent tokens, reference an explicit light level (`@green.300`/`.200`/`.100`).
Reserve no-level `@family` for seeds already near mid-lightness. This is the #1
reason a theme "looks darker than its reference."

### Blending: `xeno.opaque`

Blend a color into the background at partial opacity — selections, diffs, cursor
lines, search.

```lua
xeno.opaque(fg, opacity, bg?)   -- fg/bg: hex or @family.level. opacity 0.0–1.0 (UI typically 0.05–0.40)

Visual     = { bg = xeno.opaque('@accent.500', 0.20) },
CursorLine = { bg = xeno.opaque('@background.600', 0.05) },
DiffAdd    = { bg = xeno.opaque('@green', 0.25), fg = '@green' },
```

Background resolution (first match wins): `bg` arg → `background_950` → `Normal`'s
current bg → hardcoded last resort. Omit `bg` unless blending onto a non-editor
surface (e.g. a lighter float).

### The four knobs

Knobs apply **uniformly to every family** — they reshape the whole palette at
once. Tune them **before** hand-overriding groups; most of the palette's
character comes from seeds + knobs.

| Knob | Math | Effect |
| --- | --- | --- |
| `lightness` | `L += knob × 0.12` | all shades lighter (+) / darker (−). `0.50` ≈ +0.06 L. |
| `chroma` | `C ×= (1 + knob)` | saturation. `0.10` = +10% colorful; `-1.0` = grayscale. |
| `contrast` | surfaces → mid-gray by `1 + knob×0.5`; fg floored to WCAG min | − = softer/muted; + = punchier. |
| `variation` | fg spread `1 − knob×1.5` | higher = text/comment/dim spread further in lightness. |

Raising `lightness` washes colors toward gray, so a small positive `chroma` is
the usual counterweight (brighter but still colorful). Muted/pastel ≈ slightly
negative `contrast` + modest `chroma`; vivid ≈ positive `chroma`.

### The accessibility floor

`min_contrast` sits **outside** `properties`, at the top level of the config —
the four knobs are relative nudges, this is an absolute guarantee, and it's off
unless you ask for it. Set it to a WCAG ratio (`4.5` = AA normal text, `7.0` =
AAA) and xeno pushes `@foreground.50`–`.400` plus the accent levels used as
syntax text (`.100`/`.200`/`.300`, on `accent` and every `xeno.color()` family)
until they clear it against `@background.800`/`.900`/`.950`.

```lua
xeno.theme('tired-eyes', {
  background = '#1a1a1a', accent = '#7aa2f7',
  properties = { contrast = -0.3 },  -- still softens the surfaces
  min_contrast = 7.0,                -- but text never drops below AAA
})
```

Floors scale per level rather than flattening to one number, so the hierarchy in
§2 survives. It constrains `contrast` rather than replacing it. Reach for it
when a theme must hold a readability guarantee, not when you just want a
punchier look — that's still `contrast`. Very high ratios can hit the sRGB gamut
ceiling (roughly 15.5 dark / 12.8 light); xeno lands on the closest achievable
color instead of erroring, so check the extremes visually.

---

## 3. The rules

### a. No raw hex

Never hardcode hex in a spec. Raw hex is static — it won't invert, shift, or
scale with the theme's knobs or seeds. Use `@family.level` references or
`xeno.opaque(...)`. The only legitimate literals are pure pass-throughs that
carry no color: `{ clear = true }` and `{ bg = 'NONE' }`.

| Slot | Use |
| --- | --- |
| `bg` on UI surfaces (Pmenu, StatusLine, Float…) | `@background.*` or `xeno.opaque(...)` |
| `bg` on selection / diff / search | `xeno.opaque('@family.level', opacity)` |
| `fg` on UI surfaces | `@foreground.*` |
| `fg` on syntax tokens | `@family.level` |
| `sp` (underline) | `@family.level` |

### b. No pop-in (most important correctness rule)

Neovim resolves a token through three layers: Vim syntax (`Keyword`,
`Function`, … — lowest) → Treesitter (`@keyword`, … — priority 100) → LSP
semantic tokens (`@lsp.type.*`, `@lsp.mod.*`, `@lsp.typemod.*.*` — 125–127,
highest). When an LSP attaches and a semantic group has a *different color* than
the Treesitter capture already on screen, the token snaps to a new color the
instant it connects — a jarring "pop-in," maximally visible on high-frequency
tokens like variables and properties.

**Rule: any `@lsp.type.*` or `@lsp.typemod.*.*` you touch must be
`{ clear = true }` or `{ link = "<its treesitter equivalent>" }` — never a
distinct color. Modifier-only groups such as `@lsp.mod.declaration` should be
cleared unless you intentionally want style-only emphasis.**

```lua
['@variable']          = { fg = '@foreground.100' },
['@lsp.type.variable'] = { link = '@variable' },   -- all layers agree → no pop-in
```

For declaration/readonly/etc. semantic overlays, mirror the final type+modifier
group too. A TSX property declaration can arrive as all of these at once:

```lua
['@property'] = { link = 'Property' },
['@lsp.type.property'] = { link = '@property' },
['@lsp.mod.declaration'] = { clear = true },
['@lsp.typemod.property.declaration'] = { link = '@property' },
```

xeno's defaults already do this; only re-assert the link when you override the
underlying capture and want a non-default color.

### c. Targeting

- **Theme through `@`-captures, not legacy groups.** In a treesitter buffer the
  `@`-capture wins; setting `Keyword`/`Function` alone is silently shadowed. Set
  the `@`-capture; add the legacy group only as a `link` fallback for
  non-treesitter buffers (`['Type'] = { link = '@type' }`).
- **Cover whole families.** If you color `@keyword`, also handle
  `@keyword.function`/`.return`/`.conditional`/`.repeat`/`.operator`/`.import` —
  to a color or `link = '@keyword'`. Half-covered families look like a patchwork.
- **Keep `@variable` quiet** — it's the highest-frequency token. Reserve
  saturated colors for sparse tokens (keywords, types, functions, constants). For
  loud variables, mirror the color into `@lsp.type.variable` (rule b).
- **Link, don't repeat.** One source of truth per concept; related groups link to
  it. Impossible to drift, easy to retune.
- **Links must be semantically right** — `@constructor → @punctuation` is wrong
  even if the color happens to fit.
- **Use the full shade range on purpose.** A theme that only ever reaches for
  one or two levels per family (always `.300`, never anything else) looks flat
  no matter how good the seeds are. Let level choice *do work*: `100` for the
  handful of tokens that should visually lead (numbers, strings — see §2),
  `200`/`300` for the everyday bulk of syntax, `400` for things that should
  recede (comments, punctuation). The spread across levels is itself part of
  the theme's visual hierarchy, not just a fallback for when a color looks off.

### d. Editor vs syntax

**Editor is shared infrastructure** — every theme uses the same `LineNr`,
`StatusLine`, `Pmenu`, etc. **Leave it empty and let xeno's defaults apply**;
they're tuned across all seeds and variants. Override only for a specific
aesthetic need, a seed combination the default doesn't fit, or a readability bug.
Unnecessary editor overrides hardcode a dependency on your `background` shade and
break for anyone tuning knobs or trying a variant.

**Syntax is where the theme lives.** Seeds + knobs + a few intent overrides cohere
into a visual identity here. Nearly all theme work is picking seeds, tuning
knobs, and coloring captures per the rules above.

---

## 4. Worked example — Verdigris

Aged-copper-and-teal on a deep sage-charcoal base. Cool teals/aquas carry
structure (functions, types, operators); warm coppers/ambers carry literals and
emphasis (numbers, constants, builtins); a muted violet marks keywords. That
warm/cool tension is the identity — the trick any coherent palette uses.

Note the rules in action: custom families registered first; muted base via
`contrast`/`chroma`; literals (`Number`, `String`, `Boolean`) pulled up to `.100`
for emphasis per the gotcha and the "use the full range" rule in §3c, while the
everyday bulk of syntax (`Function`, `Type`, `Property`) sits at `.300`/`.200`
and low-priority tokens (`Comment`, `@constructor`) recede to `.400`; each
concept defined once as a primitive with everything linked to it (DRY), so an
exception like `@function.builtin` is a one-line override and the rest stays in
sync.

```lua
xeno.color('teal', '#5fb3a1'); xeno.color('aqua', '#7fd1c0'); xeno.color('sky', '#8fc8e8')
xeno.color('cyan', '#6bc6c0'); xeno.color('moss', '#a3c98a'); xeno.color('sage', '#bcd4a8')
xeno.color('violet', '#9d8ad0'); xeno.color('lilac', '#b8a8e0'); xeno.color('copper', '#e0996a')
xeno.color('amber', '#e0b46a'); xeno.color('rose', '#e08a96')

xeno.theme('verdigris', {
  background = '#14201d',
  accent = '#5fb3a1',
  foreground = '#d4e0db',
  properties = { contrast = 0.15, chroma = -0.10, lightness = 0.85 },

  highlights = {
    editor = {
      Normal = { fg = '@foreground.300' },
      LineNr = { fg = '@foreground.300' },
      CursorLineNr = { fg = '@copper.100', bold = true },
      MatchParen = { fg = '@copper.100', bold = true },
    },
    syntax = {
      -- Primitives: each concept once. Level chosen deliberately per §3c —
      -- .100 for tokens that should lead, .200/.300 for the everyday bulk,
      -- .400 for tokens that should recede.
      Comment = { fg = '@foreground.400', italic = true },
      Keyword = { fg = '@violet.300' },
      Conditional = { fg = '@lilac.300' },
      Function = { fg = '@teal.300' },
      Type = { fg = '@aqua.200' },
      String = { fg = '@moss.100' },
      Number = { fg = '@copper.100' },
      Boolean = { fg = '@copper.100' },
      Variable = { fg = '@foreground.300' },
      Property = { fg = '@sage.300' },
      Operator = { fg = '@sky.300' },
      Punctuation = { fg = '@foreground.400' },

      -- Captures: link to primitives, or override for a different intent.
      ['@keyword'] = { link = 'Keyword' },
      ['@keyword.return'] = { link = 'Keyword' },
      ['@keyword.function'] = { link = 'Conditional' },
      ['@keyword.conditional'] = { link = 'Conditional' },
      ['@keyword.repeat'] = { link = 'Conditional' },
      ['@keyword.operator'] = { fg = '@sky.300' },
      ['@keyword.import'] = { fg = '@cyan.400' },

      ['@function'] = { link = 'Function' },
      ['@function.builtin'] = { fg = '@aqua.100' },
      ['@type'] = { link = 'Type' },
      ['@string'] = { link = 'String' },
      ['@string.escape'] = { fg = '@amber.100' },
      ['@number'] = { link = 'Number' },
      ['@boolean'] = { link = 'Boolean' },
      ['@constant'] = { fg = '@amber.100' },
      ['@constant.builtin'] = { fg = '@amber.100', bold = true },

      ['@variable'] = { link = 'Variable' },
      ['@variable.builtin'] = { fg = '@rose.200' },
      ['@property'] = { link = 'Property' },
      ['@constructor'] = { fg = '@foreground.400' },
      ['@lsp.type.variable'] = { link = '@variable' },

      ['@operator'] = { link = 'Operator' },
      ['@punctuation'] = { link = 'Punctuation' },
      ['@punctuation.bracket'] = { link = 'Punctuation' },
      ['@punctuation.delimiter'] = { link = 'Punctuation' },
    },
  },
})
```

---

## 5. Checklist

- [ ] Custom families registered with `xeno.color()` **before** the theme.
- [ ] Seeds chosen for `background`, `accent`, and (if needed) `foreground`.
- [ ] Knobs tuned first — only `contrast`/`variation`/`chroma`/`lightness`.
- [ ] `min_contrast` set (top level, not in `properties`) if the theme must hold
      a readability floor.
- [ ] No raw hex in any `fg`/`bg`/`sp`; only references, `xeno.opaque(...)`, or
      `'NONE'`/`clear` (§3a).
- [ ] UI surface backgrounds use `@background.*`, not hardcoded darks.
- [ ] Bright seeds on prominent tokens use an explicit light level (§2 gotcha).
- [ ] Literals you want to lead the eye (numbers, strings, and similar) use
      `.100` deliberately, not just "whatever level looked closest" (§2, §3c).
- [ ] The palette spans the range — some tokens at `.100`, most at `.200`/`.300`,
      receded tokens at `.400` — rather than everything sitting on one level.
- [ ] Themed through `@`-captures; legacy groups only as `link` fallbacks (§3c).
- [ ] Whole families covered — no half-colored keyword/literal sets.
- [ ] `@variable` kept near foreground unless deliberately loud.
- [ ] Every overridden `@lsp.type.*`/`@lsp.typemod.*.*` is `clear` or `link`s to its capture (§3b).
- [ ] Loaded it and checked real code with an LSP attached — no pop-in.
