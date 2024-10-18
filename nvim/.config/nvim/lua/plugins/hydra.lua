local M = {}
---@type table<string, Hydra> hydra
M.hydras = {}
---@type number|nil # Current hydra
M.current_idx = 1

---Get current hydra
---@param opts { name: string, dry_run?: boolean }
---@return Hydra current
function M.switch_by_name(opts)
  for idx, value in ipairs(M.hydras) do
    if value.name:lower() == opts.name:lower() then
      if opts.dry_run ~= true then
        M.current_idx = idx
      end

      return M.hydras[idx]
    end
  end
  error("Hydra " .. opts.name .. " not found", vim.log.levels.ERROR)
end

---Get current hydra
---@return Hydra current
function M.get_current()
  return M.hydras[M.current_idx]
end

---Get hydra from offset. Wraps around
---@param opts { offset: number, dry_run?: boolean }
---@return Hydra current
function M.switch_by_offset(opts)
  if #M.hydras == 0 then
    error("No navigation hydras", vim.log.levels.ERROR)
  end

  --wrap around if required
  local new_idx = (M.current_idx + opts.offset - 1) % #M.hydras + 1

  if opts.dry_run ~= true then
    M.current_idx = new_idx
  end
  -- print("cycling to " .. M.hydras[new_idx].name)

  return M.hydras[new_idx]
end

---@class NavHydra
---@field name string
---@field keymap? string
---@field heads table<string, hydra.Head >

---@param opts NavHydra
---@return Hydra
function M.create_nav_hydra(opts)
  --default heads
  ---@type table<string, hydra.Head>
  local heads = {
    {
      "h",
      function(opts)
        print(vim.v.count)
        M.get_current():exit()
        M.switch_by_offset({ offset = -1 }):activate()
      end,
      { exit = true, desc = "Previous mode", nowait = true },
    },
    {
      "l",
      function()
        -- prevent bugs causing hydras to get stuck or flicker
        M.get_current():exit()
        M.switch_by_offset({ offset = 1 }):activate()
      end,
      { exit = true, desc = "Next move", nowait = true },
    },
  }
  --insert user heads
  for _, head in ipairs(opts.heads) do
    table.insert(heads, head)
  end

  local hint = [[ %{get_hint} ]]
  local new_hydra = require("hydra")({
    name = opts.name,
    -- mode = { "n", "x" },
    -- body = '<leader>;',
    hint = hint,
    config = {
      color = "red",
      invoke_on_body = true,
      hint = {
        float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
          border = "rounded",
          -- title = " Nav: " .. opts.name,
          -- title_pos = "center",
        },
        position = "bottom",
        funcs = {
          get_hint = function()
            local modes = {}
            for _, value in ipairs(M.hydras) do
              local display = value.name
              if M.get_current().name == value.name then
                display = string.format("_h_   %s   _l_", value.name)
              end
              table.insert(modes, display)
            end
            return table.concat(modes, "  ")
          end,
        },
      },
      on_key = function()
        vim.wait(50)
      end,
    },
    heads = heads,
  })

  if opts.keymap and #opts.keymap > 0 then
    vim.keymap.set({ "n", "x" }, opts.keymap, function()
      M.switch_by_name({ name = opts.name }):activate()
    end, { desc = opts.name })
  end

  return new_hydra
end

return {
  "nvimtools/hydra.nvim",
  config = function()
    local gitsigns = require("gitsigns")

    local ts_queries = {
      { name = "Function", query = "@function.outer", keymap = "<leader>;f" },
      { name = "Class", query = "@class.outer", keymap = "<leader>;c" },
      { name = "Conditional", query = "@conditional.outer", keymap = "<leader>;i" },
      { name = "Comment", query = "@comment.outer", keymap = "<leader>;g" },
      { name = "Loop", query = "@loop.outer" },
      { name = "Parameter", query = "@parameter.outer" },
    }

    for _, value in ipairs(ts_queries) do
      table.insert(
        M.hydras,
        M.create_nav_hydra({
          name = value.name,
          keymap = value.keymap,
          heads = {
            {
              "j",
              function()
                vim.cmd.TSTextobjectGotoNextStart(value.query)
              end,
              { desc = "Next start", nowait = true },
            },
            {
              "k",
              function()
                vim.cmd.TSTextobjectGotoPreviousStart(value.query)
              end,
              { desc = "Previous start", nowait = true },
            },
            {
              "J",
              function()
                vim.cmd.TSTextobjectGotoNextEnd(value.query)
              end,
              { desc = "Next end", nowait = true },
            },
            {
              "K",
              function()
                vim.cmd.TSTextobjectGotoPreviousEnd(value.query)
              end,
              { desc = "Previous end", nowait = true },
            },
          },
        })
      )
    end

    -- diagnostics
    table.insert(
      M.hydras,
      M.create_nav_hydra({
        name = "Diagnostics",
        keymap = "<leader>;d",
        heads = {
          {
            "j",
            function()
              vim.diagnostic.goto_next()
            end,
            { desc = "Next", nowait = true },
          },
          {
            "k",
            function()
              vim.diagnostic.goto_prev()
            end,
            { desc = "Previous", nowait = true },
          },
          {
            "J",
            function()
              vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
            end,
            { desc = "Next", nowait = true },
          },
          {
            "K",
            function()
              vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
            end,
            { desc = "Previous", nowait = true },
          },
        },
      })
    )
    -- chunks
    table.insert(
      M.hydras,
      M.create_nav_hydra({
        name = "Chunks",
        heads = {
          {
            "j",
            function()
              if vim.wo.diff then
                return "]c"
              end
              gitsigns.next_hunk()
            end,
            { desc = "Next", nowait = true },
          },
          {
            "k",
            function()
              if vim.wo.diff then
                return "[c"
              end
              gitsigns.prev_hunk()
            end,
            { desc = "Previous", nowait = true },
          },
        },
      })
    )

    --buffers
    table.insert(
      M.hydras,
      M.create_nav_hydra({
        name = "Buffer",
        keymap = "<leader>;b",
        heads = {
          { "j", vim.cmd.bnext, { desc = "Next", nowait = true } },
          { "k", vim.cmd.bprev, { desc = "Previous", nowait = true } },
        },
      })
    )

    --quickfix
    table.insert(
      M.hydras,
      M.create_nav_hydra({
        name = "Quickfix",
        keymap = "<leader>;q",
        heads = {
          {
            "j",
            function()
              if #vim.fn.getqflist() == 0 then
                return
              end
              vim.cmd.cnext()
            end,
            { desc = "Next", nowait = true },
          },
          {
            "k",
            function()
              if #vim.fn.getqflist() == 0 then
                return
              end
              vim.cmd.cprev()
            end,
            { desc = "Previous", nowait = true },
          },
        },
      })
    )
    -- keymap
    vim.keymap.set({ "n", "x" }, "<leader>;", function()
      M.get_current():exit()
      M.get_current():activate()
    end, { desc = "Nav mode" })
  end,
}
