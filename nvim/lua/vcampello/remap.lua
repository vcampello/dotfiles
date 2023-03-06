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

-- TODO: figure out what exactly is the point of these. It's <something> centralise
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set(
    { "n" },
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Copy current word into replace" }
)

-- Better buffer navigaction
-- gb/gB complement gt/gT
vim.keymap.set("n", "gb", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "gB", vim.cmd.bprevious, { desc = "Previous buffer" })
vim.keymap.set({ "n", "i" }, "<C-h>", "<C-w>h", { desc = "Move to buffer on the left" })
vim.keymap.set({ "n", "i" }, "<C-j>", "<C-w>j", { desc = "Move to buffer on the bottom" })
vim.keymap.set({ "n", "i" }, "<C-k>", "<C-w>k", { desc = "Move to buffer on the top" })
vim.keymap.set({ "n", "i" }, "<C-l>", "<C-w>l", { desc = "Move to buffer on the right" })

-- Misc
vim.keymap.set({ "n" }, "<ESC>", ":nohlsearch<CR>", {
    desc = "Clear search highlight on escape",
    silent = true,
})
