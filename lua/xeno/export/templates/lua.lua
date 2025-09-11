-- Lua colorscheme template for xeno.nvim exports
local M = {}

-- Template for generating standalone Lua colorschemes with variant support
M.template = [[{{HEADER_COMMENT}}

-- Clear existing highlights
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.g.colors_name = '{{THEME_NAME}}'

-- Detect current background and set appropriate colors
local function get_variant_colors()
  local variant = vim.o.background or "dark"
  
  if variant == "light" then
    return {
{{LIGHT_COLOR_DEFINITIONS}}
    }
  else
    return {
{{DARK_COLOR_DEFINITIONS}}
    }
  end
end

local colors = get_variant_colors()

-- Helper function to apply highlights
local function hi(group, opts)
  if not opts then return end
  
  -- Handle link highlights specially
  if opts.link then
    -- Use pcall to safely create links, skip if target doesn't exist
    local ok = pcall(function()
      vim.cmd('highlight! link ' .. group .. ' ' .. opts.link)
    end)
    if not ok then
      -- If link fails, silently skip this highlight
      return
    end
    return
  end
  
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
  
  -- Use pcall to safely execute highlight commands
  local ok = pcall(function()
    vim.cmd(cmd)
  end)
  if not ok then
    -- If highlight command fails, silently skip
    return
  end
end

-- Apply highlights function
local function apply_highlights()
{{EDITOR_HIGHLIGHTS}}
end

-- Auto-reload colors when background changes
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    colors = get_variant_colors()
    -- Re-apply highlights with new colors
    apply_highlights()
  end,
})

-- Initial application
apply_highlights()]]

-- Placeholders that will be replaced during generation
M.placeholders = {
  "{{HEADER_COMMENT}}",
  "{{THEME_NAME}}",
  "{{LIGHT_COLOR_DEFINITIONS}}",
  "{{DARK_COLOR_DEFINITIONS}}",
  "{{EDITOR_HIGHLIGHTS}}",
}

return M

