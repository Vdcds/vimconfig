return {
  -- Disable default LazyVim colorschemes
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },

  -- Create custom colorscheme based on your Alacritty theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "pastel_orange",
    },
  },

  -- Add transparency plugin
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1001, -- Load after colorscheme
    opts = {
      groups = { -- table: default groups
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer',
      },
      extra_groups = {
        "NormalFloat", "FloatBorder", "NvimTreeNormal",
        "TelescopeNormal", "TelescopeBorder", "WhichKeyFloat",
        "BufferLineTabClose", "BufferlineBufferSelected",
        "BufferLineFill", "BufferLineBackground",
        "BufferLineSeparator", "BufferLineIndicatorSelected",
      },
    },
    config = function(_, opts)
      require("transparent").setup(opts)
      -- Enable transparency on startup
      vim.cmd("TransparentEnable")
    end,
  },

  -- Custom colorscheme implementation
  {
    "rktjmp/lush.nvim", -- Lush helps create colorschemes
    priority = 1000,
    config = function()
      -- Create pastel_orange.lua in colors directory
      local colors_dir = vim.fn.stdpath("config") .. "/colors"
      local file_path = colors_dir .. "/pastel_orange.lua"

      -- Create the colors directory if it doesn't exist
      if vim.fn.isdirectory(colors_dir) == 0 then
        vim.fn.mkdir(colors_dir, "p")
      end

      -- Write the colorscheme file
      local file = io.open(file_path, "w")
      if file then
        file:write([[
-- Pastel Orange theme matching Alacritty configuration
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "pastel_orange"

-- Define colors from Alacritty config
local colors = {
  bg = "NONE", -- Use NONE to make the background transparent
  fg = "#cccccc",
  black = "#2A2A2A",
  bright_black = "#3A3A3A",
  red = "#FF9B6B",
  bright_red = "#FFB08F",
  green = "#FFBC8F",
  bright_green = "#FFCBA4",
  yellow = "#FFCBA4",
  bright_yellow = "#FFD6B0",
  blue = "#FFD6B0",
  bright_blue = "#FFE0C4",
  magenta = "#FFE0C4",
  bright_magenta = "#FFEAD9",
  cyan = "#FFEAD9",
  bright_cyan = "#FFF5ED",
  white = "#FFF5ED",
  bright_white = "#FFFFFF",
  selection_bg = "#FFD6B0",
  selection_fg = "#1A1A1A",

  -- Additional shades
  bg_lighter = "NONE", -- Make floating windows transparent too
  bg_dark = "NONE", -- Make other UI elements transparent
  dim_text = "#FFCBA4",
  comment = "#A89380",
  line_nr = "#B39C88",
  status = "#FFB08F",
}

-- Define highlight groups
local highlights = {
  -- Editor - set backgrounds to NONE for transparency
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.bg_lighter },
  FloatBorder = { fg = colors.bright_yellow, bg = colors.bg_lighter },
  ColorColumn = { bg = colors.bg_lighter },
  Cursor = { fg = colors.bg, bg = colors.fg },
  CursorLine = { bg = colors.bg_lighter },
  CursorLineNr = { fg = colors.bright_yellow, bold = true },
  LineNr = { fg = colors.line_nr },
  SignColumn = { fg = colors.fg, bg = colors.bg },
  VertSplit = { fg = colors.bright_black, bg = colors.bg },
  WinSeparator = { fg = colors.bright_black, bg = colors.bg },

  -- Syntax
  Comment = { fg = colors.comment, italic = true },
  Constant = { fg = colors.bright_red },
  String = { fg = colors.green },
  Character = { fg = colors.green },
  Number = { fg = colors.bright_red },
  Boolean = { fg = colors.bright_red },
  Float = { fg = colors.bright_red },
  Identifier = { fg = colors.magenta },
  Function = { fg = colors.yellow },
  Statement = { fg = colors.red },
  Conditional = { fg = colors.red },
  Repeat = { fg = colors.red },
  Label = { fg = colors.magenta },
  Operator = { fg = colors.cyan },
  Keyword = { fg = colors.red },
  Exception = { fg = colors.red },
  PreProc = { fg = colors.yellow },
  Include = { fg = colors.red },
  Define = { fg = colors.red },
  Title = { fg = colors.bright_cyan, bold = true },
  Macro = { fg = colors.red },
  PreCondit = { fg = colors.yellow },
  Type = { fg = colors.blue },
  StorageClass = { fg = colors.yellow },
  Structure = { fg = colors.yellow },
  Typedef = { fg = colors.yellow },
  Special = { fg = colors.bright_cyan },
  SpecialChar = { fg = colors.bright_green },
  Tag = { fg = colors.bright_yellow },
  Delimiter = { fg = colors.dim_text },
  SpecialComment = { fg = colors.comment, italic = true },
  Debug = { fg = colors.bright_red },
  Underlined = { fg = colors.blue, underline = true },
  Ignore = { fg = colors.bright_black },
  Error = { fg = colors.red, bg = colors.bg, bold = true },
  Todo = { fg = colors.bg, bg = colors.yellow, bold = true },

  -- UI
  StatusLine = { fg = colors.fg, bg = colors.bg_lighter },
  StatusLineNC = { fg = colors.dim_text, bg = colors.bg_lighter },
  TabLine = { fg = colors.dim_text, bg = colors.bg_lighter },
  TabLineFill = { bg = colors.bg_dark },
  TabLineSel = { fg = colors.fg, bg = colors.status },
  Search = { fg = colors.selection_fg, bg = colors.selection_bg },
  IncSearch = { fg = colors.selection_fg, bg = colors.bright_yellow },
  Pmenu = { fg = colors.fg, bg = colors.bg_lighter },
  PmenuSel = { fg = colors.selection_fg, bg = colors.selection_bg },
  PmenuSbar = { bg = colors.bg_lighter },
  PmenuThumb = { bg = colors.dim_text },
  Visual = { fg = colors.selection_fg, bg = colors.selection_bg },
  VisualNOS = { fg = colors.selection_fg, bg = colors.selection_bg },

  -- Diagnostics
  DiagnosticError = { fg = colors.red },
  DiagnosticWarn = { fg = colors.yellow },
  DiagnosticInfo = { fg = colors.blue },
  DiagnosticHint = { fg = colors.cyan },

  -- Git
  DiffAdd = { fg = colors.green, bg = colors.bg_lighter },
  DiffChange = { fg = colors.yellow, bg = colors.bg_lighter },
  DiffDelete = { fg = colors.red, bg = colors.bg_lighter },
  DiffText = { fg = colors.fg, bg = colors.bg_lighter },

  -- Treesitter
  ["@variable"] = { fg = colors.fg },
  ["@function"] = { fg = colors.yellow },
  ["@function.builtin"] = { fg = colors.bright_yellow },
  ["@parameter"] = { fg = colors.bright_magenta },
  ["@keyword"] = { fg = colors.red },
  ["@keyword.function"] = { fg = colors.red },
  ["@keyword.return"] = { fg = colors.red },
  ["@conditional"] = { fg = colors.red },
  ["@repeat"] = { fg = colors.red },
  ["@string"] = { fg = colors.green },
  ["@field"] = { fg = colors.bright_blue },
  ["@property"] = { fg = colors.bright_blue },
  ["@type"] = { fg = colors.blue },
  ["@namespace"] = { fg = colors.yellow },
  ["@constructor"] = { fg = colors.bright_yellow },
  ["@constant"] = { fg = colors.bright_red },
  ["@comment"] = { fg = colors.comment, italic = true },
}

-- Apply highlights
for group, style in pairs(highlights) do
  local command = "highlight " .. group
  for key, value in pairs(style) do
    if key == "fg" then
      command = command .. " guifg=" .. value
    elseif key == "bg" then
      command = command .. " guibg=" .. value
    elseif value == true then
      command = command .. " gui=" .. key
    end
  end
  vim.cmd(command)
end
        ]])
        file:close()
      end
    end,
  },
}