-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

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
      "__pycache__/.*", -- Ignore everything under __pycache__
      ".ipynb_checkpoints/.*", -- Ignore everything under .ipynb_checkpoints
      ".mypy_cache/.*", -- Ignore everything under .mypy_cache
      "ruff_cache/.*", -- Ignore everything under ruff_cache
      ".pytest_cache/.*", -- Ignore everything under .pytest_cache
      ".venv/.*", -- Ignore everything under .venv
      "node_modules/.*", -- Ignore everything under node_modules
    },
  },
})

-- UI Plugins

local colors = require("tokyonight.colors").setup()
vim.cmd([[colorscheme tokyonight-moon]])

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

--require("plugins.molten").init()
