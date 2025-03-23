-- Resolve differences between neovim nightly (version 0.11) and stable (version 0.10)
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer some lsp support methods only in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
  if vim.fn.has("nvim-0.11") == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(method, { bufnr = bufnr })
  end
end

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

    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("InitLspOnAttach", { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        ---Keymap wrapper
        ---@param mode string | string[]
        ---@param keys string
        ---@param func fun()
        ---@param desc string
        local function map(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- setup inlay hints if available
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map("n", "grI", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
          end, "Toggle inlay hints")
        end

        local fzf = require("fzf-lua")
        -- override: vim.lsp.buf.code_action
        map("n", "gra", fzf.lsp_code_actions, "Code Action")

        --- these 2 are used way too often
        map("n", "gd", function()
          fzf.lsp_definitions({ jump1 = true })
        end, "Go to Definition")
        map("n", "gD", vim.lsp.buf.type_definition, "Go to Type Definition")

        -- override: vim.lsp.buf.references
        map("n", "grr", function()
          fzf.lsp_references({ jump1 = true })
        end, "Go to References")

        -- override: vim.lsp.buf_impementation
        map("n", "gri", function()
          fzf.lsp_implementations({ jump1 = true })
        end, "Goto Implementation")

        -- override: vim.lsp.buf.document_symbols
        map("n", "gO", fzf.lsp_document_symbols, "Document Symbols")

        -- See `:help K` for why this keymap
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
        map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Lesser used LSP functionality
        map("n", "grA", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
        map("n", "grR", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
        map("n", "grL", function()
          vim.print(vim.lsp.buf.list_workspace_folders())
        end, "Workspace List Folders")

        -- TODO: improve this
        local function format()
          require("conform").format({ async = true, lsp_fallback = true })
        end

        vim.api.nvim_buf_create_user_command(bufnr, "Format", format, { desc = "Format current buffer with LSP" })

        map("n", "grf", format, "Format current buffer with LSP")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if
          client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
        then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = ev.buf })
            end,
          })
        end
      end,
    })

    -- Enable the following language servers
    local servers = {
      -- terraform stuff
      terraformls = {},
      tflint = {},

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

      -- js/ts stuff
      -- NOTE: replaced by typescript-tools
      -- ts_ls = {},
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
              -- Ignore noisy warnings
              disable = { "missing-fields" },
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
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("blink.cmp").get_lsp_capabilities(default_capabilities)
    local file_ops_capabilities = require("lsp-file-operations").default_capabilities()
    local capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities, file_ops_capabilities)

    ---@diagnostic disable-next-line: missing-fields
    require("mason").setup({ ui = { border = "single" } })

    local modifiedHandlers = {
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        -- Keep it open while typing
        close_events = { "CursorMoved", "BufHidden" },
      }),
    }

    -- setup normal lsp configs
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          --- overrides
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          server.handlers = vim.tbl_deep_extend("force", {}, modifiedHandlers, server.handlers or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    -- setup ts_ls wrapper
    require("typescript-tools").setup({
      handlers = modifiedHandlers,
      -- on_attach = on_attach,
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      },
      settings = {
        expose_as_code_action = "all",
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
  end,
}
