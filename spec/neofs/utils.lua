local dir = require("pl.dir")
local file = require("pl.file")
local path = require("pl.path")

local function mkfsreq(root, spec)
  local ok, err = dir.makepath(root)
  if not ok then
    error("failed to create directory: " .. err)
  end
  for k, v in pairs(spec) do
    local type = type(v)
    local name = path.join(root, k)
    if type == "table" then
      mkfsreq(name, v)
    elseif type == "string" then
      file.write(name, v)
    else
      error("unexpected type " .. type)
    end
  end
end

local function mkfs(root)
  -- TODO: avoid recursion
  mkfsreq(root, getfixture("fs"))
end

local function rmfs(root)
  local ok, err = dir.rmtree(root)
  if not ok then
    error("failed to remove directory: " .. err)
  end
end

return {
  mkfs = mkfs,
  rmfs = rmfs,
}
