local bufdelete = require("bufdelete")
vim.keymap.set({ "n" }, "<C-c>", function()
    -- Wipeout current buffer
    bufdelete.bufwipeout()
end, {
    desc = "Wipeout current buffer",
})
