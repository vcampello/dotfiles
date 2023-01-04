function ResetTheme()
    color = color or "carbonfox"
    vim.cmd.colorscheme(color)

    -- Transparent background
    vim.api.nvim_set_hl(0, "Normal", {})
    vim.api.nvim_set_hl(0, "NormalFloat", {})
    --
    -- Whitespace/eol foreground
    vim.api.nvim_set_hl(0, "NonText", { fg = '#555555' })
    vim.api.nvim_set_hl(0, "Whitespace", { fg = '#555555' })
end

ResetTheme()
