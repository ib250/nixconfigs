require("nlspsettings").setup {
    config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
    local_settings_dir = ".nvim",
    local_settings_root_markers_fallback = { ".git" },
    append_default_schemas = true,
    loader = "json"
}

require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd',
        'denols',
        'gopls',
        'lua_ls',
        'pyright',
        'tsserver',
        'jsonls',
        'taplo'
    },
})

local lsp = require('lsp-zero').preset({
    name = "recommended",
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})

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

        local is_nvim_related = function(path)
            return (
                string.match(path, ".*/nvim/.*") or
                string.match(path, ".*/.nvim.lua$") or
                string.match(path, ".*/.vim/.*$") or
                string.match(path, ".*/.nvim/.*$")
            )
        end

        if is_nvim_related(root_dir) then
            library.enabled = true
            library.runtime = true
            library.types = true
            library.plugins = true
        end
    end,
    lspconfig = true,
    pathStrict = true
})

lsp.setup()

return {
    run_make = function(opts)
        for key, value in pairs(opts) do
            print(key, value)
        end
    end
}
