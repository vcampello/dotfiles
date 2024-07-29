return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup({
      input = {
        -- enable vim motions on floating inputs like LSP rename
        insert_only = false,
        -- start in normal mode
        start_in_insert = false,
      },
    })
  end,
}
