# Theme Showcase

## Sylvan

<img title="Sylvan" alt="Sylvan" src="./media/sylvan.png">

```lua
xeno.theme('sylvan', {
  background = '#151615',
  accent = '#3b594e',
  contrast = -0.3,
  variation = 0.1,
})
```

## Verdigris

<img title="Verdigris" alt="Verdigris" src="./media/verdigris.png">

```lua
xeno.color('teal', '#5fb3a1')
xeno.color('aqua', '#7fd1c0')
xeno.color('sky', '#8fc8e8')
xeno.color('cyan', '#6bc6c0')
xeno.color('moss', '#a3c98a')
xeno.color('sage', '#bcd4a8')
xeno.color('violet', '#9d8ad0')
xeno.color('lilac', '#b8a8e0')
xeno.color('copper', '#e0996a')
xeno.color('amber', '#e0b46a')
xeno.color('rose', '#e08a96')

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

## Latte Express

<img title="Latte Express" alt="Latte Express" src="./media/latte%20express.png">

```lua
xeno.color('caramel', '#E6A15C')
xeno.color('cinnamon', '#CD6A53')
xeno.color('cream', '#F1E3D3')
xeno.color('latte', '#D8B395')
xeno.color('mocha', '#A08066')
xeno.color('matcha', '#A3B18A')
xeno.color('chai', '#E9C46A')

xeno.theme('latte-express', {
  background = '#1A120B',
  accent = '#EADBC8',
  foreground = '#F5EFE6',
  properties = {
    contrast = 0.12,
    chroma = 0.05,
    lightness = 0.04,
    variation = 0.15,
  },
  highlights = {
    editor = {
      Normal = { fg = '@foreground.200' },
      LineNr = { fg = '@background.500' },
      CursorLineNr = { fg = '@accent.200', bold = true },
      Visual = { bg = xeno.opaque('@accent.500', 0.18) },
      CursorLine = { bg = xeno.opaque('@background.600', 0.05) },
      MatchParen = { fg = '@caramel.200', bold = true, underline = true },
    },
    syntax = {
      Comment = { fg = '@foreground.400', italic = true },
      Keyword = { fg = '@caramel.300' },
      Conditional = { fg = '@cinnamon.300' },
      Function = { fg = '@cream.200' },
      Type = { fg = '@matcha.300' },
      String = { fg = '@latte.300' },
      Number = { fg = '@chai.200' },
      Boolean = { fg = '@chai.200' },
      Variable = { fg = '@foreground.200' },
      Property = { fg = '@mocha.200' },
      ['@keyword'] = { link = 'Keyword' },
      ['@keyword.function'] = { link = 'Keyword' },
      ['@keyword.return'] = { link = 'Conditional' },
      ['@keyword.conditional'] = { link = 'Conditional' },
      ['@keyword.repeat'] = { link = 'Conditional' },
      ['@keyword.operator'] = { link = 'Operator' },
      ['@keyword.import'] = { fg = '@cinnamon.200' },
      ['@function'] = { link = 'Function' },
      ['@function.builtin'] = { fg = '@accent.200' },
      ['@function.method'] = { link = 'Function' },
      ['@function.macro'] = { fg = '@caramel.200' },
      ['@type'] = { link = 'Type' },
      ['@type.builtin'] = { fg = '@matcha.200' },
      ['@type.definition'] = { link = 'Type' },
      ['@string'] = { link = 'String' },
      ['@string.regex'] = { fg = '@cinnamon.200' },
      ['@string.escape'] = { fg = '@chai.200' },
      ['@number'] = { link = 'Number' },
      ['@boolean'] = { link = 'Boolean' },
      ['@variable'] = { link = 'Variable' },
      ['@variable.builtin'] = { fg = '@cinnamon.200' },
      ['@variable.parameter'] = { fg = '@foreground.100' },
      ['@property'] = { link = 'Property' },
      ['@operator'] = { link = 'Operator' },
      ['@punctuation'] = { link = 'Punctuation' },
      ['@punctuation.bracket'] = { link = 'Punctuation' },
      ['@punctuation.delimiter'] = { link = 'Punctuation' },
      ['@lsp.type.variable'] = { link = '@variable' },
      ['@lsp.type.property'] = { link = '@property' },
      ['@lsp.type.function'] = { link = '@function' },
      ['@lsp.type.method'] = { link = '@function.method' },
      ['@lsp.type.type'] = { link = '@type' },
      ['@lsp.type.keyword'] = { link = '@keyword' },
      ['@lsp.type.parameter'] = { link = '@variable.parameter' },
    },
  },
})
```

## Polarized

<img title="Polarized" alt="Polarized" src="./media/polarized.png">
