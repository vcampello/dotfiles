-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Enable telescope extension
      require("telescope").load_extension("lazygit")
      vim.keymap.set("n", "<leader>gg", require("lazygit").lazygit, { desc = "Lazygit" })
      vim.keymap.set("n", "<leader>gf", ":Telescope lazygit<cr>", { desc = "Lazygit repos" })
    end,
  },
}
