-- Vim colorscheme template for xeno.nvim exports
local M = {}

-- Template for generating standalone Vim colorschemes
M.template = [[{{HEADER_COMMENT}}

" Clear existing highlights
highlight clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = '{{THEME_NAME}}'

" Color definitions
{{COLOR_DEFINITIONS}}

" Editor UI highlights
{{EDITOR_HIGHLIGHTS}}

" Syntax highlights
{{SYNTAX_HIGHLIGHTS}}

" TreeSitter highlights
{{TREESITTER_HIGHLIGHTS}}

" LSP highlights
{{LSP_HIGHLIGHTS}}

" Plugin highlights
{{PLUGIN_HIGHLIGHTS}}

" Additional highlights
{{OTHER_HIGHLIGHTS}}

" Terminal colors
{{TERMINAL_COLORS}}]]

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