return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ---@module 'todo-comments.config'
  opts = {
    keywords = {
      CHECK = {
        icon = " ",
        color = "#27e2e8",
        alt = { "REVIEW" },
      },
    },
  },
}
