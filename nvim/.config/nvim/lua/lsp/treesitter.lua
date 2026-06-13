return {
    "rborist-ts/arborist.nvim",
    dependencies = {
        -- context window for long files
        {
            "nvim-treesitter/nvim-treesitter-context",
            dependencies = { "rborist-ts/arborist.nvim" },
            config = function()
                require("treesitter-context").setup({
                    multiwindow = true,
                    separator = "─",
                    multiline_threshold = 2,
                })

                vim.keymap.set("n", "<leader>;", function()
                    require("treesitter-context").go_to_context(vim.v.count1)
                end, { silent = true, desc = "Jump to parent context" })
            end,
        },

        -- nested LSPs
        {
            "jmbuhr/otter.nvim",
            dependencies = { "rborist-ts/arborist.nvim" },
            opts = {},
        },

        -- pretty render markdown
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = {
                "arborist-ts/arborist.nvim",
                "nvim-tree/nvim-web-devicons",
            },
            ---@module 'render-markdown'
            ---@type render.md.UserConfig
            opts = {},
        },
    },
    config = function()
        require("arborist").setup({
            update_cadence = "weekly",
        })

        -- enable otter for toml files (more specifically mise configs)
        local aucmd_group = vim.api.nvim_create_augroup("my.otter-setup", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = aucmd_group,
            pattern = "toml",
            callback = function()
                require("otter").activate()
            end,
        })
    end,
}
