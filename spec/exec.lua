NEWCWD = "/tmp/neofs"
OLDCWD = vim.fn.getcwd()

function getfixture(path)
  return dofile(OLDCWD .. "/spec/.data/" .. path .. ".lua")
end

require("busted.runner"){ standalone = false }
