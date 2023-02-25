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
    -- disable completion with tab it's annoying)
    ["<Tab>"] = vim.NIL,
    ["<S-Tab>"] = vim.NIL,
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

-- The below setup comes from https://github.com/neovim/nvim-lspconfig
local on_attach = function(client, bufnr)
    -- print('running on_attach')
    --
    -- Mappings.
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, bufopts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    -- Format code. Lowercase f conflicts with the telescope mapping if typed slow enough
    vim.keymap.set("n", "<leader>F", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)

    local caps = client.server_capabilities

    if caps.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    -- Server specific
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

lsp.configure("rust_analyzer", {
    on_attach = on_attach,
    -- Server-specific settings...
    settings = {
        ["rust-analyzer"] = {},
    },
})

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
