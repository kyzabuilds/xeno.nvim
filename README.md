<img title="xeno banner" alt="xeno banner" src="./media/banner.png">

<p align='center'>
  <strong>Minimalist dual-tone colorscheme generator with automatic light/dark mode support</strong><br/>
  Create complete themes using just two colors • Extensive theming API • Export capabilities<br/>
  Explore <a href="examples.md">theme examples</a> and <a href="plugins.md">supported plugins</a>
</p>

## Key Features

- **Automatic Light/Dark Mode** - Seamlessly adapts to `vim.o.background` changes
- **Dual-Tone Generation** - Complete themes from just two base colors
- **Extensive Theming API** - Granular control over every highlight group
- **Export Capabilities** - Generate standalone colorscheme files
- **Plugin Integration** - Built-in support for 20+ popular plugins
- **Familiar Color System** - Familiar color scales with `50-950`

## Installation

**lazy.nvim**
```lua
{
  'kyza0d/xeno.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('xeno').theme('my-theme', {
      base = '#1E1E1E',
      accent = '#8CBE8C',
    })
    vim.cmd('colorscheme my-theme')
  end,
}
```

**mini.deps**
```lua
local MiniDeps = require('mini.deps')
MiniDeps.add('kyza0d/xeno.nvim')

require('xeno').theme('my-theme', {
  base = '#1E1E1E',
  accent = '#8CBE8C',
})
vim.cmd('colorscheme my-theme')
```

## Plugin Configuration

Customize plugin themes using high-level options:

```lua
require('xeno').theme('my-theme', {
  base = '#1a1a1a',
  accent = '#7aa2f7',
  highlights = {
    plugins = {
      ["nvim-telescope/telescope.nvim"] = {
        bg = "@base.950",
        fg = "@base.50", 
        border = "@accent.500",
      },
      ["akinsho/bufferline.nvim"] = {
        selected_bg = "@base.700",
        visible_bg = "@base.900",
        separator = "@base.600",
      },
      ["nvim-tree/nvim-tree.lua"] = {
        bg = "@base.800",
        fg = "@base.200",
        folder_fg = "@accent.300",
      },
    },
  },
})
```

This provides intuitive controls over plugin appearance while maintaining full compatibility with granular highlight overrides.

## Customization

xeno.nvim supports extensive customization through the `highlights` parameter. See [examples.md](examples.md) for detailed configuration examples and color combinations.

## IPC Adapter

The IPC adapter allows external applications to query theme data from Neovim using the built-in RPC server.

### Enable IPC

```lua
require('xeno').setup({
  base = '#1E1E1E',
  accent = '#8CBE8C',
  integrations = {
    ipc = {
      enabled = true,
      debug = true,  -- Log server address on startup
    },
  },
})
```

**Important:** Neovim must be started with a server address for IPC to work:

```bash
# Start Neovim with a named socket
nvim --listen /tmp/nvim.sock

# Or let Neovim auto-assign a socket (check with :echo v:servername)
nvim --listen 127.0.0.1:6666

# Find your current socket address from within Neovim
:echo v:servername
```

### Testing IPC Setup

Use the debug script to verify your IPC setup:

```bash
cd examples
./debug-ipc.sh
```

This will check:
- Socket existence and location
- RPC connection
- xeno_ipc registration
- Color data availability

### Simple Export Example

Export your theme colors to a text file:

```bash
# Using Python
cd examples
./export-colors.py /tmp/nvim.sock my-colors.txt

# Using Bash
cd examples
./export-colors.sh /tmp/nvim.sock my-colors.txt
```

The scripts will automatically find your socket if you run them without arguments.

### External Access Examples

**Query colors from shell:**
```bash
# Get full color palette (returns JSON)
nvim --server /tmp/nvim.sock --remote-expr "json_encode(luaeval('_G.xeno_ipc.get_colors()'))"

# Get theme status
nvim --server /tmp/nvim.sock --remote-expr "json_encode(luaeval('_G.xeno_ipc.get_status()'))"

# Get specific color
nvim --server /tmp/nvim.sock --remote-expr "luaeval('_G.xeno_ipc.get_color(\"accent_500\")')"
```

**Using neovim-remote (nvr):**
```bash
# Install: pip install neovim-remote
nvr --remote-expr "json_encode(luaeval('_G.xeno_ipc.get_colors()'))"
nvr --remote-expr "json_encode(luaeval('_G.xeno_ipc.get_status()'))"
```

**Python integration:**
```python
import subprocess
import json

def get_xeno_colors():
    result = subprocess.run([
        'nvim', '--server', '/tmp/nvim.sock',
        '--remote-expr', "json_encode(luaeval('_G.xeno_ipc.get_colors()'))"
    ], capture_output=True, text=True)
    return json.loads(result.stdout)

colors = get_xeno_colors()
print(f"Base background: {colors['base_950']}")
print(f"Accent color: {colors['accent_500']}")
```

**Node.js integration:**
```javascript
const { execSync } = require('child_process');

function getXenoColors() {
  const result = execSync(
    `nvim --server /tmp/nvim.sock --remote-expr "luaeval('_G.xeno_ipc.get_colors()')"`,
    { encoding: 'utf8' }
  );
  return JSON.parse(result);
}

const colors = getXenoColors();
console.log(`Base background: ${colors.base_950}`);
console.log(`Accent color: ${colors.accent_500}`);
```

### Available IPC Methods

- `get_colors()` - Returns full color palette with all scales (base, accent, syntax, semantic)
- `get_config()` - Returns current theme configuration
- `get_status()` - Returns theme name, background mode, and status
- `get_highlights()` - Returns all generated highlight groups
- `get_color(ref)` - Returns specific color by reference (e.g., "base_500")
- `get_server()` - Returns server address and PID for client discovery

### Use Cases

- **External theme pickers** - Build GUI apps to preview and modify colors
- **Cross-editor sync** - Keep VS Code, Helix, or other editors in sync
- **System theming** - Update terminal, tmux, and system apps to match Neovim
- **Live preview tools** - Create real-time color adjustment interfaces
- **Automation** - Script theme changes based on time of day, git branch, etc.
