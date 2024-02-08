--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
require("vcampello.core")

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

require("lazy").setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",

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
      -- eye candy
      "onsails/lspkind.nvim",

      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      "hrsh7th/cmp-nvim-lsp", -- adds LSP completion capabilities
      "FelipeLema/cmp-async-path", -- adds filesystem paths.
      "rafamadriz/friendly-snippets", -- adds a number of user-friendly snippets
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      {
        "f3fora/cmp-spell", -- adds spellcheck
        config = function()
          vim.opt.spell = true
          vim.opt.spelllang = { "en_gb" }
        end,
      },
      {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "json",
        config = function()
          require("cmp-npm").setup({})
        end,
      },
    },
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- local palette = require("nordic.colors")

      require("nordic").load({
        transparent_bg = true,
        bright_border = true,
        telescope = {
          -- Available styles: `classic`, `flat`.
          style = "classic",
        },
        override = {
          WhichKeyFloat = { bg = "None" },
          WhichKeyBorder = { link = "FloatBorder" },
          Visual = { bg = "#104060" },
          LineNr = { fg = "#5080a0" },
        },
      })
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    opts = {
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
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
  -- require("kickstart.plugins.autoformat"),
  -- require 'kickstart.plugins.debug',

  -- NOTE: automatically add plugins, configuration, etc from `lua/plugins/*.lua`
  { import = "vcampello.plugins" },
}, {})

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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

-- TODO: review this. It probably shouldn't live here
-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
-- Enable telescope undo, if installed
pcall(require("telescope").load_extension, "fzf")
--
-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "Find existing buffers" })
vim.keymap.set(
  "n",
  "<leader>/",
  require("telescope.builtin").current_buffer_fuzzy_find,
  { desc = "Fuzzily search in current buffer" }
)

vim.keymap.set("n", "<leader>fa", function()
  -- Show hidden files
  -- https://github.com/skbolton/titan/blob/4d0d31cc6439a7565523b1018bec54e3e8bc502c/nvim/nvim/lua/mappings/filesystem.lua#L6
  require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
end, { desc = "Search All Files" })

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").git_files, { desc = "Search Git Files" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "Search Diagnostics" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Search Files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Search by Grep" })
vim.keymap.set("n", "<leader>fG", live_grep_git_root, { desc = "Search by Grep on Git Root" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Search Help" })
vim.keymap.set("n", "<leader>fm", require("telescope.builtin").marks, { desc = "Search Marks" })
vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Search Keymaps" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume, { desc = "Search Rresume" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "Search current Word" })
vim.keymap.set("n", "<leader>fu", ":Telescope undo<cr>", { desc = "Search undo" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "lua",
    "python",
    "rust",
    "tsx",
    "javascript",
    "typescript",
    "vimdoc",
    "vim",
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,
  sync_install = false,

  ignore_install = {},
  modules = {},
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
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")

  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
  nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "Workspace List Folders")

  local function format()
    require("conform").format({ async = true, lsp_fallback = true })
  end

  vim.api.nvim_buf_create_user_command(bufnr, "Format", format, { desc = "Format current buffer with LSP" })

  nmap("<leader>lf", format, "Format current buffer with LSP")
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
-- FIXME: setup mason tool installer
local servers = {
  clangd = {},
  pyright = {},
  rust_analyzer = {},
  gopls = {},
  tsserver = {},
  eslint = {},
  graphql = {},
  html = {},

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
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
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
  automatic_installation = true,
})

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
      handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      },
    })
  end,
})

-- FIXME: this is a mess
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
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({

    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
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
    -- { name = "copilot", group_index = 2 },
    { name = "async_path" },
    { name = "npm", keyword_length = 4 },
    {
      name = "spell",
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return require("cmp.config.context").in_treesitter_capture("spell")
        end,
      },
    },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({
        mode = "symbol_text",
        maxwidth = 100,
      })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"

      return kind
    end,
  },
})
-- `/` cmdline setup.
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})
-- `:` cmdline setup.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    {
      name = "cmdline",
      option = {
        ignore_cmds = { "Man", "!" },
      },
    },
  }),
})

vim.keymap.set("n", "<leader>ll", vim.cmd.Lazy, { noremap = true, silent = true, desc = "Lazy" })
vim.keymap.set("n", "<leader>lm", vim.cmd.Mason, { noremap = true, silent = true, desc = "Mason" })
vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, { noremap = true, silent = true, desc = "LSP Info" })
vim.keymap.set("n", "<leader>lr", vim.cmd.LspRestart, { noremap = true, silent = true, desc = "Restart LSP" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
