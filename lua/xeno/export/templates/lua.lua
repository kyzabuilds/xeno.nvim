-- Lua colorscheme template for xeno.nvim exports
local M = {}

-- Template for generating standalone Lua colorschemes
M.template = [[{{HEADER_COMMENT}}

-- Clear existing highlights
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.g.colors_name = '{{THEME_NAME}}'

-- Color definitions
{{COLOR_DEFINITIONS}}

-- Helper function to apply highlights
local function hi(group, opts)
  if not opts then return end
  
  local cmd = 'highlight ' .. group
  
  if opts.fg then cmd = cmd .. ' guifg=' .. opts.fg end
  if opts.bg then cmd = cmd .. ' guibg=' .. opts.bg end
  if opts.sp then cmd = cmd .. ' guisp=' .. opts.sp end
  
  local gui_attrs = {}
  local has_explicit_false = false
  
  -- Check if any attribute is explicitly set to false
  local style_attrs = {'bold', 'italic', 'underline', 'undercurl', 'strikethrough', 'reverse', 'standout'}
  for _, attr in ipairs(style_attrs) do
    if opts[attr] == false then
      has_explicit_false = true
      break
    end
  end
  
  -- If we have explicit false values, start with NONE to clear defaults
  if has_explicit_false then
    table.insert(gui_attrs, 'NONE')
  end
  
  -- Add only the attributes that are explicitly true
  if opts.bold == true then table.insert(gui_attrs, 'bold') end
  if opts.italic == true then table.insert(gui_attrs, 'italic') end
  if opts.underline == true then table.insert(gui_attrs, 'underline') end
  if opts.undercurl == true then table.insert(gui_attrs, 'undercurl') end
  if opts.strikethrough == true then table.insert(gui_attrs, 'strikethrough') end
  if opts.reverse == true then table.insert(gui_attrs, 'reverse') end
  if opts.standout == true then table.insert(gui_attrs, 'standout') end
  
  if #gui_attrs > 0 then
    cmd = cmd .. ' gui=' .. table.concat(gui_attrs, ',')
  end
  
  vim.cmd(cmd)
end

-- Apply highlights (theme-aware for dual-variant exports)
{{EDITOR_HIGHLIGHTS}}

-- Syntax highlights
{{SYNTAX_HIGHLIGHTS}}

-- TreeSitter highlights
{{TREESITTER_HIGHLIGHTS}}

-- LSP highlights
{{LSP_HIGHLIGHTS}}

-- Plugin highlights
{{PLUGIN_HIGHLIGHTS}}

-- Additional highlights
{{OTHER_HIGHLIGHTS}}

-- Terminal colors
{{TERMINAL_COLORS}}

-- Apply highlights initially and setup auto-refresh on background change
if type(apply_highlights) == "function" then
  apply_highlights()
  
  -- Auto-refresh when background changes  
  local augroup = vim.api.nvim_create_augroup("XenoThemeRefresh", { clear = true })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = augroup,
    pattern = "background",
    callback = function()
      apply_highlights()
    end,
  })
end]]

-- Placeholders that will be replaced during generation
M.placeholders = {
  "{{HEADER_COMMENT}}",
  "{{THEME_NAME}}",
  "{{COLOR_DEFINITIONS}}",
  "{{EDITOR_HIGHLIGHTS}}",
  "{{SYNTAX_HIGHLIGHTS}}",
  "{{TREESITTER_HIGHLIGHTS}}",
  "{{LSP_HIGHLIGHTS}}",
  "{{PLUGIN_HIGHLIGHTS}}",
  "{{OTHER_HIGHLIGHTS}}",
  "{{TERMINAL_COLORS}}",
}

return M