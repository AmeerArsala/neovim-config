-- Function to execute a shell command and return its output
function execute_command(command)
  local handle = io.popen(command, "r")
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
function get_python_path()
  return execute_command("which python | tr -d '\n'")
  -- local active_micromamba_env_name = get_active_micromamba_env()
  --
  -- if active_micromamba_env_name == nil then
  --   -- It's not a micromamba environment
  --   return execute_command("which python | tr -d '\n'")
  -- end
  -- -- Otherwise, it is a micromamba environment
  -- local mamba_root_prefix = os.getenv("MAMBA_ROOT_PREFIX")
  -- local active_env_path = mamba_root_prefix .. "/envs/" .. active_micromamba_env_name .. "/bin/python"
  -- --vim.notify(active_env_path)
  --
  -- --local equality = fetched_python_path == active_env_path
  -- --print("Paths are equal: " .. tostring(equality))
  --
  -- return active_env_path
end

-- Get the path to the active python environment
local python_path = get_python_path()
vim.notify("Python Path: " .. python_path)

vim.g.python3_host_prog = vim.fn.expand(python_path)

return {
  -- Add `pyright` to mason
  -- TODO: check following tools -> mypy types-requests types-docutils
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "mypy", "ruff", "pyright", "black" },
    },
  },

  -- Setup adapters as nvim-dap dependencies
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class" },
      },
      config = function()
        --local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(python_path)
      end,
    },
  },

  -- Add `python` debugger to mason DAP to auto-install
  -- Not absolutely necessary to declare adapter in `ensure_installed`, since `mason-nvim-dap`
  -- has `automatic-install = true` in LazyVim by default and it automatically installs adapters
  -- that are are set up (via dap) but not yet installed. Might as well skip the lines below as
  -- a whole.

  -- Add which-key namespace for Python debugging
  {
    "folke/which-key.nvim",
    optional = true,
    spec = {
      defaults = {
        { "<leader>dP", group = "Python" },
      },
    },
  },

  -- Setup `neotest`
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          runner = "pytest",
          python = python_path,
        },
      },
    },
  },

  -- Add `server` and setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Using Ruff's import organizer
            },
            python = {
              analysis = {
                ignore = { "*" }, -- Using Ruff; ignore all files for analysis (pyright, you suck!!!)
                --typeCheckingMode = "off", -- Using mypy
                --useLibraryCodeForTypes = true,
              },
              pythonPath = python_path,
            },
          },
        },
        -- pylsp = {
        --   mason = false,
        --   settings = {
        --     pylsp = {
        --       plugins = {
        --         rope_autoimport = {
        --           enabled = true,
        --         },
        --       },
        --     },
        --   },
        -- },
        ruff_lsp = {
          -- handlers = {
          --   ["textDocument/publishDiagnostics"] = function() end,
          -- },
          init_options = {
            --args = {}, -- Any extra CLI arguments for `ruff` go here.
            logLevel = "error",
            interpreter = { python_path }, -- just an array
            organizeImports = true,
            -- lint = {
            --   run = "onType"  -- onType vs onSave
            -- }
          },
        },
        -- jedi_language_server = {},
      },
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
        pyright = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "pyright" then
              -- disable hover in favor of jedi-language-server
              -- client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },

  -- Setup up format with new `conform.nvim`
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { { "black", "ruff" } },
      },
    },
  },

  -- Setup null-ls with `black`
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.sources = vim.list_extend(opts.sources, {
  --       -- Order of formatters matters. They are used in order of appearance.
  --       nls.builtins.formatting.ruff,
  --       nls.builtins.formatting.black,
  --       -- nls.builtins.formatting.black.with({
  --       --   extra_args = { "--preview" },
  --       -- }),
  --       -- nls.builtins.diagnostics.ruff,
  --     })
  --   end,
  -- },

  -- For selecting virtual envs
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    cmd = "VenvSelect",
    opts = {
      dap_enabled = true,
    },
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },
}
