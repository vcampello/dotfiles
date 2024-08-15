return {
  lazy = false,
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    -- configured in: ./cmp.lua
    "hrsh7th/nvim-cmp",

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
    {
      "ckipp01/stylua-nvim",
      build = "cargo install stylua",
    },
    {
      --extended TS server functionality
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
  },
  config = function()
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

      local fzf = require("fzf-lua")
      nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
      -- nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
      nmap("<leader>la", fzf.lsp_code_actions, "Code Action")

      nmap("gd", vim.lsp.buf.definition, "Goto Definition")
      nmap("gr", fzf.lsp_references, "Goto References")
      nmap("gI", fzf.lsp_implementations, "Goto Implementation")
      nmap("<leader>fs", fzf.lsp_document_symbols, "Document Symbols")

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

    -- TODO: create a better way to set this up so custom configs live with their lsp stuff
    vim.filetype.add({ extension = { templ = "templ" } })

    -- Enable the following language servers
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
  end,
}