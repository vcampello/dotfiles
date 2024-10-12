local M = {}
---Setup a nicer signcolumn
---source: https://www.reddit.com/r/neovim/comments/1g14tkj/comment/lrhpvqy/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
function M.setup()
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    callback = function()
      -- local separator = " ▎ "
      local separator = "  "
      vim.opt.statuscolumn = '%s%=%#LineNr4#%{(v:relnum >= 4)?v:relnum."'
        .. separator
        .. '":""}'
        .. '%#LineNr3#%{(v:relnum == 3)?v:relnum."'
        .. separator
        .. '":""}'
        .. '%#LineNr2#%{(v:relnum == 2)?v:relnum."'
        .. separator
        .. '":""}'
        .. '%#LineNr1#%{(v:relnum == 1)?v:relnum."'
        .. separator
        .. '":""}'
        .. '%#LineNr0#%{(v:relnum == 0)?v:lnum." '
        .. separator
        .. '":""}'

      vim.cmd.highlight("LineNr0 guifg=#dedede")
      vim.cmd.highlight("LineNr1 guifg=#bdbdbd")
      vim.cmd.highlight("LineNr2 guifg=#9c9c9c")
      vim.cmd.highlight("LineNr3 guifg=#7b7b7b")
      vim.cmd.highlight("LineNr4 guifg=#5a5a5a")
    end,
  })
end

return M
