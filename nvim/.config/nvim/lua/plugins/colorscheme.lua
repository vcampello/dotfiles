local M = {}

function M.monokai()
    return {
        "loctvl842/monokai-pro.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("monokai-pro").setup({
                transparent_background = true,

                override = function()
                    -- clear some background colours
                    return {
                        NormalFloat = { bg = "" },
                        Pmenu = { bg = "" },
                        PmenuBorder = { bg = "" },
                        BlinkCmpMenu = { bg = "" },
                        SpellBad = { fg = "" },
                        PmenuSel = { fg = "" },
                        ["@lsp.type.variable"] = { fg = "#ffbf00" },
                    }
                end,
            })
            vim.cmd.colorscheme("monokai-pro-ristretto")
        end,
    }
end

function M.kintsugi()
    return {
        "metalelf0/kintsugi-nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kintsugi").setup({
                variant = "flared", -- "dark" | "flared"
                transparent = true,
                bold_keywords = true,
            })
            vim.cmd.colorscheme("kintsugi-flared") -- or "kintsugi-flared"
        end,
    }
end

return M.kintsugi()
