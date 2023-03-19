require("telescope").setup()
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
    -- Show hidden files
    -- https://github.com/skbolton/titan/blob/4d0d31cc6439a7565523b1018bec54e3e8bc502c/nvim/nvim/lua/mappings/filesystem.lua#L6
    builtin.find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fF", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find current buffer" })
vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
-- <leader>ca is used for code actions
vim.keymap.set("n", "<leader>cc", builtin.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>ch", builtin.command_history, { desc = "Command history" })

-- Less used mappings
vim.keymap.set("n", "<leader>ftc", builtin.colorscheme, { desc = "Colorscheme" })
vim.keymap.set("n", "<leader>ftf", builtin.filetypes, { desc = "Filetypes" })
vim.keymap.set("n", "<leader>ftr", builtin.reloader, { desc = "Plugin reloader" })
