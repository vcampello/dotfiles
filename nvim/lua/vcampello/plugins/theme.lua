return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("bamboo").setup({
      -- NOTE: to use the light theme, set `vim.o.background = 'light'`
      style = "vulgaris", -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
      transparent = true,
      highlights = {
        -- make comments blend nicely with background, similar to other color schemes
        ["@comment"] = { fg = "$grey" },
      },
    })
    require("bamboo").load()
  end,
}
