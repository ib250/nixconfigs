local wk = require("which-key")

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
wk.register {
  ["<leader>f"] = { name = "+file" },
  ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
  ["<leader>f."] = { "<cmd>Telescope find_files cwd=%s<cr>", "Browse cwd" },
  ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  ["<leader>fg"] = { "<cmd>Telescope git_files<cr>", "Open Git File" },
}

-- buffers
wk.register {
  ["<leader>b"] = { name = "+buffers" },
  ["<leader>bl"] = { "<cmd>Telescope buffers<cr>", "Find File" },
  ["<leader>bn"] = { "<cmd>bnext<cr>", "Next Buffer" },
  ["<leader>bp"] = { "<cmd>bprevious<cr>", "Previous Buffer" },
}

-- git
wk.register {
  ["<leader>g"] = { name = "+git" },
  ["<leader>gS"] = { "<cmd>Telescope git_status<CR>", "Status" },
  ["<leader>gB"] = { "<cmd>Telescope git_branches<CR>", "Branches" },
  ["<leader>gC"] = { "<cmd>Telescope git_commits<CR>", "Commits" }
}

-- lsp
local lspsaga_diagnostics = require("lspsaga.diagnostic")
wk.register {
  ["K"] = { vim.lsp.buf.hover, "Lsp Hover doc" },
  ["<c-k>"] = { lspsaga_diagnostics.show_line_diagnostics, "Lsp Hover doc" },
}

wk.register {
  ["<leader>c"] = { name = "+code" },
  ["<leader>cr"] = { vim.lsp.buf.rename, "Rename" },
  ["<leader>ca"] = { vim.lsp.buf.code_action, "Code Action" },
  ["<leader>ct"] = { vim.lsp.buf.type_definition, "Jump to type" },
  ["<leader>cD"] = { vim.lsp.buf.declaration, "Jump to declaration" },
  ["<leader>cd"] = { vim.lsp.buf.defiinition, "Jump to definition" },
  ["<leader>cR"] = { vim.lsp.buf.references, "Jump to references" },
  ["<leader>ci"] = { vim.lsp.buf.implementation, "Jump to implementation" },
}

wk.register {
  ["<leader>d"] = { name = "+diagnostics" },
  ["<leader>dn"] = { vim.diagnostic.goto_next, "Jump to next" },
  ["<leader>dp"] = { vim.diagnostic.goto_prev, "Jump to next" },
  ["<leader>dl"] = { vim.diagnostic.setloclist, "Jump to next" },
}

local nlsb = require('null-ls.builtins')
vim.print(nlsb)
