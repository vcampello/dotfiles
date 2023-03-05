vim.g.mapleader = " "

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Layout
vim.opt.showtabline = 2 -- Always show tabline

-- More natural buffer splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Editor behiavour
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.list = true
vim.opt.listchars = "eol:⏎,tab:▶ ,trail:·,leadmultispace:·"
--vim.opt.listchars = ''

-- Tools
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- Misc
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"
vim.opt.autoread = true
