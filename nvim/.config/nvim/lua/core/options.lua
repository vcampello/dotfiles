-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set highlight on search
vim.b.hlsearch = true
vim.b.incsearch = true
vim.opt.inccommand = "split"

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching
vim.o.ignorecase = true
-- vim.o.smartcase = true -- UNLESS \C or capital in search

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 100
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: make sure your terminal supports this
vim.o.termguicolors = true
vim.o.guicursor = "n-v-c-i-sm:block-blinkwait7000-blinkon400-blinkoff250,i-ci-ve:ver25,r-cr-o:hor20"
vim.o.cursorline = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- More natural buffer splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Show invisible characters
-- vim.opt.list = true
-- vim.opt.listchars = "eol:⏎,tab:▶ ,trail:·,leadmultispace:·"

-- Misc
vim.opt.swapfile = false
vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file
-- vim.opt.colorcolumn = "100"
vim.opt.autoread = true
vim.opt.showmode = false -- hide mode on status line since it's been replace by lualine
--REVIEW: what about 'unload'?
vim.o.jumpoptions = "stack"

-- enable jumping to files in terminal output using gf
-- may cause performance issues with :find
vim.opt.path:append("**")

-- Show invisible characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Editing
vim.opt.smartindent = true -- Make indenting smart
vim.cmd("filetype plugin indent on") -- Enable all filetype plugins
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.scrolloff = 12

-- Open vertical diffs by default
vim.opt.diffopt:append("vertical")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
})
