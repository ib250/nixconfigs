vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("gitsigns.nvim")

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  current_line_blame = false,
  current_line_blame_opts = {
    ignore_whitespace = true,
  },
  on_attach = function()
    vim.keymap.set(
      "n",
      "<leader>gbl",
      require("gitsigns").blame_line,
      { desc = "[G]itsigns [b]lame [l]line" }
    )
  end,
})
