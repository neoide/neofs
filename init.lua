vim.opt.swapfile = false

vim.opt.rtp = {
  vim.fn.getcwd(),
  vim.env.VIMRUNTIME,
}

vim.cmd([[
  filetype on
  runtime lua/neofs/init.lua
]])
