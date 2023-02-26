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
    other_win_hl_color = "#e35e4f",
})

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

require("neo-tree").setup({
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    window = {
        position = "right",
        mappings = {
            ["S"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
        },
    },
    nesting_rules = {},
    filesystem = {
        filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
                "node_modules",
            },
            hide_by_pattern = { -- uses glob style patterns
                --"*.meta",
                --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
                --".gitignored",
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
    event_handlers = {
        {
            event = "file_opened",
            handler = function(_file_path)
                --auto close
                require("neo-tree").close_all()
            end,
        },
    },
})

-- Mappings
vim.keymap.set("n", "\\f", "<cmd>:Neotree filesystem toggle right<cr>")
vim.keymap.set("n", "\\b", "<cmd>:Neotree buffers toggle right<cr>")
vim.keymap.set("n", "\\g", "<cmd>:Neotree git_status toggle right<cr>")
-- Why doesn't "<cmd>:Neotree close<cr>" doesn't work as expected?
vim.keymap.set("n", "\\c", vim.cmd.NeoTreeClose, { desc = "Neotree close all" })
