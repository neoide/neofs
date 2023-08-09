local ok, err = pcall(dofile, "spec/exec.lua")
if ok then
  vim.cmd[[0cq]]
else
  vim.cmd[[1cq]]
end
