require('onedark').setup({
    transparent = true,
    style = 'dark',
    code_styles = {
        comments = "italic",
        keywords = "bold",
        functions = "bold",
        types = "italic,bold",
    }
})

function ResetTheme()
    color = color or "onedark"
    vim.cmd.colorscheme(color)

    -- Transparent background
    vim.api.nvim_set_hl(0, "Normal", {})
    vim.api.nvim_set_hl(0, "NormalFloat", {})
    vim.api.nvim_set_hl(0, "EndOfBuffer", {})

    -- Whitespace/eol foreground
    vim.api.nvim_set_hl(0, "NonText", { fg = '#555555' })
    vim.api.nvim_set_hl(0, "Whitespace", { fg = '#555555' })
end

ResetTheme()
