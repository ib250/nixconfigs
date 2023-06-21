{ pkgs, ... }: {
  enable = true;
  globals.mapleader = ";";
  options = {
    relativenumber = true;
    foldminlines = 2;
  };

  colorschemes.nord.enable = true;

  plugins.nvim-cmp.enable = true;
  plugins.nvim-cmp.mappingPresets = [ "insert" "cmdline" ];
  plugins.cmp-buffer.enable = true;
  plugins.cmp-calc.enable = true;
  plugins.cmp-clippy.enable = true;
  plugins.cmp-cmdline.enable = true;
  plugins.cmp-cmdline-history.enable = true;
  plugins.cmp-conventionalcommits.enable = true;
  plugins.cmp-dap.enable = true;
  plugins.cmp-dictionary.enable = true;
  plugins.cmp-fuzzy-buffer.enable = true;
  plugins.cmp-fuzzy-path.enable = true;
  plugins.cmp-git.enable = true;
  plugins.cmp-look.enable = true;
  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-nvim-lsp-document-symbol.enable = true;
  plugins.cmp-nvim-lsp-signature-help.enable = true;
  plugins.cmp-nvim-lua.enable = true;
  plugins.cmp-nvim-ultisnips.enable = true;
  plugins.cmp-omni.enable = true;
  plugins.cmp-pandoc-nvim.enable = true;
  plugins.cmp-pandoc-references.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-rg.enable = true;
  plugins.cmp-snippy.enable = true;
  plugins.cmp-spell.enable = true;
  plugins.cmp-treesitter.enable = true;
  plugins.cmp-vim-lsp.enable = true;
  plugins.cmp-vsnip.enable = true;
  plugins.cmp-zsh.enable = true;
  plugins.cmp_luasnip.enable = true;
  plugins.comment-nvim.enable = true;
  plugins.treesitter.enable = true;
  plugins.treesitter.folding = true;
  plugins.treesitter.indent = true;
  plugins.treesitter-refactor.enable = true;
  plugins.which-key.enable = true;
  plugins.lsp.enable = true;
  plugins.lsp.servers.pyright.enable = true;
  plugins.lsp.servers.bashls.enable = true;
  plugins.lsp.servers.clangd.enable = true;
  plugins.lsp.servers.gopls.enable = true;
  plugins.lsp.servers.jsonls.enable = true;
  plugins.lsp.servers.lua-ls.enable = true;
  plugins.lsp.servers.metals.enable = true;
  plugins.lsp.servers.nil_ls.enable = true;
  plugins.lsp.servers.rnix-lsp.enable = true;
  plugins.lsp.servers.ruff-lsp.enable = true;
  plugins.lsp.servers.rust-analyzer.enable = true;
  plugins.lsp.servers.tsserver.enable = true;
  plugins.lsp.servers.yamlls.enable = true;
  plugins.lsp-format.enable = true;
  plugins.lsp-lines.enable = true;
  plugins.lspsaga.enable = true;

  plugins.telescope.enable = true;
  plugins.telescope.extensions.fzf-native.enable = true;
  plugins.rust-tools.enable = true;

  extraPackages = with (import ./devtools.nix { inherit pkgs; }); allDevtools;
}
