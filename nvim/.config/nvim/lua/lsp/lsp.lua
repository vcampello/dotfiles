return {
  -- lazy = false,
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { "williamboman/mason.nvim", opts = {} },
    "williamboman/mason-lspconfig.nvim",
    "b0o/schemastore.nvim",
    -- configured in: ./cmp.lua
    "saghen/blink.cmp",
    {
      --extended TS server functionality
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    -- set setup on ./file-operations.lua
    "antosha417/nvim-lsp-file-operations",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        ---@param mode string | string[]
        ---@param keys string
        ---@param func fun()
        ---@param desc string
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- NOTE: this makes text shift horizontally and it can be distracting
        local inlay_hint_filter = { bufnr = bufnr }
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(false, inlay_hint_filter)
        end

        map("n", "<leader>li", function()
          local is_enabled = vim.lsp.inlay_hint.is_enabled(inlay_hint_filter)
          vim.lsp.inlay_hint.enable(not is_enabled, inlay_hint_filter)
        end, "Toggle inlay hints")

        local fzf = require("fzf-lua")
        map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
        -- nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>la", fzf.lsp_code_actions, "Code Action")

        map("n", "gd", function()
          fzf.lsp_definitions({ jump1 = true })
        end, "Goto Definition")
        map("n", "gr", function()
          fzf.lsp_references({ jump1 = true })
        end, "Goto References")
        map("n", "gI", function()
          fzf.lsp_implementations({ jump1 = true })
        end, "Goto Implementation")
        map("n", "<leader>fs", fzf.lsp_document_symbols, "Document Symbols")

        -- See `:help K` for why this keymap
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
        map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Lesser used LSP functionality
        map("n", "gD", vim.lsp.buf.type_definition, "Goto Type Definition")
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "Workspace List Folders")

        -- TODO: improve this
        local function format()
          require("conform").format({ async = true, lsp_fallback = true })
        end

        vim.api.nvim_buf_create_user_command(bufnr, "Format", format, { desc = "Format current buffer with LSP" })

        map("n", "<leader>lf", format, "Format current buffer with LSP")
      end,
    })

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
      sqlls = {},
      -- NOTE: replaced by typescript-tools on_attach
      ts_ls = {},
      volar = {
        filetypes = { "vue" },
      },
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
            completion = { callSnippet = "Replace" },
            format = {
              enable = false,
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim", "Snacks" },
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

    -- nix is required for nil_ls to be installed
    if vim.fn.executable("nix") == 0 then
      servers.nil_ls = nil
    end

    -- broadcast addional capabilities to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    local file_ops_capabilities = require("lsp-file-operations").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities, file_ops_capabilities)

    ---@diagnostic disable-next-line: missing-fields
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
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
            },
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
              capabilities = capabilities,
              -- root_dir = root_pattern_exclude({
              --   root = { "package.json" },
              --   exclude = { "deno.json", "deno.jsonc" },
              -- }),
              tsserver_plugins = {
                "@vue/typescript-plugin",
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
