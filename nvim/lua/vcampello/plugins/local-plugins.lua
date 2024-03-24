local plugin_path = vim.fn.stdpath("config") .. "/lua/vcampello/local-plugins/neotree-sessions.nvim"
print(plugin_path)
return {
  lazy = false,
  dir = plugin_path,
  opts = {
    msg = "potato",
  },
}
