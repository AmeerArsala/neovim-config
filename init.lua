-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- require("nvim-treesitter.configs").setup({
--   ensure_installed = "all", -- or a list of languages you want to install
--   highlight = {
--     enable = true, -- Enable syntax highlighting
--   },
--   indent = {
--     enable = true, -- Enable indentation
--   },
-- Add other modules you want to enable
-- modules = {
--   -- You can enable or disable specific modules here
--   -- For example, to enable the highlight and indent modules:
--   highlight = {
--     enable = true,
--   },
--   indent = {
--     enable = true,
--   },
-- },
-- sync_install = true, -- Enable synchronous installation of parsers
-- ignore_install = {}, -- List of languages to ignore during installation
-- auto_install = true, -- Automatically install parsers
-- })

require("nvim-treesitter.configs").setup({
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true, -- Enable syntax highlighting
  },
  indent = {
    enable = true,
    disable = { "python", "css", "rust" },
  },
  --ensure_installed = "all",
  ensure_installed = {
    "java",
    "cpp",
    "rust",
    "python",
    "lua",
    "html",
    "json",
    "dockerfile",
    "yaml",
    "css",
    "javascript",
    "typescript",
    "svelte",
    "julia",
    "c",
    "vue",
    "glsl",
    "hlsl",
    "c_sharp",
    "astro",
    "vim",
    "zig",
    "toml",
    "sql",
    "ruby",
    --"pip-requirements",
    "php",
    "r",
    "prisma",
    "graphql",
    "go",
    "nim",
    "latex",
    "haskell",
    "gitignore",
    "gdscript",
    "gdshader",
    "elixir",
    "d",
    "dart",
    "csv",
    "cuda",
    "asm",
    "bash",
    "bibtex",
    "arduino",
  },
})

-- Function to execute a shell command and return its output
function execute_command(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

-- Function to parse the output of `micromamba env list` and find the active environment
function get_active_micromamba_env()
  local output = execute_command("$MAMBA_EXE env list")
  --vim.notify("envs: " .. output)
  for line in output:gmatch("[^\r\n]+") do
    if line:find("*") then
      local env_name = line:match("^%s*(%S+)")
      return env_name
    end
  end
  return nil
end

-- Function to get the path to the active micromamba environment
local function get_python_path()
  local active_micromamba_env_name = get_active_micromamba_env()
  if active_micromamba_env_name == nil then
    return "/usr/bin/python3"
  end
  -- Otherwise, it is a micromamba environment
  local mamba_root_prefix = os.getenv("MAMBA_ROOT_PREFIX")
  local active_env_path = mamba_root_prefix .. "/envs/" .. active_micromamba_env_name .. "/bin/python"
  return active_env_path
end

-- Get the path to the active python environment
local python_path = get_python_path()
vim.notify("Python Path: " .. python_path)

local lspconfig = require("lspconfig")

-- Disable hover in ruff-lsp in favor of pyright
local on_attach = function(client, bufnr)
  if client.name == "ruff_lsp" then
    client.server_capabilities.hoverProvider = false
  end
end

-- Configure ruff-lsp
lspconfig.ruff_lsp.setup({
  on_attach = on_attach,
  init_options = {
    settings = {
      args = {}, -- Any extra CLI arguments for `ruff` go here.
      logLevel = "info",
      interpreter = python_path,
      --interpreter=[python_path]
    },
  },
})

-- Configure pyright to ignore all files for analysis to exclusively use Ruff for linting
lspconfig.pyright.setup({
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff's import organizer
    },
    python = {
      analysis = {
        ignore = { "*" }, -- Ignore all files for analysis (pyright, you suck!!!)
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
      },
      pythonPath = python_path,
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
