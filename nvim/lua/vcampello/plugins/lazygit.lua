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
      local lg = require("lazygit")
      vim.keymap.set("n", "<leader>gg", lg.lazygit, { desc = "Lazygit" })
      vim.keymap.set("n", "<leader>gc", lg.lazygitcurrentfile, { desc = "Lazygit - current file" })
    end,
  },
}
