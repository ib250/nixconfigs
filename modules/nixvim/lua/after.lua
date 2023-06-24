local tb = require("telescope.builtin")
local wk = require("which-key")

-- lsp defaults
local lsp_defaults = function()
  if vim.fn.has("nvim-0.5.1") == 1 then
    vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
    vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
    vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
    vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
    vim.lsp.handlers["textDocument/typeDefinition"] =
        require("lsputil.locations").typeDefinition_handler
    vim.lsp.handlers["textDocument/implementation"] =
        require("lsputil.locations").implementation_handler
    vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
    vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
    return
  else
    local bufnr = vim.api.nvim_buf_get_number(0)

    vim.lsp.handlers["textDocument/codeAction"] = function(_, _, actions)
      require("lsputil.codeAction").code_action_handler(nil, actions, nil, nil, nil)
    end

    vim.lsp.handlers["textDocument/references"] = function(_, _, result)
      require("lsputil.locations").references_handler(nil, result, { bufnr = bufnr }, nil)
    end

    vim.lsp.handlers["textDocument/definition"] = function(_, method, result)
      require("lsputil.locations").definition_handler(
        nil,
        result,
        { bufnr = bufnr, method = method },
        nil
      )
    end

    vim.lsp.handlers["textDocument/declaration"] = function(_, method, result)
      require("lsputil.locations").declaration_handler(
        nil,
        result,
        { bufnr = bufnr, method = method },
        nil
      )
    end

    vim.lsp.handlers["textDocument/typeDefinition"] = function(_, method, result)
      require("lsputil.locations").typeDefinition_handler(
        nil,
        result,
        { bufnr = bufnr, method = method },
        nil
      )
    end

    vim.lsp.handlers["textDocument/implementation"] = function(_, method, result)
      require("lsputil.locations").implementation_handler(
        nil,
        result,
        { bufnr = bufnr, method = method },
        nil
      )
    end

    vim.lsp.handlers["textDocument/documentSymbol"] = function(_, _, result, _, bufn)
      require("lsputil.symbols").document_handler(nil, result, { bufnr = bufn }, nil)
    end

    vim.lsp.handlers["textDocument/symbol"] = function(_, _, result, _, bufn)
      require("lsputil.symbols").workspace_handler(nil, result, { bufnr = bufn }, nil)
    end
  end
end

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

lsp_defaults()
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

-- lsp
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
})

wk.register({
  ["<leader>d"] = { name = "+diagnostics" },
  ["<leader>dn"] = { vim.diagnostic.goto_next, "Jump to next" },
  ["<leader>dp"] = { vim.diagnostic.goto_prev, "Jump to next" },
  ["<leader>dl"] = { vim.diagnostic.setloclist, "Jump to next" },
})
