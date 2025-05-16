return {
  ft = "csv",
  "hat0uma/csvview.nvim",
  config = function()
    require("csvview").setup({
      view = {
        spacing = 4,
        display_mode = "border",
      },
    })

    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("AutoEnableCsvView", { clear = true }),
      pattern = "*.csv",
      callback = function(ev)
        vim.cmd.CsvViewEnable()
        vim.o.wrap = false
      end,
    })
  end,
}
