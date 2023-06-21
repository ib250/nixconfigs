{ pkgs, ... }: {

  home.packages = with (import ./modules/basics.nix { inherit pkgs; });
    homePackages;
  programs.home-manager = { enable = true; };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      disable_stdin = false;
      strict_env = true;
    };
  };

  programs.git = {
    extraConfig = {
      user.name = "Ismail Bello";
      credential.helper = "store";
      core.excludesfile = "$XDG_CONFIG_HOME/git/gitignore.global";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    includes = [{ path = "~/.gitconfig"; }];
  };

  programs.scmpuff.enable = true;
  programs.zoxide.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.helix = { enable = true; };

  home.stateVersion = "23.05";
  home.username = "ismailbello";
  home.homeDirectory = "/Users/ismailbello";

  nixpkgs.config = import ./modules/nixpkgs-config.nix { inherit pkgs; };

  xdg.configFile."git/gitignore.global".text = ''
    *~
    *.swp
    .vim
    .nvim
    scratch
    .scratch
    scratch.*
    .roast
    .http
    .DS_Store
  '';

  xdg.configFile."joshuto" = {
    source = ./dots/joshuto;
    recursive = true;
  };

  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
      allow-import-from-derivation = true
    '';
  };

  programs.nixvim = {
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

    # extraPlugins = [
    #   pkgs.vimPlugins.nvim-lsputils
    #   pkgs.vimPlugins.popfix
    # ];
    #
    # extraConfigLuaPost = ''
    #   -- nvim-lsputils
    #   if vim.fn.has('nvim-0.5.1') == 1 then
    #       vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
    #       vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
    #       vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
    #       vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
    #       vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
    #       vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
    #       vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
    #       vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
    #   else
    #       local bufnr = vim.api.nvim_buf_get_number(0)
    #
    #       vim.lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
    #           require('lsputil.codeAction').code_action_handler(nil, actions, nil, nil, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/references'] = function(_, _, result)
    #           require('lsputil.locations').references_handler(nil, result, { bufnr = bufnr }, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/definition'] = function(_, method, result)
    #           require('lsputil.locations').definition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/declaration'] = function(_, method, result)
    #           require('lsputil.locations').declaration_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/typeDefinition'] = function(_, method, result)
    #           require('lsputil.locations').typeDefinition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/implementation'] = function(_, method, result)
    #           require('lsputil.locations').implementation_handler(nil, result, { bufnr = bufnr, method = method }, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/documentSymbol'] = function(_, _, result, _, bufn)
    #           require('lsputil.symbols').document_handler(nil, result, { bufnr = bufn }, nil)
    #       end
    #
    #       vim.lsp.handlers['textDocument/symbol'] = function(_, _, result, _, bufn)
    #           require('lsputil.symbols').workspace_handler(nil, result, { bufnr = bufn }, nil)
    #       end
    #     end
    # '';

    extraPackages = with (import ./modules/devtools.nix { inherit pkgs; });
      allDevtools;
  };

  programs.bat = {
    enable = true;
    config = { theme = "ansi"; };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      gcloud = { format = "on [$symbol$account(@$domain/$project)]($style)"; };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    autocd = true;
    shellAliases = {
      c = "clear";
      ls = "exa";
      l = "exa -l";
      ll = "exa -lah";
      q = "exit";
      tree = "exa -T";
      d = "dirs -v";
      cat = "bat";
      gc = "git commit";
      ga = "git add";
      gb = "git branch";
      gf = "git fetch";
      gps = "git push";
      gm = "git merge";
      gpl = "git pull";
      gsh = "git show";
      ranger = "joshuto";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "mafredri/zsh-async"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "zdharma/fast-syntax-highlighting"; }
      ];
    };

    initExtraBeforeCompInit = ''
      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode
    '';

    initExtra = let inherit (import ./modules { inherit pkgs; }) utils;
    in ''
      ${utils.sourceWhenAvaliable [ "~/.smoke" "~/.nvm/nvm.sh" ]}

      # not yet supported in hm module
      zplug "plugins/docker", from:oh-my-zsh
      zplug "plugins/docker-compose", from:oh-my-zsh
      zplug install 2> /dev/null
      zplug load

    '';
  };

}
