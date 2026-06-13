return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    -- load immediately
    lazy = false,
    config = function()
        local fzf = require("fzf-lua")

        fzf.register_ui_select()

        -- Keymaps
        local map = vim.keymap.set

        map("n", "<leader><leader>", fzf.global, { desc = "Global search", nowait = true })
        map("n", "<leader><leader><leader>", ":FzfLua<cr>", { desc = "FzfLua", nowait = true })
        map("v", "<leader>f", fzf.grep_visual, { desc = "Search selection" })
        map("n", "<leader>fr", fzf.resume, { desc = "Search resume" })
        map("n", "<leader>ff", fzf.files, { desc = "Search files" })
        map("n", "<leader>fm", fzf.marks, { desc = "Search marks" })
        map("n", "<leader>fj", fzf.jumps, { desc = "Search jumps" })
        map("n", "<leader>fo", fzf.git_status, { desc = "Search git status" })
        map("n", "<leader>fq", fzf.quickfix, { desc = "Search quickfix" })
        map("n", "<leader>fg", fzf.live_grep, { desc = "Search project" })
        map("n", "<leader>/", fzf.lsp_workspace_diagnostics, { desc = "Search diagnostics" })

        -- replace original suggestions keymap
        map("n", "z=", fzf.spell_suggest, { desc = "Search spell suggestions", nowait = true })
    end,
}
