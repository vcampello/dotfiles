vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor (remap)" })

-- Keep cursor centered when moving or searching
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Delete into the void and paste without losing buffer" })

-- This is supposed to copy into the system clipboard but it doesn't seem to work
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Not currently using tmux
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set(
    { "n" },
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Copy current word into replace" }
)

-- Buffer navigaction
-- gb/gB complement gt/gT however it conflicts with Comments
vim.keymap.set("n", "<leader>b", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "<leader>B", vim.cmd.bprevious, { desc = "Previous buffer" })
-- Window navigation
vim.keymap.set("n", "<C-H>", "<C-w>h", { desc = "Focus on left window" })
vim.keymap.set("n", "<C-J>", "<C-w>j", { desc = "Focus on below window" })
vim.keymap.set("n", "<C-K>", "<C-w>k", { desc = "Focus on above window" })
vim.keymap.set("n", "<C-L>", "<C-w>l", { desc = "Focus on right window" })

-- Misc
vim.keymap.set({ "n" }, "<ESC>", ":nohlsearch<CR>", {
    desc = "Clear search highlight on escape",
    silent = true,
})
