local M = {}

function M.settings()
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- Set highlight on search
  vim.o.hlsearch = false

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
  vim.wo.signcolumn = "yes"

  -- Decrease update time
  vim.o.updatetime = 100
  vim.o.timeoutlen = 300

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = "menuone,noselect"

  -- NOTE: You should make sure your terminal supports this
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

  -- Keep cursor centered when moving or searching
  vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
  vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
  vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

  vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Delete into the void and paste without losing buffer" })

  -- Window navigation (will get overridden by smart-splits)
  vim.keymap.set("n", "<C-H>", "<C-w>h", { desc = "Focus on left window" })
  vim.keymap.set("n", "<C-J>", "<C-w>j", { desc = "Focus on below window" })
  vim.keymap.set("n", "<C-K>", "<C-w>k", { desc = "Focus on above window" })
  vim.keymap.set("n", "<C-L>", "<C-w>l", { desc = "Focus on right window" })

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Better terminal escape
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-N>", { silent = true })
end

--TODO: move this somewhere else as it's technically a plugin
--Open a to-do list
function M.setup_todo_list()
  -- support for a float per tab
  local todo_map = {}

  local function todo_list()
    local todo_filepath = vim.fn.stdpath("data") .. "/my-todo.md"
    local buf = vim.fn.bufadd(todo_filepath)
    local tab_id = vim.api.nvim_get_current_tabpage()
    local win_id = vim.api.nvim_get_current_win()

    if todo_map[tab_id] ~= nil then
      print("A todo list is already open on this tab. Windows: " .. vim.inspect(todo_map, { newline = " " }))
      return
    end

    -- current window dimensions
    local win_width = vim.api.nvim_list_uis()[1].width
    local win_height = vim.api.nvim_list_uis()[1].height

    -- floating window dimensions
    local width = math.floor(win_width * 0.5)
    local height = math.floor(win_height * 0.7)

    -- anchor offset to centre it
    local col = math.floor((win_width / 2) - (width / 2))
    local row = math.floor((win_height / 2) - (height / 2))

    -- open floating window
    local todo_win_id = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = height,
      title = " To-do ",
      title_pos = "center",
      border = "rounded",
    })

    -- TODO: setup group
    vim.api.nvim_create_autocmd({ "WinClosed" }, {
      buffer = buf,
      once = false, -- the buffer is shared so each window needs the ability to run the callback
      callback = function()
        -- only remove from hashmap if closing the floating window from the same tab
        if tab_id == vim.api.nvim_get_current_tabpage() then
          -- print("Removing window from todo_map " .. os.date("%c"))
          todo_map[tab_id] = nil
        end
      end,
    })

    -- TODO: clean this up
    vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
      buffer = buf,
      once = false,
      callback = function()
        -- only remove from hashmap if closing the floating window from the same tab
        if tab_id == vim.api.nvim_get_current_tabpage() then
          -- print("Removing window from todo_map " .. os.date("%c"))
          todo_map[tab_id] = nil
        end

        -- also close the window if the buffer is changed - e.g. prevent jumping to another file
        vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
      end,
    })

    -- enter the window
    vim.api.nvim_set_current_win(todo_win_id)
    -- store window id to prevent opening it again
    todo_map[tab_id] = win_id
    -- print(vim.inspect(todo_map))
  end

  vim.keymap.set("n", "<leader>t", todo_list, { desc = "Open to-do list", silent = true })
end

function M.setup()
  M.settings()
  M.define_signs()
  M.default_remaps()
  M.setup_todo_list()
end

M.setup()
