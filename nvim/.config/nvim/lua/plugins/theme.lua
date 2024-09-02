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
      highlight_overrides = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        CursorLine = { bg = "#222128" },
      },
    })
    vim.cmd.colorscheme("oldworld")
  end,
}
