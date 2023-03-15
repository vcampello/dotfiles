vim.opt.signcolumn = "yes" -- Reserve space for diagnostic icons

local navic = require("nvim-navic")
local cmp = require("cmp")
local lsp = require("lsp-zero").preset({
    name = "recommended",
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = true,
})
local lspkind = require("lspkind")
local rt = require("rust-tools")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    -- Better popup scrolling
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    -- disable completion with tab it's annoying)
    ["<Tab>"] = vim.NIL,
    ["<S-Tab>"] = vim.NIL,
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
        }),
    },
})

local bind = vim.keymap.set

-- Utils
bind("n", "<leader>lm", vim.cmd.Mason, { noremap = true, silent = true, desc = "Mason" })
bind("n", "<leader>li", vim.cmd.LspInfo, { noremap = true, silent = true, desc = "LspInfo" })
-- TODO: add a shortcut for git blame

local on_attach = function(client, bufnr)
    -- print("LSP attached: " .. client.name)

    -- Capabilities
    local caps = client.server_capabilities

    if caps.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    -- Mappings.
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    bind("n", "<leader>e", vim.diagnostic.open_float, bufopts)
    bind("n", "[d", vim.diagnostic.goto_prev, bufopts)
    bind("n", "]d", vim.diagnostic.goto_next, bufopts)
    bind("n", "<leader>q", vim.diagnostic.setloclist, bufopts)
    bind("n", "gD", vim.lsp.buf.declaration, bufopts)
    bind("n", "gd", vim.lsp.buf.definition, bufopts)
    bind("n", "K", vim.lsp.buf.hover, bufopts)
    bind("n", "gi", vim.lsp.buf.implementation, bufopts)
    -- Also figure out how to actually use this
    -- bind("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    bind("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    bind("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    bind("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    bind("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    bind("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    bind("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    bind("n", "gr", vim.lsp.buf.references, bufopts)
    -- Format code. Lowercase f conflicts with the telescope mapping if typed slow enough
    bind("n", "<leader>F", function()
        print("Formatting with " .. client.name)
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- ----------------------------------------------------
-- Languages
-- ----------------------------------------------------
lsp.ensure_installed({
    "tsserver",
    -- "eslint", -- Don't install if using it through null-ls or there will be duplicate entries
    "lua_ls",
    "rust_analyzer",
    "jsonls",
    "marksman",
    "taplo",
})

lsp.configure("lua_ls", {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                -- considerably increases lsp loading time
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

lsp.configure("tsserver", {
    on_attach = on_attach,
})

lsp.configure("marksman", {
    on_attach = on_attach,
})

-- TODO: figure out how to to format JSON properly

lsp.configure("jsonls", {
    on_attach = on_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

lsp.setup()

-- Needs to be setup after lsp.setup() or the on_attach won't work as expected
rt.setup({
    server = {
        on_attach = on_attach,
    },
})

local null_ls = require("null-ls")
null_ls.setup({
    on_attach = on_attach,
    sources = {
        -- Utils
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.todo_comments.with({
            diagnostic_config = {
                virtual_text = false,
            },
        }),

        -- Lua
        null_ls.builtins.formatting.stylua,

        -- Typing
        null_ls.builtins.completion.spell,
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.diagnostics.cspell.with({
            diagnostic_config = {
                -- disable gutter errors or there will be errors everywhere in some codebases
                signs = false,
                virtual_text = false,
                underline = true,
            },
            -- TODO: find a way to skip these when moving between diagnostics
            diagnostics_postprocess = function(diagnostic)
                -- I don't want to deal with every single word that makes sense but isn't in the dictionary
                diagnostic.severity = vim.diagnostic.severity.INFO
            end,
        }),

        -- Node
        null_ls.builtins.diagnostics.tsc.with({
            prefer_local = "node_modules/.bin",
        }),

        -- eslint & prettier (will default to local if found in node_modules)
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.prettierd.with({
            env = {
                -- Use this config as a fallback
                PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/external-configs/prettierrc.json",
            },
        }),

        -- Other linters
        null_ls.builtins.diagnostics.cfn_lint,
        null_ls.builtins.diagnostics.dotenv_linter,
    },
})

-- Enable virtual_text for all diagnostics (override on specific configs)
vim.diagnostic.config({
    virtual_text = true,
})
