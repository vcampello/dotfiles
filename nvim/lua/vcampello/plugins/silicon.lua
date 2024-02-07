return {
  "krivahtoo/silicon.nvim",
  -- the main branch follows the nightly channel
  branch = "nvim-0.9",
  build = "./install.sh build",
  config = function()
    require("silicon").setup({
      line_number = true,
      round_corner = false,
      pad_horiz = 0,
      pad_vert = 0,
      theme = "Monokai Extended",
      window_title = function()
        return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.")
      end,
    })
  end,
}
