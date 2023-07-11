local tb = require("telescope.builtin")
local wk = require("which-key")

-- lsp + ts
local ts = require("nvim-treesitter.configs")
ts.setup({
  textobjects = {
    lsp_interop = {
      enable = true,
      border = "none",
      floating_preview_opts = {},
    },
  },
})

-- muscle memory things...
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")
vim.keymap.set("c", "jk", "<ESC>")
vim.keymap.set("c", "kj", "<ESC>")
vim.keymap.set("v", "jk", "<ESC>")
vim.keymap.set("v", "kj", "<ESC>")
vim.keymap.set("n", "<c-p>", "<cmd>Telescope<cr>")
vim.keymap.set("n", "qq", "<ESC>")
vim.keymap.set("n", "<leader> ", "<cmd>noh<cr>")

-- files
wk.register({
  ["<leader>f"] = { name = "+file" },
  ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
  ["<leader>f."] = { "<cmd>Telescope find_files cwd=%s<cr>", "Browse cwd" },
  ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  ["<leader>fg"] = { "<cmd>Telescope git_files<cr>", "Open Git File" },
  ["<C-f>"] = {
    function()
      if pcall(tb.git_files) then
        return
      end
      tb.find_files()
    end,
    "Smart Find files",
  },
})

-- buffers
wk.register({
  ["<leader>b"] = { name = "+buffers" },
  ["<leader>bl"] = { "<cmd>Telescope buffers<cr>", "Find File" },
  ["<leader>bn"] = { "<cmd>bnext<cr>", "Next Buffer" },
  ["<leader>bp"] = { "<cmd>bprevious<cr>", "Previous Buffer" },
  ["<C-b>"] = { tb.buffers, "Browse buffers" },
})

-- git
wk.register({
  ["<leader>g"] = { name = "+git" },
  ["<leader>gS"] = { "<cmd>Telescope git_status<CR>", "Status" },
  ["<leader>gB"] = { "<cmd>Telescope git_branches<CR>", "Branches" },
  ["<leader>gC"] = { "<cmd>Telescope git_commits<CR>", "Commits" },
})

