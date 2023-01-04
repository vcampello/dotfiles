function ResetTheme()
    color = color or "carbonfox"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", {})
    vim.api.nvim_set_hl(0, "NormalFloat", {})
    --vibrant yellow gutter
    --vim.api.nvim_set_hl(0, "LineNr", { fg = "#FDDB27", bg = "#0f151e" })
end
ResetTheme()
