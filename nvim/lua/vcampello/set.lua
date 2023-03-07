-- Settings based on personal preference + mini.nvim
-- Leader
vim.g.mapleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

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
-- vim.opt.isfname:append("@-@") -- What does this do?

-- Show invisible characters
vim.opt.listchars = "eol:⏎,tab:▶ ,trail:·,leadmultispace:·"
vim.opt.list = false

-- Looks
vim.opt.termguicolors = true

-- Misc
vim.opt.swapfile = false
vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file
vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"
vim.opt.autoread = true
vim.opt.mouse = "a" -- Enable mouse for all available modes

-- Appearance
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.cursorline = true -- Highlight current line
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)

vim.opt.ruler = false -- Don't show cursor position in command line
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.wrap = false -- Display long lines as just one line

-- Editing
vim.opt.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.hlsearch = true
vim.opt.incsearch = true -- Show search results while typing
vim.opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent = true -- Make indenting smart
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then
    vim.cmd("syntax enable")
end
