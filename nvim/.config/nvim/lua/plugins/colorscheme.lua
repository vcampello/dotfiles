local M = {}
function M.rosepine()
  return {
    "rose-pine/neovim",
    as = "rose-pine",
    lazy = false,
    priority = 1000,
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

function M.kanagawa()
  return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
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
            NeotreeTitleBar = { bg = colors.theme.ui.bg_p1 },
            WinSeparator = { fg = colors.theme.ui.fg },
            Error = { fg = "#962D1B" },
            DiagnosticError = { fg = "#962D1B" },
            ErrorMessage = { fg = "#962D1B" },
            NvimInternalError = { bg = "#962D1B", fg = "none" },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  }
end

function M.shadow()
  return {
    "rjshkhr/shadow.nvim",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("shadow")
    end,
  }
end

function M.oldworld()
  return {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("oldworld").setup({
        highlight_overrides = {
          Normal = { bg = "none" },
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
        },
        integrations = {
          neo_tree = true,
        },
      })
      vim.cmd.colorscheme("oldworld")
    end,
  }
end

return M.oldworld()
