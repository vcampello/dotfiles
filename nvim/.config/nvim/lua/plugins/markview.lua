return {
  enabled = true,
  lazy = false,
  priority = 49, -- load after tree-sitter
  "OXY2DEV/markview.nvim",
  config = function()
    require("markview").setup({
      preview = {
        icon_provider = "devicons", -- "mini" or "devicons"
      },
    })
  end,
}
