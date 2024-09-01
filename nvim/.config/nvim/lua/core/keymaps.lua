-- [[ Basic Keymaps ]]
local map = vim.keymap.set

-- Disable space action so it can act as the leader
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Keep cursor centered when moving or searching
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
map("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
map("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

map("x", "<leader>p", [["_dP]], { desc = "Delete into the void and paste without losing buffer" })

-- Window navigation (will get overridden by smart-splits)
map("n", "<C-H>", "<C-w>h", { desc = "Focus on left window" })
map("n", "<C-J>", "<C-w>j", { desc = "Focus on below window" })
map("n", "<C-K>", "<C-w>k", { desc = "Focus on above window" })
map("n", "<C-L>", "<C-w>l", { desc = "Focus on right window" })

-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better terminal navigation and start terminal in insert mode
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("InitTerminal", { clear = true }),
  callback = function()
    map("t", "<C-H>", "<C-\\><C-N><C-H>", { desc = "Escape term and focus on left window" })
    map("t", "<C-J>", "<C-\\><C-N><C-J>", { desc = "Escape term and focus on below window" })
    map("t", "<C-K>", "<C-\\><C-N><C-K>", { desc = "Escape term and focus on above window" })
    map("t", "<C-L>", "<C-\\><C-N><C-L>", { desc = "Escape term and focus on right window" })
    vim.cmd.startinsert()
  end,
})

-- Diagnostic keymaps
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
