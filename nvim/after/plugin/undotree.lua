vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Use a different path on Windows
if vim.loop.os_uname().sysname == "Windows_NT"
then
    vim.opt.undodir = os.getenv("UserProfile") .. "/.nvim/undodir"

else
    vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
end

vim.opt.undofile = true
