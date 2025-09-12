return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("treesitter-context").setup({
      multiwindow = true,
      separator = "─",
      multiline_threshold = 2,
    })

    vim.keymap.set("n", "<c-;>", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { silent = true, desc = "Jump to parent context" })
  end,
}
