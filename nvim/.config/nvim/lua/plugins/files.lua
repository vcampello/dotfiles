return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    float = {
      max_width = 0.8,
      max_height = 0.8,
    },
    view_options = {
      show_hidden = true,
    },
  },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  vim.keymap.set({ "n" }, "<leader>o", "<cmd>Oil --float<cr>", {
    desc = "Open Oil",
  }),
}
