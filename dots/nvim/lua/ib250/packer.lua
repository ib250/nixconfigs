vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
        -- use 'wbthomasson/packer.nvim' managed with hm
        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.0',
            requires = {
                {'nvim-lua/plenary.nvim'}
            }
        }
        use {
            'nvim-telescope/telescope-file-browser.nvim',
            requires = {
                'nvim-telescope/telescope.nvim',
                'nvim-lua/plenary.nvim'
            }
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ":TSUpdate"
        }
        use "nvim-treesitter/playground"
        use "lewis6991/spellsitter.nvim"
        use "tpope/vim-fugitive"
        use {
            "rose-pine/neovim",
            as = "rose-pine"
        }
        use {
            "VonHeikemen/lsp-zero.nvim",
            branch = "v1.x",
            requires = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},
                {'williamboman/mason.nvim'},
                {'williamboman/mason-lspconfig.nvim'},

                -- Autocompletion
                {'hrsh7th/nvim-cmp'},
                {'hrsh7th/cmp-buffer'},
                {'hrsh7th/cmp-path'},
                {'saadparwaiz1/cmp_luasnip'},
                {'hrsh7th/cmp-nvim-lsp'},
                {'hrsh7th/cmp-nvim-lua'},

                -- Snippets
                {'L3MON4D3/LuaSnip'},
                {'rafamadriz/friendly-snippets'},

                -- local lsp setup
                {'tamago324/nlsp-settings.nvim'}

            }
        }
        use {
            "folke/trouble.nvim",
            config = function()
                require("trouble").setup {
                    icons = false,
                    fold_open = "-",
                    fold_closed = "+",
                    indent_lines = true,
                    signs = {
                        error = "error",
                        warning = "warning",
                        hint = "hint",
                        infomation = "info"
                    }
                }
            end
        }
        use {
            'scalameta/nvim-metals',
            requires = {
                { 'nvim-lua/plenary.nvim' }
            }
        }
        use "folke/neodev.nvim"
        use {
            "folke/zen-mode.nvim",
            config = function ()
                require("zen-mode").setup {}
            end
        }

    end
)
