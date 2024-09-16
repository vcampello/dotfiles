return {
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      -- neo-tree must be loaded first
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
