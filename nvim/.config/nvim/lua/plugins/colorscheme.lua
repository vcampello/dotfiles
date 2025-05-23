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

function M.nordic()
  return {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load({
        -- configure with slightly better contrast
        on_highlight = function(highlights, palette)
          -- comments
          highlights.Comment.fg = palette.gray5

          -- line numbers
          highlights.LineNr.fg = palette.gray5
          highlights.CursorLineNr.fg = palette.fg_bright

          -- current line and visual selection
          highlights.CursorLine.bg = palette.gray1
          highlights.Visual.bg = palette.gray1
        end,
        transparent = {
          -- depends on terminal background to look nice
          bg = true,
          float = true,
        },
        bright_border = true,
      })
    end,
  }
end

return M.nordic()
