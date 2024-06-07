return {
  lazy = false,
  priority = 999,
  "mrjones2014/smart-splits.nvim",
  config = function()
    local sp = require("smart-splits")

    -- Focus
    vim.keymap.set("n", "<C-h>", sp.move_cursor_left, { desc = "Focus on left window" })
    vim.keymap.set("n", "<C-j>", sp.move_cursor_down, { desc = "Focus on below window" })
    vim.keymap.set("n", "<C-k>", sp.move_cursor_up, { desc = "Focus on above window" })
    vim.keymap.set("n", "<C-l>", sp.move_cursor_right, { desc = "Focus on right window" })

    -- Resize
    vim.keymap.set("n", "<M-j>", sp.resize_down, { desc = "Resize below" })
    vim.keymap.set("n", "<M-k>", sp.resize_up, { desc = "Resize above" })
    vim.keymap.set("n", "<M-l>", sp.resize_right, { desc = "Resize right" })
  end,
}
