if vim.g.ib250_opt
then
  return
end

vim.g.ib250_opt = true

require("ib250.opt.lsp")
require("ib250.opt.git")

require("ib250.autocmds.opt")
