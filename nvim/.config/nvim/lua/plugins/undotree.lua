return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
    vim.opt.undodir = vim.fn.stdpath("state") .. "/undodir"
    vim.opt.undofile = true
  end,
}
