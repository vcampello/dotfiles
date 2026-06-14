local ts_manager_uri = "romus204/tree-sitter-manager.nvim"

return {
    ts_manager_uri,
    config = function()
        require("tree-sitter-manager").setup({
            auto_install = true,
        })
    end,

    dependencies = {
        -- tree-sitter CLI must be installed system-wide
        -- context window for long files
        {
            "nvim-treesitter/nvim-treesitter-context",
            dependencies = { ts_manager_uri },
            opts = {
                multiwindow = true,
                separator = "─",
                multiline_threshold = 2,
            },
            keys = {
                vim.keymap.set("n", "<leader>;", function()
                    require("treesitter-context").go_to_context(vim.v.count1)
                end, { silent = true, desc = "Jump to parent context" }),
            },
        },

        -- nested LSPs
        {
            "jmbuhr/otter.nvim",
            dependencies = { ts_manager_uri },

            config = function()
                require("otter").setup({
                    verbose = {
                        no_code_found = true,
                    },
                })
                -- enable otter for toml files (more specifically mise configs)
                local aucmd_group = vim.api.nvim_create_augroup("my.otter-setup", { clear = true })
                vim.api.nvim_create_autocmd({ "FileType" }, {
                    pattern = { "toml" },
                    group = aucmd_group,
                    callback = function()
                        require("otter").activate()
                    end,
                })
            end,
        },

        -- pretty render markdown
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = {
                ts_manager_uri,
                "nvim-tree/nvim-web-devicons",
            },
            ---@module 'render-markdown'
            ---@type render.md.UserConfig
            opts = {},
        },
    },
}
