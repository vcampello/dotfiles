return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  config = function()
    local theme = require("lualine.themes.auto")
    theme.inactive.a.bg = "#202030"
    theme.inactive.a.fg = "#666666"
    theme.inactive.c.bg = "#202030"
    theme.inactive.c.fg = "#666666"

    require("lualine").setup({
      options = {
        theme = theme,
      },
      path = 1, -- Relative path
      extensions = { "neo-tree" },
      tabline = {
        lualine_a = { "tabs" },
        lualine_z = {
          {
            -- TODO: how do I export this from the possession.lua file?
            function()
              local session = require("possession.session")
              return "@" .. session.session_name
            end,
            conf = function()
              local session = require("possession.session")
              return session ~= nil and string.len(session.session_name or "") > 0
            end,
          },
        },
        lualine_b = {
          {
            function()
              local navic = require("nvim-navic")
              return navic.get_location()
            end,
            cond = function()
              local navic = require("nvim-navic")
              local loc = navic.get_location()
              return navic.is_available() and string.len(loc) > 0
            end,
          },
        },
      },

      sections = {
        lualine_c = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            path = 1, -- 1: Relative path
          },
        },
      },
      inactive_sections = {
        lualine_a = {
          {
            function()
              return "INACTIVE"
            end,
          },
        },
        lualine_c = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            path = 1, -- 1: Relative path
          },
        },
      },
    })
  end,
}
