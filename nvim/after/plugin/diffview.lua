vim.keymap.set("n", "<leader>gd", vim.cmd.DiffviewOpen, { noremap = true, silent = true, desc = "Open Git Diffview" })
vim.keymap.set("n", "<leader>gc", vim.cmd.DiffviewClose, { noremap = true, silent = true, desc = "Close Git Diffview" })
