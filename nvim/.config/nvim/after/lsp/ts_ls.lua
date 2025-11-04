return {
  --- tsserver options go here.
  --- @see https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      -- includeInlayVariableTypeHints = true,
    },
  },
}
