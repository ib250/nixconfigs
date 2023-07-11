local wk = require("which-key")

wk.register({
  ["K"] = { vim.lsp.buf.hover, "Lsp Hover doc" },
})

wk.register({
  ["<leader>c"] = { name = "+code" },
  ["<leader>cR"] = { vim.lsp.buf.rename, "Rename" },
  ["<leader>ca"] = { vim.lsp.buf.code_action, "Code Action" },
  ["<leader>ct"] = { vim.lsp.buf.type_definition, "Jump to type" },
  ["<leader>cD"] = { vim.lsp.buf.declaration, "Jump to declaration" },
  ["<leader>cd"] = { vim.lsp.buf.definition, "Jump to definition" },
  ["<leader>cr"] = { vim.lsp.buf.references, "Jump to references" },
  ["<leader>ci"] = { vim.lsp.buf.implementation, "Jump to implementation" },
  ["<leader>cf"] = { vim.lsp.buf.format, "Format buffer" },
  -- peek_definition_code = { ["<leader>df"] = "@function.outer", ["<leader>dF"] = "@class.outer", },
  ["<leader>cp"] = { "<cmd>TSTextobjectPeekDefinitionCode @function.outer<cr>", "Peek function definition" },
  ["<leader>cP"] = { "<cmd>TSTextobjectPeekDefinitionCode @class.outer<cr>", "Peek class definition" },
})

wk.register({
  ["<leader>d"] = { name = "+diagnostics" },
  ["<leader>dn"] = { vim.diagnostic.goto_next, "Jump to next" },
  ["<leader>dp"] = { vim.diagnostic.goto_prev, "Jump to previous" },
  ["<leader>dl"] = { vim.diagnostic.setloclist, "Jump to next" },
})
