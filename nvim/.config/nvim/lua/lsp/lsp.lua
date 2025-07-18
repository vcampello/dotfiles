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
    {
      "mrcjkb/rustaceanvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
    },
    -- set setup on ./file-operations.lua
    "antosha417/nvim-lsp-file-operations",
  },
  config = function()
    local on_attach = function(event)
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
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
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
        vim.cmd.normal("zz") -- centralise after jumping
      end, "Definitions")
      map("n", "gD", function()
        vim.lsp.buf.type_definition()
        vim.cmd.normal("zz") -- centralise after jumping
      end, "Type Definition")

      -- override: vim.lsp.buf.references
      map("n", "grr", function()
        fzf.lsp_references({ jump1 = true, includeDeclaration = false })
      end, "References")

      -- override: vim.lsp.buf_impementation
      map("n", "gri", function()
        fzf.lsp_implementations({ jump1 = true })
        vim.cmd.normal("zz") -- centralise after jumping
      end, "Implementation")

      -- override: vim.lsp.buf.document_symbols
      map("n", "gO", fzf.lsp_document_symbols, "Document Symbols")

      -- See `:help K` for why this keymap
      map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
      map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")
      --handled by blink
      -- map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Documentation")

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
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
    end
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("InitLspOnAttach", { clear = true }),
      callback = on_attach,
    })

    -- TODO: should this even live here?
    vim.lsp.config("circle_ci_lsp", {
      init_options = { hostInfo = "neovim" },
      cmd = {
        "circleci-yaml-language-server",
        "-stdio",
        "-schema",
        vim.fn.stdpath("data") .. "/mason/packages/circleci-yaml-language-server/schema.json",
      },
      filetypes = {
        "yaml",
      },
      root_markers = { ".git", ".circleci" },
      root_dir = function(bufnr, on_dir)
        print(vim.fn.bufname(bufnr))
        -- only start when the file is in the .circleci folder
        local bufname = vim.fn.bufname(bufnr)
        local is_circle_ci_config = bufname:match("%.circleci/")
        if is_circle_ci_config then
          on_dir(vim.fn.getcwd())
        end
      end,
    })

    vim.lsp.enable("circle_ci_lsp")

    -- Enable the following language servers
    local servers = {
      -- install these by default
      ts_ls = {},
      -- configured servers
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
      html = {},
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
    }

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
      automatic_enable = {
        exclude = {
          "ts_ls", -- we need it to be installed but we'll use typescript-tools instead
          "htmx",
        },
      },
      handlers = {
        function(server_name)
          ---FIXME: this no longer works as intended because of the `vim.lsp` api
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
        code_lens = "references_only",
        disable_member_code_lens = true,
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
        -- TODO: setup deno support
        -- root_dir = root_pattern_excludes({
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
