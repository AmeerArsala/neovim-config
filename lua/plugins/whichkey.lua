return {
  "folke/which-key.nvim",
  keys = function (_, opts)
    return {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      -- {
      --   "<c-w><space>",
      --   function()
      --     require("which-key").show({ keys = "<c-w>", loop = true })
      --   end,
      --   desc = "Window Hydra Mode (which-key)",
      -- },
    }
  end,
}
