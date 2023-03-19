function ResetTheme()
    color = color or "ayu"
    vim.cmd.colorscheme(color)

    -- Transparent background
    vim.api.nvim_set_hl(0, "Normal", {})
    vim.api.nvim_set_hl(0, "NormalFloat", {})
    vim.api.nvim_set_hl(0, "EndOfBuffer", {})

    -- Whitespace/eol foreground
    vim.api.nvim_set_hl(0, "NonText", { fg = "#555555" })
    vim.api.nvim_set_hl(0, "Whitespace", { fg = "#555555" })
end

vim.cmd.colorscheme("tokyonight-night")

-- ResetTheme()

-- require("catppuccin").setup({
--     flavour = "macchiato", -- latte, frappe, macchiato, mocha
--     background = { -- :h background
--         light = "latte",
--         dark = "mocha",
--     },
--     transparent_background = true,
--     show_end_of_buffer = false, -- show the '~' characters after the end of buffers
--     term_colors = false,
--     dim_inactive = {
--         enabled = false,
--         shade = "dark",
--         percentage = 0.15,
--     },
--     no_italic = false, -- Force no italic
--     no_bold = false, -- Force no bold
--     styles = {
--         comments = { "italic" },
--         conditionals = { "italic" },
--         loops = {},
--         functions = {},
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = {},
--         properties = {},
--         types = {},
--         operators = {},
--     },
--     color_overrides = {},
--     custom_highlights = {},
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         telescope = true,
--         notify = false,
--         mini = true,
--         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
--     },
-- })
--
-- -- setup must be called before loading
-- vim.cmd.colorscheme("catppuccin")
