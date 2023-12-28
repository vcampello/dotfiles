return {
  "jedrzejboczar/possession.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- accept y/n without enter key
    prompt_no_cr = true,
    commands = {
      save = "SSave",
      load = "SLoad",
      rename = "SRename",
      close = "SClose",
      delete = "SDelete",
      show = "SShow",
      list = "SList",
      migrate = "SMigrate",
    },
    autosave = {
      current = true, -- or fun(name): boolean
      tmp = true, -- or fun(): boolean
      tmp_name = "autosave", -- or fun(): string
      on_load = true,
      on_quit = true,
    },
  },
}
