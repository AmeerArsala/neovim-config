-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

-- For kitty terminal
--vim.opt.clipboard = "unamed,unamedplus"
vim.cmd([[set clipboard=unnamedplus]])

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
--vim.api.nvim_del_keymap('n', "<c-w><space>")

-- Configure telescope here since I'm lazy
-- require("telescope").setup({
--   defaults = {
--     file_ignore_patterns = {
--       "node_modules/.*", -- Ignore everything under node_modules
--       ".git/.*", -- Ignore everything under .git
--       ".pixi/.*", -- Ignore everything under .pixi
--       "__pycache__/.*", -- Ignore everything under __pycache__
--       ".ipynb_checkpoints/.*", -- Ignore everything under .ipynb_checkpoints
--       ".mypy_cache/.*", -- Ignore everything under .mypy_cache
--       "ruff_cache/.*", -- Ignore everything under ruff_cache
--       ".pytest_cache/.*", -- Ignore everything under .pytest_cache
--       ".venv/.*", -- Ignore everything under .venv
--     },
--   },
-- })

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

-- require("which-key").setup(
--   -- which-key helps you remember key bindings by showing a popup
--   -- with the active keybindings of the command you started typing.
--   {
--     event = "VeryLazy",
--     opts_extend = { "spec" },
--     opts = {
--       defaults = {},
--       spec = {
--         {
--           mode = { "n", "v" },
--           { "<leader><tab>", group = "tabs" },
--           { "<leader>c", group = "code" },
--           { "<leader>f", group = "file/find" },
--           { "<leader>g", group = "git" },
--           { "<leader>gh", group = "hunks" },
--           { "<leader>q", group = "quit/session" },
--           { "<leader>s", group = "search" },
--           { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
--           { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
--           { "[", group = "prev" },
--           { "]", group = "next" },
--           { "g", group = "goto" },
--           { "gs", group = "surround" },
--           { "z", group = "fold" },
--           {
--             "<leader>b",
--             group = "buffer",
--             expand = function()
--               return require("which-key.extras").expand.buf()
--             end,
--           },
--           {
--             "<leader>w",
--             group = "windows",
--             proxy = "<c-w>",
--             expand = function()
--               return require("which-key.extras").expand.win()
--             end,
--           },
--           -- better descriptions
--           { "gx", desc = "Open with system app" },
--         },
--       },
--     },
--     keys = {
--       {
--         "<leader>?",
--         function()
--           require("which-key").show({ global = false })
--         end,
--         desc = "Buffer Keymaps (which-key)",
--       },
--       -- {
--       --   "<c-w><space>",
--       --   function()
--       --     require("which-key").show({ keys = "<c-w>", loop = true })
--       --   end,
--       --   desc = "Window Hydra Mode (which-key)",
--       -- },
--     },
--     config = function(_, opts)
--       local wk = require("which-key")
--       wk.setup(opts)
--       if not vim.tbl_isempty(opts.defaults) then
--         LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
--         wk.register(opts.defaults)
--       end
--     end,
--   }
-- )

--require("plugins.molten").init()
