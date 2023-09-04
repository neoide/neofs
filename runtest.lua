local ok, err = pcall(dofile, "spec/exec.lua")
if ok then
  vim.cmd[[0cq]]
else
  print(err)
  vim.cmd[[1cq]]
end
