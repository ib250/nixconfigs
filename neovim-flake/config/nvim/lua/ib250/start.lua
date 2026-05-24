if vim.g.ib250_start then
  return
end

vim.g.ib250_start = true

require("vim._core.ui2").enable({})

-- which-key
require("which-key").setup({
  preset = "helix",
  spec = {
    { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
    { "<leader>d", group = "[D]ocument" },
    { "<leader>r", group = "[R]ename" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>w", group = "[W]orkspace" },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
  },
  icons = { mappings = false },
  -- annoyingly icons are defaulted in a number of places
  replace = {
    key = {
      function(key)
        return tostring(key)
        -- return require('which-key.view').format(key)
      end,
    },
  },
})

-- oil.nvim, guess-indent colors
require("oil").setup({
  default_file_explorer = true,
  view_options = { show_hidden = true },
  float = {
    padding = 2,
    max_width = 60,
    max_height = 30,
    border = "rounded",
  },
})

vim.keymap.set(
  "n",
  "-",
  "<CMD>Oil --float<CR>",
  { desc = "Open parent directory (float)" }
)
vim.keymap.set(
  "n",
  "<leader>-",
  "<CMD>Oil<CR>",
  { desc = "Open parent directory (full screen)" }
)

-- guess-indent
require("guess-indent").setup({})

-- comment
require("Comment").setup({})

require("nvim-treesitter").setup()

-- todo-comments
require("todo-comments").setup({})

-- origami
require("origami").setup({})

-- autocmds
require("ib250.autocmds.start")
