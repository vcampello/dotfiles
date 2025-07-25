-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keep cursor centered when moving or searching
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Delete into the void and paste without losing buffer" })

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

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true, wrap = true })
  vim.cmd.normal("zz") -- centralise after jumping
end, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true, wrap = true })
  vim.cmd.normal("zz") -- centralise after jumping
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("x", "g/", "<Esc>/\\%V", { desc = "Search visual selection" })
