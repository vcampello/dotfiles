return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
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
