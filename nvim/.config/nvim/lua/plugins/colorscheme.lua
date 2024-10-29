local M = {}
function M.rosepine()
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
end

function M.nightfox()
  return {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
        groups = {
          all = {
            NormalFloat = { bg = "NONE" },
          },
        },
      })
      vim.cmd.colorscheme("carbonfox")
    end,
  }
end

function M.kanagawa()
  return {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          return {
            Normal = { bg = "none" },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  }
end

return M.kanagawa()
