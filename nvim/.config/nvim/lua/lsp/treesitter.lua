return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "jmbuhr/otter.nvim",
  },
  config = function()
    ---@type table<string, boolean>
    local enable_otter = {
      toml = true,
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(ev)
        local lang = ev.match

        -- we cannot auto install it
        if require("nvim-treesitter.parsers")[lang] == nil then
          return
        end

        -- schedule the auto install to prevent locking up neovim
        return vim.schedule(function()
          require("nvim-treesitter").install(lang):wait()
          vim.treesitter.start(ev.buf, lang)

          if enable_otter[lang] then
            require("otter").activate()
          end
        end)
      end,
    })
  end,
}
