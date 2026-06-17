local M = {}

function M.eldritch()
    return {
        "eldritch-theme/eldritch.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("eldritch").setup({
                transparent = true,
                on_highlights = function(hl, colors)
                    hl.CursorLineNr.bg = colors.bg_highlight
                end,
            })
            vim.cmd.colorscheme("eldritch-dark")
        end,
    }
end

return M.eldritch()
