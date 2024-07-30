-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Don't make a habit of using this function in this file
-- Arbitrary mode key mapping function
-- modes: {"i", "n"} to do both insert and normal mode for example
local function keymap(modes, lhs, rhs, opts)
  local options = { noremap = true, silent = true }

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  for index, value in ipairs(modes) do
    vim.api.nvim_set_keymap(value, lhs, rhs, options)
  end
end

-- Navbuddy fix
keymap({ "i" }, "<C-k>", "<Esc><cmd>Navbuddy<CR>")

-- Configure telescope here since I'm lazy
require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules/.*", -- Ignore everything under node_modules
      ".git/.*", -- Ignore everything under .git
      ".pixi/.*", -- Ignore everything under .pixi
    },
  },
})

-- UI Plugins

local colors = require("tokyonight.colors").setup()

require("scrollbar").setup({
  handle = {
    color = colors.bg_highlight,
  },
  marks = {
    Cursor = {
      text = "*",
      priority = 0,
      gui = nil,
      color = nil,
      cterm = nil,
      color_nr = nil, -- cterm
      highlight = "Normal",
    },
    Search = { color = colors.orange },
    Error = {
      color = colors.error,
    },
    Warn = {
      color = nil --[[colors.warning]],
    },
    Info = {
      color = nil --[[colors.info]],
    },
    Hint = {
      color = nil --[[colors.hint]],
    },
    Misc = {
      color = nil --[[colors.purple]],
    },
  },
  handlers = {
    cursor = false,
    --diagnostic = false,
  },
})

-- require("ufo").setup({
--   provider_selector = function(bufnr, filetype, buftype)
--     return { "treesitter", "indent" }
--   end,
-- })
