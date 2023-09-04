local dir = require "pl.dir"
local file = require "pl.file"
local path = require "pl.path"

local function mkfsreq(root, spec)
  local ok, err = dir.makepath(root)
  if not ok then
    error("failed to create directory: " .. err)
  end
  for k, v in pairs(spec or {}) do
    local type = type(v)
    if type == "table" then
      mkfsreq(path.join(root, k), v)
    elseif type == "string" then
      file.write(path.join(root, v), "content-" .. v)
    else
      error("unexpected type " .. type)
    end
  end
end

local M = {}

M.NEWCWD = "/tmp/neofs"
M.OLDCWD = vim.fn.getcwd()

M.mkfs = function(root, data)
  mkfsreq(root, data)
end

M.rmfs = function(root)
  local ok, err = dir.rmtree(root)
  if not ok then
    error("failed to remove directory: " .. err)
  end
end

M.pushd = function()
  M.mkfs(M.NEWCWD)
  vim.cmd("cd " .. M.NEWCWD)
end

M.popd = function()
  vim.cmd("cd " .. M.OLDCWD)
  utils.rmfs(M.NEWCWD)
end

return M
