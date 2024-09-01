return {
  "dgox16/oldworld.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("oldworld").setup({
      integrations = {
        neo_tree = true,
        navic = true,
      },
    })
    vim.cmd.colorscheme("oldworld")
  end,
}
