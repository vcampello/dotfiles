-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.opt` and `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Open vertical diffs by default
vim.opt.diffopt:append("vertical")

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.winborder = "rounded"

-- Saner tab/softtab defaults. 8 is too much
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.opt.formatoptions:remove({ "t" }) -- prevent breaking string literals into multiple lines when textwidth is set

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Blinking cursor
vim.o.guicursor = "n-v-c-i-sm:block-blinkwait7000-blinkon400-blinkoff250,i-ci-ve:ver25,r-cr-o:hor20"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- File
vim.opt.swapfile = false
vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file

-- Writing
vim.opt.spell = true

-- enable jumping to files in terminal output using gf
-- may cause performance issues with :find
vim.opt.path:append("**")

-- enable exrc: disabled for now as it's not being used
vim.opt.exrc = true
vim.opt.secure = true

-- unique shada per directory (aka unique jumps, registers, etc)
local workspace_path = vim.fn.getcwd()
local cache_dir = vim.fn.stdpath("data")
local unique_id = vim.fn.fnamemodify(workspace_path, ":t") .. "_" .. vim.fn.sha256(workspace_path):sub(1, 8) ---@type string
vim.opt.shadafile = cache_dir .. "/myshada/" .. unique_id .. ".shada"

vim.lsp.set_log_level("DEBUG")
-- vim.lsp.log.set_format_func(vim.inspect)

-- diagnostics - this may be overridden elsewhere
vim.diagnostic.config({
  -- skip hints and go to the important stuff instead
  jump = { severity = { min = vim.diagnostic.severity.INFO } },
  virtual_lines = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.WARN },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

-- Allow jumping back and forth between hints as they are disabled by the diagnostic filter
vim.keymap.set({ "n" }, "[h", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.HINT, wrap = true })
end, { desc = "Previous hint diagnostic" })

vim.keymap.set({ "n" }, "]h", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.HINT, wrap = true })
end, { desc = "Next hint diagnostic" })
