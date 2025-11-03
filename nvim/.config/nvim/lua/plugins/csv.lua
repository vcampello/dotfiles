return {
  ft = "csv",
  "hat0uma/csvview.nvim",
  config = function()
    require("csvview").setup({
      view = {
        spacing = 4,
        display_mode = "border",
      },
      keymaps = {
        -- Horizontal navigation
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },

        -- Vertical navigation
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },

        -- Select field content
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
      },
    })

    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("AutoEnableCsvView", { clear = true }),
      pattern = "*.csv",
      callback = function()
        vim.cmd.CsvViewEnable()
        vim.o.wrap = false
      end,
    })
  end,
}
