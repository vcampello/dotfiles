return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [U]ndoTree" })
        vim.opt.undodir = vim.fn.stdpath("state") .. "/undodir"
        vim.opt.undofile = true
    end,
}
