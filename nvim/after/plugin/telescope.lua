require("telescope").setup()
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.reloader, { desc = "Plugin reloader" })
-- <leader>ca is used for code actions
vim.keymap.set("n", "<leader>cc", builtin.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>ch", builtin.command_history, { desc = "Command history" })
