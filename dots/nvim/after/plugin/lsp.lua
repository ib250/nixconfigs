require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd',
        -- 'denols',
        'gopls',
        'lua_ls',
        'pyright',
        'tsserver',
    }
})

local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = true,
})

lsp.nvim_workspace()
lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true
})

require("neodev").setup({
    library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true
    },
    setup_jsonls = true,
    override = function(root_dir, library)
        if string.find(root_dir, "/nvim") then
            library.enabled = true
            library.runtime = true
            library.types = true
            library.plugins = true
        end
    end,
    lspconfig = true,
    pathStrict = true
})
