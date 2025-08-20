return {
  cmd = {
    "circleci-yaml-language-server",
    "-stdio",
    "-schema",
    vim.fn.stdpath("data") .. "/mason/packages/circleci-yaml-language-server/schema.json",
  },
  filetypes = {
    "yaml",
  },
  root_markers = { ".git", ".circleci" },
  root_dir = function(bufnr, on_dir)
    -- only start when the file is in the .circleci folder
    local bufname = vim.fn.bufname(bufnr)
    local is_circle_ci_config = bufname:match("%.circleci/")
    if is_circle_ci_config then
      on_dir(vim.fn.getcwd())
    end
  end,
}
