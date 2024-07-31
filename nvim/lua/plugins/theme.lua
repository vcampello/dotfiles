return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nightfox").setup({
      options = {
        transparent = true,
      },
      groups = {
        all = {
          NormalFloat = {
            bg = "NONE",
          },
          WinSeparator = {
            fg = "#523E64",
          },
        },
      },
    })
    vim.cmd("colorscheme nightfox")
  end,
}
