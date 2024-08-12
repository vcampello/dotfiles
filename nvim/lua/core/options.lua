local M = {}

function M.settings()
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- Set highlight on search
  vim.o.hlsearch = false
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
  vim.o.jumpoptions = "stack"

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

  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
  })
end

function M.define_signs()
  vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
end

function M.default_remaps()
  -- [[ Basic Keymaps ]]
  local map = vim.keymap.set

  -- Disable space action so it can act as the leader
  map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

  -- Keep cursor centered when moving or searching
  map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
  map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
  map("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
  map("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

  map("x", "<leader>p", [["_dP]], { desc = "Delete into the void and paste without losing buffer" })

  -- Window navigation (will get overridden by smart-splits)
  map("n", "<C-H>", "<C-w>h", { desc = "Focus on left window" })
  map("n", "<C-J>", "<C-w>j", { desc = "Focus on below window" })
  map("n", "<C-K>", "<C-w>k", { desc = "Focus on above window" })
  map("n", "<C-L>", "<C-w>l", { desc = "Focus on right window" })

  -- Remap for dealing with word wrap
  map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Better terminal navigation and start terminal in insert mode
  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = vim.api.nvim_create_augroup("InitTerminal", { clear = true }),
    callback = function()
      map("t", "<C-H>", "<C-\\><C-N><C-H>", { desc = "Escape term and focus on left window" })
      map("t", "<C-J>", "<C-\\><C-N><C-J>", { desc = "Escape term and focus on below window" })
      map("t", "<C-K>", "<C-\\><C-N><C-K>", { desc = "Escape term and focus on above window" })
      map("t", "<C-L>", "<C-\\><C-N><C-L>", { desc = "Escape term and focus on right window" })
      vim.cmd.startinsert()
    end,
  })
end

function M.setup()
  M.settings()
  M.define_signs()
  M.default_remaps()
end

M.setup()
