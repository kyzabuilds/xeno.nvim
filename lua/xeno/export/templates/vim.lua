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

" All highlights
{{EDITOR_HIGHLIGHTS}}]]

-- Placeholders that will be replaced during generation
M.placeholders = {
  "{{HEADER_COMMENT}}",
  "{{THEME_NAME}}",
  "{{COLOR_DEFINITIONS}}",
  "{{EDITOR_HIGHLIGHTS}}",
}

return M

