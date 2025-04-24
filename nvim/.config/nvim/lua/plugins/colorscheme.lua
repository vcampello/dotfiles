local M = {}
function M.rosepine()
  return {
    "rose-pine/neovim",
    as = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        -- styles = {
        --   transparency = true,
        -- },
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
end

function M.nightfox()
  return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local palette = require("nightfox.palette").load("carbonfox")
      -- print(vim.inspect(palette))
      require("nightfox").setup({
        options = {
          transparent = true,
        },
        groups = {
          all = {
            -- NormalFloat = { bg = palette.bg1, fg = palette.fg1 },
            NeotreeTitleBar = { bg = palette.bg2 },
            WinSeparator = { fg = palette.fg1 },
          },
        },
      })
      vim.cmd.colorscheme("carbonfox")
    end,
  }
end

return M.rosepine()
