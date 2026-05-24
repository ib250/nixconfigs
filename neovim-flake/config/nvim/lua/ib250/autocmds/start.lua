vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd.packadd("nvim.undotree")
    vim.cmd [[:silent GuessIndent]]
    vim.cmd.colorscheme("rose-pine")
  end,
})

-- some ui autocmds I am used to
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { ".envrc" },
  callback = function()
    vim.cmd.setfiletype("sh")
  end,
})
