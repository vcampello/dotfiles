return {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = {
        {
            "f-person/git-blame.nvim",
            opts = {
                display_virtual_text = false, -- we'll use lualine instead
                message_template = "<date> • <author> • <summary>",
                date_format = "%Y-%m-%d at %H:%M:%S",
                max_commit_summary_length = 100,
                set_extmark_options = {
                    hl_mode = "combine",
                },
            },
        },
    },
    config = function()
        local git_blame = require("gitblame")

        require("lualine").setup({
            extensions = { "neo-tree" },
            winbar = {},
            tabline = {
                lualine_a = {
                    { "tabs", show_modified_status = true },
                },
                lualine_x = {
                    { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
                },
                lualine_y = { "diagnostics", "diff" },
                lualine_z = { "branch" },
            },
            sections = {
                lualine_b = {
                    function()
                        ---@type string
                        local reg = vim.fn.reg_recording()
                        return reg ~= "" and "recording @" or ""
                    end,
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- Displays file status (readonly status, modified status)
                        path = 1, -- 1: Relative path
                    },
                },
                lualine_y = { "lsp_status" },
                lualine_z = {
                    "location",
                    {
                        -- better selection count for lines and chars
                        -- original: https://github.com/nvim-lualine/lualine.nvim/blob/b8c23159c0161f4b89196f74ee3a6d02cdc3a955/lua/lualine/components/selectioncount.lua#L1-L16
                        function()
                            local mode = vim.fn.mode(true)
                            local line_start, col_start = vim.fn.line("v"), vim.fn.col("v")
                            local line_end, col_end = vim.fn.line("."), vim.fn.col(".")

                            -- box (no need for a character count in this case)
                            if mode:match("") then
                                return string.format(
                                    "%dx%d",
                                    math.abs(line_start - line_end) + 1,
                                    math.abs(col_start - col_end) + 1
                                )
                            -- multi line
                            elseif mode:match("[vV]") or line_start ~= line_end then
                                local lines = math.abs(line_start - line_end) + 1
                                local chars = vim.fn.wordcount().visual_chars
                                return string.format("󰉻   %d 󰬴  %d", lines, chars)
                            else
                                return ""
                            end
                        end,
                    },
                    "searchcount",
                },
            },
            inactive_sections = {
                lualine_a = {
                    {
                        function()
                            return "INACTIVE"
                        end,
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true, -- Displays file status (readonly status, modified status)
                        path = 1, -- 1: Relative path
                    },
                },
            },
        })
    end,
}
