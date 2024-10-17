local M = {}
---@type table<string, Hydra> hydra
M.hydras = {}
---@type number|nil # Current hydra
M.current_idx = 1

---Get current hydra
---@return Hydra current
function M.get_current()
  return M.hydras[M.current_idx]
end

---Get hydra from offset. Wraps around
---@param opts { offset: number, dry_run?: boolean }
---@return Hydra current
function M.cycle(opts)
  if #M.hydras == 0 then
    error("No navigation hydras", vim.log.levels.ERROR)
  end

  --wrap around if required
  local new_idx = (M.current_idx + opts.offset - 1) % #M.hydras + 1

  if opts.dry_run ~= true then
    M.current_idx = new_idx
  end

  return M.hydras[new_idx]
end

---Create text object query heads for hydra
---@param query string
---@return { prev: fun(), next: fun()}
function M.create_textobject_heads(query)
  return {
    prev = function()
      vim.cmd.TSTextobjectGotoPreviousStart(query)
    end,
    next = function()
      vim.cmd.TSTextobjectGotoNextStart(query)
    end,
  }
end

return {
  "nvimtools/hydra.nvim",
  config = function()
    local Hydra = require("hydra")

    ---@class NavHydra
    ---@field name string
    ---@field heads table<string,hydra.Head>

    ---@param opts NavHydra
    ---@return Hydra
    function M.create_nav_hydra(opts)
      --default heads
      ---@type table<string, hydra.Head>
      local heads = {
        {
          "h",
          function()
            M.cycle({ offset = -1 })
            M.get_current():activate()
          end,
          { exit = true, desc = "Previous mode" },
        },
        {
          "l",
          function()
            M.cycle({ offset = 1 })
            M.get_current():activate()
          end,
          { exit = true, desc = "Next move" },
        },
      }
      --insert user heads
      for _, head in ipairs(opts.heads) do
        table.insert(heads, head)
      end

      local hint = [[ %{get_hint} ]]
      return Hydra({
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
    end

    local gitsigns = require("gitsigns")

    local ts_queries = {
      { name = "Functions", query = "@function.outer" },
      { name = "Classes", query = "@class.outer" },
      { name = "Conditional", query = "@conditional.outer" },
      { name = "Comments", query = "@comment.outer" },
      { name = "Loop", query = "@loop.outer" },
      { name = "Parameter", query = "@parameter.outer" },
    }

    for _, value in ipairs(ts_queries) do
      table.insert(
        M.hydras,
        M.create_nav_hydra({
          name = value.name,
          heads = {
            {
              "j",
              function()
                vim.cmd.TSTextobjectGotoNextStart(value.query)
              end,
              { desc = "Next start" },
            },
            {
              "k",
              function()
                vim.cmd.TSTextobjectGotoPreviousStart(value.query)
              end,
              { desc = "Previous start" },
            },
            {
              "J",
              function()
                vim.cmd.TSTextobjectGotoNextEnd(value.query)
              end,
              { desc = "Next end" },
            },
            {
              "K",
              function()
                vim.cmd.TSTextobjectGotoPreviousEnd(value.query)
              end,
              { desc = "Previous end" },
            },
          },
        })
      )
    end

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
            { desc = "Next" },
          },
          {
            "k",
            function()
              if vim.wo.diff then
                return "[c"
              end
              gitsigns.prev_hunk()
            end,
            { desc = "Previous" },
          },
        },
      })
    )

    --buffers
    table.insert(
      M.hydras,
      M.create_nav_hydra({
        name = "Buffers",
        heads = {
          { "j", vim.cmd.bnext, { desc = "Next" } },
          { "k", vim.cmd.bprev, { desc = "Previous" } },
        },
      })
    )

    --quickfix
    table.insert(
      M.hydras,
      M.create_nav_hydra({
        name = "Quickfix",
        heads = {
          {
            "j",
            function()
              if #vim.fn.getqflist() == 0 then
                return
              end
              vim.cmd.cnext()
            end,
            { desc = "Next" },
          },
          {
            "k",
            function()
              if #vim.fn.getqflist() == 0 then
                return
              end
              vim.cmd.cprev()
            end,
            { desc = "Previous" },
          },
        },
      })
    )

    -- keymap
    vim.keymap.set({ "n", "x" }, "<leader>;", function()
      M.get_current():activate()
    end)
  end,
}
