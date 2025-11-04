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
      "mrcjkb/rustaceanvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
    },
    -- fix react comment string
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        require("ts_context_commentstring").setup({
          enable_autocmd = false,
        })

        local get_option = vim.filetype.get_option
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.filetype.get_option = function(filetype, option)
          return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
        end
      end,
    },

    {
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
    },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      -- event = "VeryLazy",
      -- priority = 1000,
      config = function()
        require("tiny-inline-diagnostic").setup({
          preset = "simple",
        })
        vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
      end,
    },
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
      if client then
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map("n", "grI", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
          end, "Toggle inlay hints")
        end

        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
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
      map("n", "grw", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
      map("n", "grW", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
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
    -- manual
    vim.lsp.enable("circleci_lsp")

    -- setup normal lsp configs
    require("mason-lspconfig").setup({
      ensure_installed = {
        "fish_lsp",
        "golangci_lint_ls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "taplo",
        "ts_ls",
        "yamlls",
      },
      automatic_installation = false,
      automatic_enable = {
        exclude = {
          "htmx",
        },
      },
    })
  end,
}
