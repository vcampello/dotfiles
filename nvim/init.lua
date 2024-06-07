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
      -- Tool installer for mason
      "WhoIsSethDaniel/mason-tool-installer.nvim",

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
    --extended TS server functionality
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
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
  -- Fuzzy Finder (files, lsp, etc)
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
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

local fzflua = require("fzf-lua")

vim.keymap.set("n", "<leader>fF", ":FzfLua<cr>", { desc = "FzfLua", nowait = true })
vim.keymap.set("v", "<leader>f", fzflua.grep_visual, { desc = "Search selection" })
vim.keymap.set("n", "<leader>fr", fzflua.resume, { desc = "Search resume" })
vim.keymap.set("n", "<leader>ff", fzflua.files, { desc = "Search files" })
vim.keymap.set("n", "<leader>/", fzflua.grep_curbuf, { desc = "Search current buffer" })
vim.keymap.set("n", "<leader>fg", fzflua.grep_project, { desc = "Search project" })
vim.keymap.set("n", "<leader>fh", fzflua.helptags, { desc = "Search help" })
vim.keymap.set("n", "<leader>fH", fzflua.manpages, { desc = "Search man pages" })
vim.keymap.set("n", "<leader>fm", fzflua.marks, { desc = "Search marks" })
-- keep it similar to code actions (la)
vim.keymap.set("n", "<leader>ls", fzflua.spell_suggest, { desc = "Search spell suggestions" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "rust",
    "templ",
    "terraform",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
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
  local imap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("i", keys, func, { buffer = bufnr, desc = desc })
  end

  -- NOTE: this makes text shift horizontally and it is distracting
  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint.enable(bufnr, true)
  -- end

  nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
  -- nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>la", fzflua.lsp_code_actions, "Code Action")

  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gr", fzflua.lsp_references, "Goto References")
  nmap("gI", fzflua.lsp_implementations, "Goto Implementation")
  nmap("<leader>fs", fzflua.lsp_document_symbols, "Document Symbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
  imap("<c-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.type_definition, "Goto Type Definition")
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

-- TODO: create a better way to set this up so custom configs live with their lsp stuff
vim.filetype.add({ extension = { templ = "templ" } })

local servers = {
  -- terraform stuff
  terraformls = {},
  tflint = {},

  -- other things
  clangd = {},
  pyright = {},
  rust_analyzer = {},
  gopls = {},
  templ = {},
  -- NOTE: replaced by typescript-tools on_attach
  tsserver = {},
  eslint = {},
  graphql = {},
  html = {
    filetypes = { "html", "templ" },
  },
  htmx = {
    filetypes = { "html", "templ" },
  },
  emmet_language_server = {},

  lua_ls = {
    Lua = {
      format = {
        enable = false,
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
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
    local handlers = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        -- Keep it open while typing
        close_events = { "CursorMoved", "BufHidden" },
      }),
    }

    if server_name == "tsserver" then
      -- print("Setting up typescript-tools instead of tsserver")
      -- It was done this way so if it's removed I won't forget why tsserver isn't working
      require("typescript-tools").setup({
        handlers = handlers,
        on_attach = on_attach,
        settings = {
          expose_as_code_action = "all",
        },
      })
      return
    end

    require("lspconfig")[server_name].setup({

      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      handlers = handlers,
    })
  end,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "bash-language-server",
    "shfmt",
    "gopls",
    "gotests",
    "shellcheck",
    "eslint_d",
    "prettierd",
  },
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
    ["<C-e>"] = cmp.mapping.abort(),
    -- ["<CR>"] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- }),
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

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

vim.keymap.set("n", "<leader>ll", vim.cmd.Lazy, { noremap = true, silent = true, desc = "Lazy" })
vim.keymap.set("n", "<leader>lm", vim.cmd.Mason, { noremap = true, silent = true, desc = "Mason" })
vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, { noremap = true, silent = true, desc = "LSP Info" })
vim.keymap.set("n", "<leader>lR", vim.cmd.LspRestart, { noremap = true, silent = true, desc = "Restart LSP" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
