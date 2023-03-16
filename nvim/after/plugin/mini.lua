-- Use defaults
require("mini.cursorword").setup()
require("mini.indentscope").setup()
require("mini.move").setup()
require("mini.pairs").setup()
require("mini.surround").setup()

-- mini.animate
require("mini.animate").setup({
    scroll = {
        -- Scrolling behaves weirdly when not done through the keyboard
        enable = false,
    },
})

-- mini.bufremove setup
local MiniBufRemove = require("mini.bufremove")
MiniBufRemove.setup()
vim.keymap.set({ "n", "i" }, "<C-c>", MiniBufRemove.wipeout, { desc = "Wipeout current buffer" })
vim.keymap.set({ "n", "i" }, "<F4>", function()
    MiniBufRemove.wipeout(0, true)
end, { desc = "Wipeout current buffer (force)" })

-- mini.session
require("mini.sessions").setup(
    -- No need to copy this inside `setup()`. Will be used automatically.
    {
        autoread = false,
        autowrite = true,
        directory = vim.fn.stdpath("state") .. "/sessions",
    }
)

-- mini.session
local starter = require("mini.starter")
starter.setup({
    -- Use this if you set up 'mini.sessions'
    starter.sections.sessions(5, true),
})
