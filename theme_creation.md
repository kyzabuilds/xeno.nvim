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

### Referencing in a spec

A highlight value is a normal `nvim_set_hl` table, except `fg`/`bg`/`sp` accept
`@family.level` references:

```lua
['@string']  = { fg = '@green.300' },     -- explicit shade
['@keyword'] = { fg = '@accent' },        -- no level → nearest shade to 500 (see gotcha below)
['Type']     = { link = '@type' },        -- a real link; link targets are NOT reinterpreted
['@spell']   = { clear = true },          -- apply an empty group
['LineNr']   = { fg = '@background.500' }, -- background family used as fg is fine
```

**No-level gotcha:** `@family` with no level resolves to the shade nearest L 0.50
(~500). If your seed is already bright (a pastel green at L≈0.82), level 500 is
*much darker* than the seed, so `@green` renders dim. For bright seeds on
prominent tokens, reference an explicit light level (`@green.300`/`.200`).
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
semantic tokens (`@lsp.type.*` — 125–127, highest). When an LSP attaches and
`@lsp.type.variable` has a *different color* than `@variable`, every variable
snaps to a new color the instant it connects — a jarring "pop-in," maximally
visible because variables are the most common token.

**Rule: any `@lsp.type.*` you touch must be `{ clear = true }` or
`{ link = "<its treesitter equivalent>" }` — never a distinct color.**

```lua
['@variable']          = { fg = '@foreground.100' },
['@lsp.type.variable'] = { link = '@variable' },   -- all layers agree → no pop-in
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
`contrast`/`chroma`; strings use an explicit light level (`.300`) per the gotcha;
each concept defined once as a primitive with everything linked to it (DRY), so
an exception like `@function.builtin` is a one-line override and the rest stays
in sync.

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
      CursorLineNr = { fg = '@copper', bold = true },
      MatchParen = { fg = '@copper', bold = true },
    },
    syntax = {
      -- Primitives: each concept once.
      Comment = { fg = '@foreground.400', italic = true },
      Keyword = { fg = '@violet' },
      Conditional = { fg = '@lilac' },
      Function = { fg = '@teal' },
      Type = { fg = '@aqua' },
      String = { fg = '@moss.300' },
      Number = { fg = '@copper' },
      Boolean = { fg = '@copper' },
      Variable = { fg = '@foreground.300' },
      Property = { fg = '@sage' },
      Operator = { fg = '@sky' },
      Punctuation = { fg = '@foreground.300' },

      -- Captures: link to primitives, or override for a different intent.
      ['@keyword'] = { link = 'Keyword' },
      ['@keyword.return'] = { link = 'Keyword' },
      ['@keyword.function'] = { link = 'Conditional' },
      ['@keyword.conditional'] = { link = 'Conditional' },
      ['@keyword.repeat'] = { link = 'Conditional' },
      ['@keyword.operator'] = { fg = '@sky' },
      ['@keyword.import'] = { fg = '@cyan.400' },

      ['@function'] = { link = 'Function' },
      ['@function.builtin'] = { fg = '@aqua' },
      ['@type'] = { link = 'Type' },
      ['@string'] = { link = 'String' },
      ['@number'] = { link = 'Number' },
      ['@boolean'] = { link = 'Boolean' },

      ['@variable'] = { link = 'Variable' },
      ['@variable.builtin'] = { fg = '@rose' },
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
- [ ] No raw hex in any `fg`/`bg`/`sp`; only references, `xeno.opaque(...)`, or
      `'NONE'`/`clear` (§3a).
- [ ] UI surface backgrounds use `@background.*`, not hardcoded darks.
- [ ] Bright seeds on prominent tokens use an explicit light level (§2 gotcha).
- [ ] Themed through `@`-captures; legacy groups only as `link` fallbacks (§3c).
- [ ] Whole families covered — no half-colored keyword/literal sets.
- [ ] `@variable` kept near foreground unless deliberately loud.
- [ ] Every overridden `@lsp.type.*` is `clear` or `link`s to its capture (§3b).
- [ ] Loaded it and checked real code with an LSP attached — no pop-in.
