vim.lsp.config("lua_ls", {
  {
    Lua = {
      hint = { enable = true, paramType = true },
      completion = { callSnippet = "Replace" },
      format = {
        enable = false,
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "Snacks" },
        -- Ignore noisy warnings
        disable = { "missing-fields" },
      },
    },
  },
})
