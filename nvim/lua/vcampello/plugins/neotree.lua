return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    "mrbjarksen/neo-tree-diagnostics.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  config = function()
    require("neo-tree").setup({
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
        "diagnostics",
      },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
          { source = "document_symbols" },
          -- requires plugin 'mrbjarksen/neo-tree-diagnostics.nvim'
          { source = "diagnostics" },
        },
      },
      -- Close Neo-tree if it is the last window left in the tab
      close_if_last_window = true,
      window = {
        position = "right",
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_by_name = {
            "node_modules",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            ".gitignored",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        use_libuv_file_watcher = true,
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
        },
      },
      -- requires plugin 'mrbjarksen/neo-tree-diagnostics.nvim'
      diagnostics = {
        auto_preview = { -- May also be set to `true` or `false`
          enabled = true,
        },
      },
      event_handlers = {

        {
          event = "neo_tree_popup_input_ready",
          handler = function()
            -- enter input popup with normal mode by default.
            vim.cmd("stopinsert")
          end,
        },
        {
          event = "neo_tree_popup_input_ready",
          ---@param args { bufnr: integer, winid: integer }
          handler = function(args)
            -- map <esc> to enter normal mode (by default closes prompt)
            -- don't forget `opts.buffer` to specify the buffer of the popup.
            vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
          end,
        },
      },
    })

    -- Mappings
    -- vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    vim.keymap.set("n", "<leader>nf", "<cmd>:Neotree filesystem reveal float<cr>", { desc = "Neotree Filesystem" })
    vim.keymap.set("n", "<leader>nb", "<cmd>:Neotree buffers toggle float<cr>", { desc = "Neotree Buffers" })
    vim.keymap.set("n", "<leader>ng", "<cmd>:Neotree git_status toggle float<cr>", { desc = "Neotree Git" })
    vim.keymap.set("n", "<leader>ns", "<cmd>:Neotree document_symbols right<cr>", { desc = "Neotree Symbols" })
    vim.keymap.set("n", "<leader>nd", "<cmd>:Neotree diagnostics bottom<cr>", { desc = "Neotree Diagnostics" })
    vim.keymap.set("n", "<leader>nc", "<cmd>:Neotree close<cr>", { desc = "Neotree Close" })
  end,
}
