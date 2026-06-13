return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        -- TODO: figure out why I cannot setup nvim-lsp-file-operations
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                },
                follow_current_file = {
                    enabled = true,
                },
                -- This will use the OS level file watchers to detect changes
                -- instead of relying on nvim autocmd events.
                use_libuv_file_watcher = true,
            },
            event_handlers = {
                {
                    event = "neo_tree_popup_input_ready",
                    handler = function()
                        -- enter input popup with normal mode by default.
                        vim.cmd.stopinsert()
                    end,
                },
                {
                    event = "neo_tree_popup_input_ready",
                    ---@param args { bufnr: integer, winid: integer }
                    handler = function(args)
                        -- map <esc> to enter normal mode (by default closes prompt)
                        -- don't forget `opts.buffer` to specify the buffer of the popup.
                        vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
                    end,
                },
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.relativenumber = true
                    end,
                },
            },
        })

        -- Mappings
        vim.keymap.set("n", "<leader>o", "<cmd>:Neotree reveal float<cr>", { desc = "Neotree (float)" })
        vim.keymap.set("n", "<leader>O", "<cmd>:Neotree reveal right<cr>", { desc = "Neotree (right)" })
    end,
}
