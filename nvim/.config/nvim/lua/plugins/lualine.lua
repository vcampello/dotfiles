return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  config = function()
    local theme = require("lualine.themes.auto")
    -- #ffbf00
    -- theme.inactive.a.bg = "#704040"
    -- theme.inactive.a.fg = theme.normal.c.fg
    -- theme.inactive.c.bg = "#29294f"
    -- theme.inactive.c.fg = theme.normal.c.fg
    -- theme.normal.c.bg = "#29294f"

    require("lualine").setup({
      options = {
        theme = theme,
      },
      path = 1, -- Relative path
      extensions = { "neo-tree" },
      tabline = {
        lualine_a = { "tabs" },
        lualine_b = {
          {
            function()
              local navic = require("nvim-navic")
              return navic.get_location()
            end,
            cond = function()
              local navic = require("nvim-navic")
              local loc = navic.get_location()
              return navic.is_available() and #loc > 0
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
