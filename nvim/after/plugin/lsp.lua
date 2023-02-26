vim.opt.signcolumn = "yes" -- Reserve space for diagnostic icons

local navic = require("nvim-navic")
local cmp = require("cmp")
local lsp = require("lsp-zero").preset({
    name = "recommended",
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = true,
})
local lspkind = require('lspkind')
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
    ['<C-k>'] = cmp.mapping.scroll_docs( -4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),

    -- disable completion with tab it's annoying)
    ["<Tab>"] = vim.NIL,
    ["<S-Tab>"] = vim.NIL,
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
        })
    }
})

local on_attach = function(client, bufnr)
    -- Mappings.
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    local bind = vim.keymap.set
    bind("n", "<leader>e", vim.diagnostic.open_float, bufopts)
    bind("n", "[d", vim.diagnostic.goto_prev, bufopts)
    bind("n", "]d", vim.diagnostic.goto_next, bufopts)
    bind("n", "<leader>q", vim.diagnostic.setloclist, bufopts)
    bind("n", "gD", vim.lsp.buf.declaration, bufopts)
    bind("n", "gd", vim.lsp.buf.definition, bufopts)
    bind("n", "K", vim.lsp.buf.hover, bufopts)
    bind("n", "gi", vim.lsp.buf.implementation, bufopts)
    bind("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
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
        vim.lsp.buf.format({ async = true })
    end, bufopts)

    -- Capabilities
    local caps = client.server_capabilities

    if caps.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    -- Server specific
    -- print('client.name: ' .. client.name)
    if client.name == "eslint" then
        -- Auto lint on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end
end
-- ----------------------------------------------------
-- Languages
-- ----------------------------------------------------
lsp.ensure_installed({
    "tsserver",
    "eslint",
    "lua_ls",
    "rust_analyzer",
    "jsonls",
    "marksman",
})

lsp.configure("lua_ls", {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                -- Fix Undefined global 'vim'
                globals = { "vim" },
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

-- Replaced by rust-tools (see config at the bottom)
-- lsp.configure("rust_analyzer", {
--     on_attach = on_attach,
-- })

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
