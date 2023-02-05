local const = require("neofs.const")
local conf = require("neofs.conf")
local tree = require("neofs.tree")
local fs = require("neofs.fs")
local utils = require("spec.neofs.utils")

describe("neofs.state", function()
  it("returns default state first time", function()
    assert.are.same(tree.default, tree.get(1))
  end)

  it("returns exisitng state second time", function()
    local winid = 1
    local neofs = tree.get(winid)
    neofs.entries = { 1, 2, 3 }
    assert.are.same(neofs, tree.get(winid))
  end)

  it("returns different state for new winid", function()
    assert.are.not_same(tree.default, tree.get(1))
    assert.are.same(tree.default, tree.get(2))
  end)

  local filter = function(name)
    return false
  end

  local read = function(entry)
    return { name = entry.name, type = entry.type, level = entry.level }
  end

  describe("expands/collapse directory", function()
    local state = tree.get(1)
    local fixture = getfixture("neofs.tree.expandcollapse")

    setup(function()
      utils.mkfs(NEWCWD)
      vim.cmd("cd " .. NEWCWD)
      state.entries = fs.scandir(const.ROOT_LEVEL, NEWCWD, state.expanded, filter)
    end)

    teardown(function()
      vim.cmd("cd " .. OLDCWD)
      utils.rmfs(NEWCWD)
    end)

    local scan = function(entry, state, filter)
      local entries = fs.scandir(entry.level + 1, entry.path, state.expanded, filter)
      table.sort(entries, conf.tree.order)
      return entries
    end

    it("has initial state", function()
      assert.are.same(fixture.step_0.expanded, state.expanded)
      assert.are.same(fixture.step_0.entries, vim.tbl_map(read, state.entries))
    end)

    it("expands dir_1", function()
      local line = 1
      local root = state.entries[line]
      state:expand(line, scan(root, state, filter))
      assert.are.same(fixture.step_1.entries, vim.tbl_map(read, state.entries))
      assert.are.same(fixture.step_1.expanded, state.expanded)
    end)

    it("expands dir_2", function()
      local line = 4
      local root = state.entries[line]
      state:expand(line, scan(root, state, filter))
      assert.are.same(fixture.step_2.entries, vim.tbl_map(read, state.entries))
      assert.are.same(fixture.step_2.expanded, state.expanded)
    end)

    it("expands dir_1_1", function()
      local line = 2
      local root = state.entries[line]
      state:expand(line, scan(root, state, filter))
      assert.are.same(fixture.step_3.entries, vim.tbl_map(read, state.entries))
      assert.are.same(fixture.step_3.expanded, state.expanded)
    end)

    it("expands dir_4", function()
      local line = 17
      local root = state.entries[line]
      state:expand(line, scan(root, state, filter))
      assert.are.same(fixture.step_4.entries, vim.tbl_map(read, state.entries))
      assert.are.same(fixture.step_4.expanded, state.expanded)
    end)

    it("expands dir_4_1", function()
      local line = 18
      local root = state.entries[line]
      state:expand(line, scan(root, state, filter))
      assert.are.same(fixture.step_5.entries, vim.tbl_map(read, state.entries))
      assert.are.same(fixture.step_5.expanded, state.expanded)
    end)

    -- TODO: remove this function
    local dbg = function()
      local entries = vim.tbl_map(function(e) return e.name end, state.entries)
      for k ,v in ipairs(entries) do
        print(k, v)
      end
    end

    it("collapses dir_4", function()
      local line = 17
      local collapsed = state:collapse(line)
      assert.are.same(fixture.step_6.collapsed, collapsed)
      assert.are.same(fixture.step_6.expanded, state.expanded)
      assert.are.same(fixture.step_6.entries, vim.tbl_map(read, state.entries))
    end)

    it("expands dir_4", function()
      local line = 17
      local root = state.entries[line]
      state:expand(line, scan(root, state, filter))
      assert.are.same(fixture.step_7.entries, vim.tbl_map(read, state.entries))
      assert.are.same(fixture.step_7.expanded, state.expanded)
    end)

    it("collapses dir_4_1", function()
      local line = 18
      local collapsed = state:collapse(line)
      assert.are.same(fixture.step_8.collapsed, collapsed)
      assert.are.same(fixture.step_8.expanded, state.expanded)
      assert.are.same(fixture.step_8.entries, vim.tbl_map(read, state.entries))
    end)

    it("collapses dir_2", function()
      local line = 8
      local collapsed = state:collapse(line)
      assert.are.same(fixture.step_9.collapsed, collapsed)
      assert.are.same(fixture.step_9.expanded, state.expanded)
      assert.are.same(fixture.step_9.entries, vim.tbl_map(read, state.entries))
    end)

    it("collapses dir_4", function()
      local line = 10
      local collapsed = state:collapse(line)
      assert.are.same(fixture.step_10.collapsed, collapsed)
      assert.are.same(fixture.step_10.expanded, state.expanded)
      assert.are.same(fixture.step_10.entries, vim.tbl_map(read, state.entries))
    end)

    it("collapses dir_1_1", function()
      local line = 2
      local collapsed = state:collapse(line)
      assert.are.same(fixture.step_11.collapsed, collapsed)
      assert.are.same(fixture.step_11.expanded, state.expanded)
      assert.are.same(fixture.step_11.entries, vim.tbl_map(read, state.entries))
    end)

    it("collapses dir_1", function()
      local line = 1
      local collapsed = state:collapse(line)
      assert.are.same(fixture.step_12.collapsed, collapsed)
      assert.are.same(fixture.step_12.expanded, state.expanded)
      assert.are.same(fixture.step_12.entries, vim.tbl_map(read, state.entries))
    end)
  end)
end)
