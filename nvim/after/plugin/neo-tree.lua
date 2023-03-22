require("window-picker").setup({
    autoselect_one = false,
    include_current = false,
    filter_rules = {
        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
        },
    },
    other_win_hl_color = "#e0af68",
    fg_color = "#333333",
})

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.g.neo_tree_remove_legacy_commands = 1

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
-- TODO: define this in a global config
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

require("neo-tree").setup({
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    window = {
        position = "right",
        mappings = {
            ["S"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
        },
    },
    filesystem = {
        follow_current_file = true,
        filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
                "node_modules",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                ".DS_Store",
                "thumbs.db",
            },
            never_show_by_pattern = { -- uses glob style patterns
                --".null-ls_*",
            },
        },
    },
})

-- Mappings
vim.keymap.set("n", "\\f", "<cmd>:Neotree filesystem reveal right<cr>")
vim.keymap.set("n", "\\b", "<cmd>:Neotree buffers toggle right<cr>")
vim.keymap.set("n", "\\g", "<cmd>:Neotree git_status toggle right<cr>")
vim.keymap.set("n", "\\c", "<cmd>:Neotree close right<cr>")
