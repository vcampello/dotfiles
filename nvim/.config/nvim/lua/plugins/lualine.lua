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
          {
            -- better selection count for lines and chars
            -- original: https://github.com/nvim-lualine/lualine.nvim/blob/b8c23159c0161f4b89196f74ee3a6d02cdc3a955/lua/lualine/components/selectioncount.lua#L1-L16
            function()
              local mode = vim.fn.mode(true)
              local line_start, col_start = vim.fn.line("v"), vim.fn.col("v")
              local line_end, col_end = vim.fn.line("."), vim.fn.col(".")

              -- box (no need for a character count in this case)
              if mode:match("") then
                return string.format("%dx%d", math.abs(line_start - line_end) + 1, math.abs(col_start - col_end) + 1)
              -- multi line
              elseif mode:match("[vV]") or line_start ~= line_end then
                local lines = math.abs(line_start - line_end) + 1
                local chars = vim.fn.wordcount().visual_chars
                return string.format("󰉻   %d 󰬴  %d", lines, chars)
              else
                return ""
              end
            end,
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
