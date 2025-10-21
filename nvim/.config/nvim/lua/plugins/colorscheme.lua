local M = {}

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

          --FIXME: make a PR to fix the broken highlights. It's caused by setting `transparent.bg = true`
          local C = palette
          local U = require("nordic.utils")
          local diff_blend = 0.2
          highlights.DiffChange.bg = U.blend(C.blue1, C.black1, 0.05) --C.diff.change1
          highlights.DiffText.bg = U.blend(C.blue2, C.black1, diff_blend) -- C.diff.change0
          highlights.DiffAdd.bg = U.blend(C.green.base, C.black1, diff_blend) -- C.diff.add
          highlights.DiffDelete.bg = U.blend(C.red.base, C.black1, diff_blend) -- C.diff.delete
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
