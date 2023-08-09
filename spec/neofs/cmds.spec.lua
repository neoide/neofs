local os = require("os")
local utils = require("spec.neofs.utils")

describe("neofs commands", function()
  -- describe("view directory tree", function()
  --   local newcwd = "/tmp/neofs"
  --   local oldcwd = vim.fn.getcwd()

  --   setup(function()
  --     tfs.mkfs(newcwd)
  --     vim.cmd("cd " .. newcwd)
  --   end)

  --   teardown(function()
  --     vim.cmd("cd " .. oldcwd)
  --     tfs.rmfs(newcwd)
  --   end)

  --   it("displays directory content when open", function()
  --     print(vim.inspect(vim))
  --     vim.cmd("NeofsShow")
  --   end)

  --   it("expands child directory", function()
  --   end)

  --   it("collaspes parent directory", function()
  --   end)
  -- end)
end)
