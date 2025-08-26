function is_recoring()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end -- not recording
  return "recording @" .. reg
end

return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      path = 1, -- Relative path
      extensions = { "neo-tree" },
      tabline = {
        lualine_a = {
          {
            "tabs",
            show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
            symbols = {
              modified = "[+]", -- Text to show when the file is modified.
            },

            fmt = function(name, context)
              -- Show + if buffer is modified in tab
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]
              local mod = vim.fn.getbufvar(bufnr, "&mod")

              return name .. (mod == 1 and " +" or "")
            end,
          },
        },
        lualine_z = {
          {
            function()
              return string.format("env = %s", (os.getenv("MISE_ENV") or ""))
            end,
            cond = function()
              return #(os.getenv("MISE_ENV") or "") > 0
            end,
            color = { fg = "black", bg = "#ffbf00" },
          },
        },
      },
      sections = {
        lualine_b = { is_recoring },
        lualine_c = {
          {
            "filename",
            file_status = true, -- Displays file status (readonly status, modified status)
            path = 1, -- 1: Relative path
          },
        },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
          "lsp_status",
        },
        lualine_z = {
          "location",
          "selectioncount",
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
