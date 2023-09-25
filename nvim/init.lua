-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Detect tabstop and shiftwidth automatically
  -- "tpope/vim-sleuth",

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim',       tag = 'legacy', opts = { window = { blend = 50 } } },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
      "b0o/schemastore.nvim",
      {
        "ckipp01/stylua-nvim",
        build = "cargo install stylua",
      },
    },
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          "n",
          "<leader>gp",
          require("gitsigns").preview_hunk,
          { buffer = bufnr, desc = "[G]it Hunk [P]review " }
        )

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ "n", "v" }, "]g", function()
          if vim.wo.diff then
            return "]g"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
        vim.keymap.set({ "n", "v" }, "[g", function()
          if vim.wo.diff then
            return "[g"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
      end,
    },
  },

  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
      })
      vim.cmd.colorscheme("carbonfox")
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#4e3773" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
      vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "None" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = "powerline",
        globalstatus = true,
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  require("kickstart.plugins.autoformat"),
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = "custom.plugins" },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

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

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 100
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

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
vim.opt.colorcolumn = "100"
vim.opt.autoread = true
vim.opt.showmode = false -- hide mode on status line since it's been replace by lualine

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

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd("syntax enable")
end

-- [[ Basic Keymaps ]]

-- Keep cursor centered when moving or searching
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centralised)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centralised)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match (centralised)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search match (centralised)" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Delete into the void and paste without losing buffer" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bt", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bT", vim.cmd.bprevious, { desc = "Previous buffer" })
-- Window navigation
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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- Start telescope by default unless opening a file
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == "" then
      require("telescope.builtin").find_files()
    end
  end,
})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>sa", function()
  -- Show hidden files
  -- https://github.com/skbolton/titan/blob/4d0d31cc6439a7565523b1018bec54e3e8bc502c/nvim/nvim/lua/mappings/filesystem.lua#L6
  require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
end, { desc = "[S]earch [A]ll Files" })

vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sm", require("telescope.builtin").marks, { desc = "[S]earch  [M]arks" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]resume" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "javascript", "typescript", "vimdoc", "vim" },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- TODO: figure out how to sue this
  -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- FIXME: find a better way to do this
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    -- Use stylua to format instead of lua_ls. Also set in autoformat.lua
    if client.name == "lua_ls" then
      require("stylua-nvim").format_file()
    elseif client.name == "eslint" then
      -- Use eslint to format instead of whatever it uses by default. Also set in autoformat.lua
      vim.cmd("EslintFixAll")
    else
      vim.lsp.buf.format()
    end
  end, { desc = "Format current buffer with LSP" })

  -- nmap("<leader>f", vim.lsp.buf.format, "Format current buffer with LSP")
  nmap("<leader>f", "<Cmd>Format<CR>", "Format current buffer with LSP")
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tsserver = {},
  eslint = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      format = {
        enable = false,
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

-- FIXME: this doesn't work all of the time ()
-- START: override borders
-- TODO: tidy this up
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}
vim.diagnostic.config({
  float = { border = "single" },
})

require("lspconfig.ui.windows").default_options = {
  border = "single",
}

-- END: override borders

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      handlers = handlers,
    })
  end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete {},
    ["<C-Space>"] = nil,
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

vim.keymap.set("n", "<leader>lm", vim.cmd.Mason, { noremap = true, silent = true, desc = "Mason" })
vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, { noremap = true, silent = true, desc = "LSP Info" })
vim.keymap.set("n", "<leader>lr", vim.cmd.LspRestart, { noremap = true, silent = true, desc = "Restart LSP" })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
