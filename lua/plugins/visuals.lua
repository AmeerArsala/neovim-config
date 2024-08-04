return {
  {
    "rmehri01/onenord.nvim",
    config = function()
      require("onenord").setup({
        borders = true,
        fade_nc = false,
        styles = {
          comments = "italic",
          strings = "NONE",
          keywords = "NONE",
          functions = "italic",
          variables = "bold",
          diagnostics = "underline",
        },
        disable = {
          background = false,
          cursorline = false,
          eob_lines = true,
        },
        colors = {},
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    config = function()
      local theme = require("tokyonight")
      -- theme.setup({
      --     style = 'night',
      --     on_colors = function(colors)
      --         colors.bg_dark = '#000000'
      --         colors.bg = '#11121D'
      --         -- colors.bg_visual = M.colors.grey12
      --     end
      -- })
      theme.load()
    end,
  },
  {
    "navarasu/onedark.nvim",
    config = function()
      local theme = require("onedark")
      theme.setup({
        style = "deep",
        transparent = false, -- Show/hide background
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
          variables = "none",
        },
        lualine = {
          transparent = true, -- lualine center bar transparency
        },
      })
      theme.load()
      -- loadNoClownFiesta()
    end,
  },
  {
    "JoosepAlviste/palenightfall.nvim",
    config = function()
      require("palenightfall").setup({})
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    config = function()
      require("nordic").setup({})
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    config = function()
      vim.o.background = "dark"
      require("onedarkpro").load()
    end,
  },
  {
    "tiagovla/tokyodark.nvim",
    config = function()
      vim.g.tokyodark_transparent_background = false
      vim.g.tokyodark_enable_italic_comment = true
      vim.g.tokyodark_enable_italic = true
      vim.g.tokyodark_color_gamma = "0.0"
      --vim.cmd("colorscheme tokyodark")
    end,
  },
  {
    "bluz71/vim-moonfly-colors",
    config = function()
      local theme = require("moonfly")
      --theme.load()
      --vim.cmd([[colorscheme moonfly]])
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    config = function()
      local theme = require("dracula")
      theme.setup({})
      theme.load()
    end,
  },
  {
    "magidc/draculanight",
    config = function()
      local theme = require("draculanight")
      theme.setup({})
      theme.load()
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
      local theme = require("catppuccin")
      theme.setup({})
      theme.load()
      --vim.cmd([[colorscheme catppuccin]])
    end,
  },
  {
    "AmeerArsala/flow.nvim",
    name = "flow",
    lazy = false,
    priority = 1000,
    config = function()
      local theme = require("flow")
      theme.setup({
        transparent = true,
        fluo_color = "pink",
        mode = "normal",
        aggressive_spell = false,
      })
      theme.load()
      --vim.cmd([[colorscheme flow]])
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    config = function()
      local theme = require("nightfox")
      theme.setup({})
      theme.load()
      --vim.cmd([[colorscheme nightfox]])
    end,
  },
  {
    "Everblush/nvim",
    name = "everblush",
  },
}
