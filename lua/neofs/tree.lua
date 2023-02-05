--- Plugin state persistence
---
local fs = require("neofs.fs")
local conf = require("neofs.conf")

local Tree = {}
Tree.__index = Tree

function Tree:new()
  local default = {
    entries  = {},
    expanded = {},
    isopen   = false,
  }
  return setmetatable(default, Tree)
end

--- (int, list[entry) -> void
function Tree:expand(index, children)
  -- TODO: check index
  -- TODO: check type
  local entries = {}
  for i = 1, index do
    entries[i] = self.entries[i]
  end

  for i = 1, #children do
    entries[index + i] = children[i]
  end

  for i = index + 1, #self.entries do
    entries[#entries + 1] = self.entries[i]
  end

  self.expanded[self.entries[index].path] = true
  self.entries = entries
end

--- (int) -> int
function Tree:collapse(index)
  -- TODO: check index
  -- TODO: check type
  local entries = {}
  for i = 1, index do
    entries[i] = self.entries[i]
  end

  local level = self.entries[index].level

  local collapsed = 0
  for i = index + 1, #self.entries do
    if self.entries[i].level <= level then
      break
    end
    collapsed = collapsed + 1
  end

  for i = index + 1 + collapsed, #self.entries do
    entries[#entries + 1] = self.entries[i]
  end

  self.expanded[self.entries[index].path] = nil
  self.entries = entries

  return collapsed
end

function Tree:addfile(index, name)
  error("not implemented")
end

function Tree:adddir(index, name)
  error("not implemented")
end

function Tree:rename(index, name)
  error("not implemented")
end

function Tree:trash(index, name)
  error("not implemented")
end

local states = {}

local function get(winid)
  local result = states[winid]
  if not result then
    result = Tree:new()
    states[winid] = result
  end
  return result
end

return {
  default = Tree.new(),
  get     = get,
}
