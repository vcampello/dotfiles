return {
  "rose-pine/neovim",
  as = "rose-pine",
  config = function()
    require("rose-pine").setup({
      styles = {
        transparency = true,
      },
    })
    vim.cmd.colorscheme("rose-pine")
    require("lualine").setup({
      options = {
        --- @usage 'rose-pine' | 'rose-pine-alt'
        theme = "rose-pine",
      },
    })
  end,
}
