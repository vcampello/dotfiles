-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keep cursor centered when moving or searching
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

-- Window navigation (will get overridden by smart-splits)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Focus on left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Focus on below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Focus on above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Focus on right window" })

vim.keymap.set("v", ">", ">gv", { desc = "Increase indent" })
vim.keymap.set("v", "<", "<gv", { desc = "Decrease indent" })

-- Better terminal navigation and start terminal in insert mode
vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = vim.api.nvim_create_augroup("InitTerminal", { clear = true }),
    callback = function()
        vim.keymap.set("t", "<C-H>", "<C-\\><C-N><C-H>", { desc = "Escape term and focus on left window" })
        vim.keymap.set("t", "<C-J>", "<C-\\><C-N><C-J>", { desc = "Escape term and focus on below window" })
        vim.keymap.set("t", "<C-K>", "<C-\\><C-N><C-K>", { desc = "Escape term and focus on above window" })
        vim.keymap.set("t", "<C-L>", "<C-\\><C-N><C-L>", { desc = "Escape term and focus on right window" })
        vim.cmd.startinsert()
    end,
})

vim.keymap.set("x", "g/", "<Esc>/\\%V", { desc = "Search visual selection" })

-- copy to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to clipboard", noremap = true })
vim.keymap.set("n", "<leader>Y", '"+yg_', { desc = "Copy to end of line (without newline)", noremap = true })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to clipboard", noremap = true })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Copy line to clipboard", noremap = true })

-- paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from clipboard (after)", noremap = true })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from clipboard (before)", noremap = true })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from clipboard over selection (after)", noremap = true })
vim.keymap.set("v", "<leader>P", '"+P', { desc = "Paste from clipboard over selection (before)", noremap = true })
