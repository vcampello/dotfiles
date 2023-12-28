return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  config = function()
    local theme = require("lualine.themes.auto")
    theme.inactive.a.bg = "#222222"
    theme.inactive.c.bg = "#222222"

    require("lualine").setup({
      options = {
        theme = theme,
      },
      path = 1, -- Relative path
      extensions = { "neo-tree" },
      tabline = {
        lualine_a = { "tabs" },
        lualine_z = {
          -- TODO: how do I export this from the possession.lua file?
          function()
            local session = require("possession.session")
            if session ~= nil and string.len(session.session_name or "") > 0 then
              return "@" .. session.session_name
            else
              return ""
            end
          end,
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
