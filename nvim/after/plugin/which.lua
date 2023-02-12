-- Determine when which-key should trigger
vim.o.timeout = true
vim.o.timeoutlen = 300
-- TODO: setup all keybindings
require("which-key").setup { }
