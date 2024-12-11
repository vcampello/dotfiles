return {
  lazy = false,
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",

    "b0o/schemastore.nvim",
    -- configured in: ./cmp.lua
    "saghen/blink.cmp",
    {
      "ckipp01/stylua-nvim",
      build = "cargo install stylua",
    },
    {
      --extended TS server functionality
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
      -- set setup on ./file-operations.lua
      "antosha417/nvim-lsp-file-operations",
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

      -- NOTE: this makes text shift horizontally and it can be distracting
      local inlay_hint_filter = { bufnr = bufnr }
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false, inlay_hint_filter)
      end

      nmap("<leader>li", function()
        local is_enabled = vim.lsp.inlay_hint.is_enabled(inlay_hint_filter)
        vim.lsp.inlay_hint.enable(not is_enabled, inlay_hint_filter)
      end, "Toggle inlay hints")

      local fzf = require("fzf-lua")
      nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
      -- nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
      nmap("<leader>la", fzf.lsp_code_actions, "Code Action")

      nmap("gd", function()
        fzf.lsp_definitions({ jump_to_single_result = true })
      end, "Goto Definition")
      nmap("gr", function()
        fzf.lsp_references({ jump_to_single_result = true })
      end, "Goto References")
      nmap("gI", function()
        fzf.lsp_implementations({ jump_to_single_result = true })
      end, "Goto Implementation")
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
      gopls = {
        settings = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
      templ = {},
      sqlls = {},
      -- NOTE: replaced by typescript-tools on_attach
      ts_ls = {},
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
        settings = {
          Lua = {
            hint = { enable = true, paramType = true },
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
      glsl_analyzer = {},
      nil_ls = {}, -- Nix support
    }

    -- broadcast addional capabilities to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    local file_ops_capabilities = require("lsp-file-operations").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities, file_ops_capabilities)

    require("mason").setup({ ui = { border = "single" } })
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

        if server_name == "ts_ls" then
          -- print("Setting up typescript-tools instead of ts_ls")
          -- It was done this way so if it's removed I won't forget why ts_ls isn't working
          require("typescript-tools").setup({
            handlers = handlers,
            on_attach = on_attach,
            settings = {
              expose_as_code_action = "all",
              -- TODO: migrate this to ts_ls (the structure is different)
              tsserver_file_preferences = {
                includeInlayParameterNameHints = "all",
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                -- includeInlayVariableTypeHints = true,
              },
            },
          })
          return
        end

        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = (servers[server_name] or {}).settings,
          filetypes = (servers[server_name] or {}).filetypes,
          handlers = handlers,
        })
      end,
    })
  end,
}
