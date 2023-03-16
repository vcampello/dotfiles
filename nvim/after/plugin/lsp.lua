vim.opt.signcolumn = "yes" -- Reserve space for diagnostic icons

local navic = require("nvim-navic")
local cmp = require("cmp")
local lsp = require("lsp-zero").preset({
    name = "recommended",
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = true,
})

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
        format = require("lspkind").cmp_format({
            mode = "symbol_text",
        }),
    },
})

local bind = vim.keymap.set

-- Utils
bind("n", "<leader>lm", vim.cmd.Mason, { noremap = true, silent = true, desc = "Mason" })
bind("n", "<leader>li", vim.cmd.LspInfo, { noremap = true, silent = true, desc = "LspInfo" })
-- TODO: add a shortcut for git blame and hunk cmds

local on_attach = function(client, bufnr)
    -- print("LSP attached: " .. client.name)

    -- Capabilities
    local caps = client.server_capabilities

    if caps.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    local make_bufopts = function(extra_opts)
        return vim.tbl_deep_extend("force", bufopts, extra_opts or {})
    end

    -- Mappings.
    bind("n", "<leader>e", vim.diagnostic.open_float, make_bufopts({ desc = "Open floating diagnostic" }))
    bind("n", "[d", vim.diagnostic.goto_prev, make_bufopts({ desc = "Previous diagnostic" }))
    -- bind("n", "]d", vim.diagnostic.goto_next, make_bufopts({desc = ""}))
    bind("n", "]d", function()
        print("running function")
        -- TODO: custom function to skip cspell diagnostics
        vim.diagnostic.goto_next()
    end, make_bufopts({ desc = "Next diagnostic" }))
    bind("n", "<leader>q", vim.diagnostic.setloclist, make_bufopts({ desc = "Set location list" }))
    bind("n", "gD", vim.lsp.buf.declaration, make_bufopts({ desc = "Go to declaration" }))
    bind("n", "gd", vim.lsp.buf.definition, make_bufopts({ desc = "Go to definition" }))
    bind("n", "K", vim.lsp.buf.hover, make_bufopts({ desc = "" }))
    bind("n", "gi", vim.lsp.buf.implementation, make_bufopts({ desc = "Go to implementation" }))
    -- Also figure out how to actually use this
    -- bind("n", "<C-k>", vim.lsp.buf.signature_help, make_bufopts({desc = ""}))
    bind("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, make_bufopts({ desc = "Add workspace folder" }))
    bind("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, make_bufopts({ desc = "Remove workspace folder" }))
    bind("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, make_bufopts({ desc = "List workspace folders" }))
    bind("n", "<leader>D", vim.lsp.buf.type_definition, make_bufopts({ desc = "Go to type definition" }))
    bind("n", "<leader>rn", vim.lsp.buf.rename, make_bufopts({ desc = "Rename symbol" }))
    bind("n", "<leader>ca", vim.lsp.buf.code_action, make_bufopts({ desc = "Code actions" }))
    bind("n", "gr", vim.lsp.buf.references, make_bufopts({ desc = "Find references" }))
    -- Format code. Lowercase f conflicts with the telescope mapping if typed slow enough
    bind("n", "<leader>F", function()
        -- print("Formatting with " .. client.name)
        vim.lsp.buf.format({ async = true })
    end, make_bufopts({ desc = "Format buffer" }))
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
require("rust-tools").setup({
    server = {
        on_attach = on_attach,
    },
})

local null_ls = require("null-ls")
local null_ls_utils = require("null-ls.utils")

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
        null_ls.builtins.diagnostics.eslint_d.with({
            extra_args = function()
                -- TODO: figure out how to pass this arg conditionally because it leads to all sort of issues
                -- print(null_ls_utils.make_conditional_utils:root_has_file({ ".eslintrc.*" }))
                return {
                    -- Use this config as a fallback (will be merged with other configs)
                    -- "--config",
                    -- vim.fn.stdpath("config") .. "/external-configs/eslintrc.json",
                }
            end,
        }),
        null_ls.builtins.code_actions.eslint_d.with({
            extra_args = {
                -- Use this config as a fallback (will be merged with other configs)
                -- "--config",
                -- vim.fn.stdpath("config") .. "/external-configs/eslintrc.json",
            },
        }),
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
