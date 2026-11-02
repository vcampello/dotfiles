return {
    "smart-splits-nvim/smart-splits.nvim",
    version = "^3.0.0",
    -- install a backend
    dependencies = {
        {
            "smart-splits-nvim/backend-zellij-lua",
            main = "smart-splits-backend-zellij-lua",
        },
    },
    config = function()
        local sp = require("smart-splits")
        sp.setup({ mux = { backend = "smart-splits-backend-zellij-lua" } })

        -- Focus
        vim.keymap.set("n", "<C-h>", sp.move_cursor_left, { desc = "Focus on left window" })
        vim.keymap.set("n", "<C-j>", sp.move_cursor_down, { desc = "Focus on below window" })
        vim.keymap.set("n", "<C-k>", sp.move_cursor_up, { desc = "Focus on above window" })
        vim.keymap.set("n", "<C-l>", sp.move_cursor_right, { desc = "Focus on right window" })

        -- Resize
        vim.keymap.set("n", "<M-h>", sp.resize_left, { desc = "Resize left window" })
        vim.keymap.set("n", "<M-j>", sp.resize_down, { desc = "Resize below" })
        vim.keymap.set("n", "<M-k>", sp.resize_up, { desc = "Resize above" })
        vim.keymap.set("n", "<M-l>", sp.resize_right, { desc = "Resize right" })
    end,
}
