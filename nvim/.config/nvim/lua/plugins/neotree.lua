return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    "s1n7ax/nvim-window-picker",
  },
  config = function()
    require("neo-tree").setup({
      sources = {
        "filesystem",
        "buffers",
        "git_status",
      },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
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
            vim.cmd.stopinsert()
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
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.relativenumber = true
          end,
        },
      },
    })

    -- Mappings
    -- vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    vim.keymap.set("n", "<leader>nf", "<cmd>:Neotree reveal float<cr>", { desc = "Neotree (float)" })
    vim.keymap.set("n", "<leader>nh", "<cmd>:Neotree reveal left<cr>", { desc = "Neotree (left)" })
    vim.keymap.set("n", "<leader>nl", "<cmd>:Neotree reveal right<cr>", { desc = "Neotree (right)" })
    vim.keymap.set("n", "<leader>nk", "<cmd>:Neotree reveal top<cr>", { desc = "Neotree (top)" })
    vim.keymap.set("n", "<leader>nj", "<cmd>:Neotree reveal bottom<cr>", { desc = "Neotree (bottom)" })
    vim.keymap.set("n", "<leader>nc", "<cmd>:Neotree close<cr>", { desc = "Neotree Close" })
  end,
}
