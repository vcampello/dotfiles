local format_utils = require("lib.format_utils")

---Configure multiple language with the same formatter
---@param formatters conform.FiletypeFormatter
---@param langs string[]
---@return table
local function use_formatter_for(formatters, langs)
    if langs == nil then
        langs = {}
    end

    local mapped = {}

    for _, value in ipairs(langs) do
        mapped[value] = formatters
    end

    return mapped
end

return {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
        log_level = vim.log.levels.DEBUG,
        formatters = {
            prettierd = {
                -- Should be a function so it executes with the correct context
                env = function()
                    return {
                        PRETTIERD_DEFAULT_CONFIG = format_utils.store.prettier,
                    }
                end,
            },
            biome = {
                -- Should be a function so it executes with the correct context
                env = function()
                    -- NOTE: setting BIOME_CONFIG_PATH causes errors if the project has a biome config
                    if format_utils.has_biome_config() then
                        return {}
                    end

                    return {
                        BIOME_CONFIG_PATH = format_utils.store.biome,
                    }
                end,
            },
        },
        formatters_by_ft = vim.tbl_deep_extend(
            "force",
            {
                lua = { "stylua" },
                python = { "ruff_fix", "ruff_format" },
                rust = { "rustfmt" },
                sh = { "shfmt" },
            },
            -- core prettier languages
            use_formatter_for({ "prettierd", "prettier", stop_after_first = true }, {
                "graphql",
                "html",
                "javascript",
                "javascriptreact",
                "json",
                "jsonc",
                "markdown",
                "typescript",
                "typescriptreact",
                "vue",
            }),
            -- override prettier config with biome when prettier is missing
            format_utils.has_prettier_config() and {}
                or use_formatter_for({ "biome", "biome-organize-imports", stop_after_first = false }, {
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "jsonc",
                    "typescript",
                    "typescriptreact",
                    "vue",
                })
        ),
        format_on_save = function()
            if not Config.auto_format then
                vim.notify("autoformat is disabled", vim.log.levels.INFO)
                return
            end

            -- do not format if the file has not been modified before
            if not vim.bo.modifiable or not vim.bo.modified then
                return
            end

            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
