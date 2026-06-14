return {
    "https://github.com/nvim-mini/mini.nvim",
    version = false,
    config = function()
        require("mini.indentscope").setup()
        require("mini.splitjoin").setup()
        require("mini.ai").setup()

        -- setup diff
        require("mini.diff").setup()
        vim.keymap.set("n", "<leader>gt", require("mini.diff").toggle_overlay, { desc = "Toggle inline git diff" })

        -- setup highlighter
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                -- Highlight hex color strings (`#rrggbb`) using that color
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
    end,
}
