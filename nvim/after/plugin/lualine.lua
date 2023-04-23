-- Modifed version of:
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")
local navic = require("nvim-navic")

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = {
                a = { fg = colors.fg, bg = colors.bg },
                c = { fg = colors.fg, bg = colors.bg },
            },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
    -- tabline = {
    --     lualine_a = {},
    --     lualine_b = {},
    --     lualine_c = {
    --         {
    --             "buffers",
    --             show_filename_only = true, -- Shows shortened relative path when set to false.
    --             hide_filename_extension = false, -- Hide filename extension when set to true.
    --             show_modified_status = true, -- Shows indicator when the buffer is modified.
    --             mode = 2,
    --             -- 0: Shows buffer name
    --             -- 1: Shows buffer index
    --             -- 2: Shows buffer name + buffer index
    --             -- 3: Shows buffer number
    --             -- 4: Shows buffer name + buffer number
    --
    --             max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
    --             -- it can also be a function that returns
    --             -- the value of `max_length` dynamically.
    --             filetype_names = {
    --                 TelescopePrompt = "Telescope",
    --                 dashboard = "Dashboard",
    --                 packer = "Packer",
    --                 fzf = "FZF",
    --                 alpha = "Alpha",
    --             }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
    --             buffers_color = {
    --                 -- Same values as the general color option can be used here.
    --                 active = "red", --'lualine_c_normal', -- Color for active buffer.
    --                 inactive = "lualine_c_inactive", -- Color for inactive buffer.
    --             },
    --             symbols = {
    --                 modified = " ●", -- Text to show when the buffer is modified
    --                 alternate_file = "#", -- Text to show to identify the alternate file
    --                 directory = "", -- Text to show when the buffer is a directory
    --             },
    --         },
    --     },
    --     lualine_x = { "tabs" },
    -- },
    winbar = {
        lualine_c = {
            {
                function()
                    -- Use a placeholder to prevent it from snapping up and down
                    if navic.get_location():len() > 0 then
                        return navic.get_location()
                    else
                        return " "
                    end
                end,
                cond = navic.is_available,
                color = { fg = colors.orange, bg = "", gui = "bold" },
            },
        },
        lualine_z = {
            {
                function()
                    local first_workspace = vim.lsp.buf.list_workspace_folders()[1]
                    if first_workspace ~= nil then
                        return "Workspace: " .. first_workspace
                    else
                        return ""
                    end
                end,
                color = { fg = colors.orange, bg = "", gui = "bold" },
            },
        },
    },
    inactive_winbar = {
        lualine_a = {
            {
                -- Prevent buffer from resizing when inactive
                function()
                    return " "
                end,
                cond = navic.is_available,
                color = { fg = colors.red, bg = "", gui = "bold" },
            },
        },
    },
}

-- Inserts a component in lualine_c at left section
local function ins_left_c(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right_x(component)
    table.insert(config.sections.lualine_x, component)
end

ins_left_c({
    function()
        return "▊"
    end,
    color = { fg = colors.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left_c({
    -- mode component
    function()
        return ""
    end,
    color = function()
        -- auto change color according to neovims mode
        local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
})

ins_left_c({
    -- filesize component
    "filesize",
    cond = conditions.buffer_not_empty,
})

ins_left_c({
    "filename",
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = "bold" },
})

ins_left_c({ "location" })

ins_left_c({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left_c({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " " },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
    },
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left_c({
    function()
        return "%="
    end,
})

ins_left_c({
    -- Lsp server name .
    function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = " LSP:",
    color = { fg = "#ffffff", gui = "bold" },
})

-- Add components to right sections
ins_right_x({
    "o:encoding", -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = "bold" },
})

ins_right_x({
    "fileformat",
    fmt = string.upper,
    icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
    color = { fg = colors.green, gui = "bold" },
})

ins_right_x({
    "branch",
    icon = "",
    color = { fg = colors.violet, gui = "bold" },
})

ins_right_x({
    "diff",
    -- Is it me or the symbol for modified us really weird
    symbols = { added = " ", modified = "柳 ", removed = " " },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
})

ins_right_x({
    function()
        return "▊"
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
