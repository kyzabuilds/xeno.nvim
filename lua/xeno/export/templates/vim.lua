-- Vim colorscheme template for xeno.nvim exports
local M = {}

-- Template for generating standalone Vim colorschemes with variant support
M.template = [[{{HEADER_COMMENT}}

" Clear existing highlights
highlight clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = '{{THEME_NAME}}'

" Function to get variant-appropriate colors
function! s:GetVariantColors()
  let l:variant = &background
  
  if l:variant ==# 'light'
    return {
{{LIGHT_COLOR_DEFINITIONS_VIM}}
    }
  else
    return {
{{DARK_COLOR_DEFINITIONS_VIM}}
    }
  endif
endfunction

let s:colors = s:GetVariantColors()

" Apply highlights function
function! s:ApplyHighlights()
  let s:colors = s:GetVariantColors()
{{EDITOR_HIGHLIGHTS_VIM}}
endfunction

" Auto-reload on background change
augroup {{THEME_NAME}}_variant
  autocmd!
  autocmd OptionSet background call s:ApplyHighlights()
augroup END

call s:ApplyHighlights()]]

-- Placeholders that will be replaced during generation
M.placeholders = {
  "{{HEADER_COMMENT}}",
  "{{THEME_NAME}}",
  "{{LIGHT_COLOR_DEFINITIONS_VIM}}",
  "{{DARK_COLOR_DEFINITIONS_VIM}}",
  "{{EDITOR_HIGHLIGHTS_VIM}}",
}

return M

