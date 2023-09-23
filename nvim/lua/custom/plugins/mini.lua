return {
    'echasnovski/mini.nvim',
    config = function()
        -- Use defaults
        require("mini.cursorword").setup()
        require("mini.indentscope").setup()
        require("mini.move").setup()
        require("mini.pairs").setup()
        -- require("mini.surround").setup()
        require("mini.splitjoin").setup()

        -- mini.bufremove
        local MiniBufRemove = require("mini.bufremove")
        MiniBufRemove.setup()
        vim.keymap.set({ "n", "i" }, "<C-c>", MiniBufRemove.wipeout, { desc = "Wipeout current buffer" })
        vim.keymap.set({ "n", "i" }, "<F4>", function()
            MiniBufRemove.wipeout(0, true)
        end, { desc = "Wipeout current buffer (force)" })
    end

}
