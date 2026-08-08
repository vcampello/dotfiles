local nvim_treesitter_uri = "nvim-treesitter/nvim-treesitter"

return {
    nvim_treesitter_uri,
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install({
            "bash",
            "c",
            "diff",
            "html",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "rust",
            "go",
            "typescript",
            "tsx",
            "query",
            "vim",
            "vimdoc",
            "toml",
        })

        -- taken from: https://github.com/nvim-lua/kickstart.nvim/blob/b84f0b775d991de3640b752eee8cb857d4bbfe27/init.lua#L913-L956
        ---@param buf integer
        ---@param language string
        local function treesitter_try_attach(buf, language)
            -- Check if a parser exists and load it
            if not vim.treesitter.language.add(language) then
                return
            end
            -- Enable syntax highlighting and other treesitter features
            vim.treesitter.start(buf, language)

            -- Enable treesitter based folds
            -- For more info on folds see `:help folds`
            -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- vim.wo.foldmethod = 'expr'

            -- Check if treesitter indentation is available for this language, and if so enable it
            -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
            local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

            -- Enable treesitter based indentation
            if has_indent_query then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        local available_parsers = require("nvim-treesitter").get_available()
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local buf, filetype = args.buf, args.match

                local language = vim.treesitter.language.get_lang(filetype)
                if not language then
                    return
                end

                local installed_parsers = require("nvim-treesitter").get_installed("parsers")

                if vim.tbl_contains(installed_parsers, language) then
                    -- Enable the parser if it is already installed
                    treesitter_try_attach(buf, language)
                elseif vim.tbl_contains(available_parsers, language) then
                    -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
                    require("nvim-treesitter").install(language):await(function()
                        treesitter_try_attach(buf, language)
                    end)
                else
                    -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                    treesitter_try_attach(buf, language)
                end
            end,
        })
    end,

    dependencies = {
        -- tree-sitter CLI must be installed system-wide
        -- context window for long files
        {
            "nvim-treesitter/nvim-treesitter-context",
            dependencies = { nvim_treesitter_uri },
            opts = {
                multiwindow = true,
                separator = "─",
                multiline_threshold = 2,
            },
            keys = {
                vim.keymap.set("n", "<leader>;", function()
                    require("treesitter-context").go_to_context(vim.v.count1)
                end, { silent = true, desc = "Jump to parent context" }),
            },
        },

        -- pretty render markdown
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = {
                nvim_treesitter_uri,
                "nvim-tree/nvim-web-devicons",
            },
            ---@module 'render-markdown'
            ---@type render.md.UserConfig
            opts = {},
        },
    },
}
