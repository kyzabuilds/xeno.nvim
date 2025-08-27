local defaults = {}

defaults.config = {
  base = "#030303",
  accent = "#7AA2F7",
  variation = 0.0,
  contrast = 0,
  transparent = false,

  red = "#E86671",
  green = "#A9DC76",
  yellow = "#E7C547",
  orange = "#FFA94D",
  blue = nil,
  purple = nil,
  cyan = nil,

  -- Add highlights configuration support
  highlights = {
    editor = {},
    syntax = {},
    plugins = {},
  },

  plugins = {
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "SmiteshP/nvim-navic",
    "folke/todo-comments.nvim",
    "lukas-reineke/indent-blankline.nvim",
    "nvim-neo-tree/neo-tree.nvim",
    "lewis6991/gitsigns.nvim",
    "akinsho/bufferline.nvim",
    "ibhagwan/fzf-lua",
    "folke/trouble.nvim",
  },
}

return defaults
