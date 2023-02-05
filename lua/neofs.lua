--- NeoFS plugin entry point
---
local cmds = require("neofs.cmds")
local conf = require("neofs.conf")

local function fail(...)
  error("configuration can be updated only once in function neofs.setup")
end

local function tbl_mkro(tab)
  for k, v in pairs(tab) do
    if type(v) == "table" then
      tab[k] = tbl_mkro(v)
    end
  end
  local proxy = {}
  setmetatable(proxy, {
    __index    = tab,
    __newindex = fail,
  })
  return proxy
end

local function tbl_merge(dst, src)
  for k, v in pairs(vim.tbl_deep_extend("force", dst, src)) do
    dst[k] = v
  end
end

local function init()
  vim.api.nvim_create_user_command("NeofsShow", cmds.show, {})
  vim.api.nvim_create_user_command("NeofsClose", cmds.close, {})
  vim.api.nvim_create_user_command("NeofsLocate", cmds.locate, {})
  vim.api.nvim_create_user_command("NeofsExpand", cmds.expand, {})
  vim.api.nvim_create_user_command("NeofsCollapse", cmds.collapse, {})
  vim.api.nvim_create_user_command("NeofsOpen", cmds.open, {})
  vim.api.nvim_create_user_command("NeofsTrash", cmds.trash, {})
  vim.api.nvim_create_user_command("NeofsRename", cmds.rename, {})
  vim.api.nvim_create_user_command("NeofsMkdir", cmds.mkdir, {})
  vim.api.nvim_create_user_command("NeofsMkfile", cmds.mkfile, {})
  vim.api.nvim_create_user_command("NeofsYank", cmds.yank, {})
  vim.api.nvim_create_user_command("NeofsMove", cmds.move, {})
end

local function setup(usrcfg)
  tbl_merge(conf, usrcfg)
  tbl_mkro(conf)
end

init()

return {
  setup = setup,
}
