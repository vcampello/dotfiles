require("mini.comment").setup({
    mappings = {
        text_object = "<leader>/",
        comment = "<leader>/",
        comment_line = "<leader>//",
    },
})
require("mini.cursorword").setup()
require("mini.indentscope").setup()
-- require("mini.animate").setup();
require("mini.move").setup()
-- TODO: check why this doesn't seem to work
require("mini.pairs").setup()
require("mini.sessions").setup(
    -- No need to copy this inside `setup()`. Will be used automatically.
    {
        -- Whether to read latest session if Neovim opened without file arguments
        autoread = false,
        -- Whether to write current session before quitting Neovim
        autowrite = true,
        -- Directory where global sessions are stored (use `''` to disable)
        -- directory = --<"session" subdir of user data directory from |stdpath()|>,

        -- File for local session (use `''` to disable)
        file = "Session.vim",
        -- Whether to force possibly harmful actions (meaning depends on function)
        force = { read = false, write = true, delete = false },
        -- Hook functions for actions. Default `nil` means 'do nothing'.
        hooks = {
            -- Before successful action
            pre = { read = nil, write = nil, delete = nil },
            -- After successful action
            post = { read = nil, write = nil, delete = nil },
        },
        -- Whether to print session path after action
        verbose = { read = false, write = true, delete = true },
    }
)
local starter = require("mini.starter")
starter.setup({
    -- Use this if you set up 'mini.sessions'
    starter.sections.sessions(5, true),
})
