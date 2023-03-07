require("Comment").setup({
    -- Enable nvim-ts-context-commentstring
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
