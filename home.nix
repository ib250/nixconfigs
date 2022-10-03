{ pkgs, lib, ... }:
let

  packages = import ./packages pkgs;

  devTools = packages.devTools;

  # programs.neovim manages its own install of neovim so no need here
  homePackages = with lib;
    filter (drv: !(hasInfix "neovim" drv.name))
    packages.basics;

in rec {

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.config = {
    disable_stdin = false;
    bash_path = "${pkgs.bashInteractive}/bin/bash";
    strict_env = true;
  };

  home.stateVersion = "22.05";
  home.username = "ismailbello";
  home.homeDirectory = "/Users/ismailbello";

  nixpkgs.config = packages.nixpkgs-config;

  xdg.configFile."nixpkgs/config.nix".source =
    ./packages/nixpkgs-config.nix;

  xdg.configFile."nixpkgs/overlays.nix".source =
    ./packages/overlays.nix;

  xdg.configFile."git/gitignore.global".text = ''
    *~
    *.swp
    .vim
    scratch
    .scratch
    scratch.*
    .roast
    .http
    .DS_Store
  '';

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home.packages = with builtins;
    concatLists [
      homePackages
      devTools.js
      devTools.c-family
      devTools.nix
      #devTools.haskell
      devTools.jvm-family
      devTools.python
      devTools.ts
      devTools.terraform
      [ packages.lsps.package ]
    ];

  home.file = with packages.utils;
    vimPluginUtils.install {
      pluginManager = "vim-plug";
      version = "master";
    } {

      ".config/nvim/coc-settings.json".source =
        packages.lsps.mkCocConfigJson {
          extraConfig = {
            "cSpell.language" = "en-GB";
            "explorer.width" = 30;
            "explorer.previewAction.onHover" = true;
          };
        };
    };

  programs.neovim = {
    # nvim 0.5.0
    package =
      (import <nixpkgs-unstable> { }).neovim-unwrapped;
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = ps:
      with ps; [
        pynvim
        # the following are needed for roast.vim
        requests
        jinja2
      ];

    extraConfig = with packages.utils;
      vimPluginUtils.vimPlugRc {
        pluginInstallDir = "~/.config/vim-plug";
        extraRc = builtins.readFile ./packages/minimal.vim;
        plugins = [
          { plugin = "preservim/nerdcommenter"; }
          { plugin = "tpope/vim-surround"; }
          { plugin = "tpope/vim-repeat"; }
          { plugin = "kien/rainbow_parentheses.vim"; }
          {
            plugin = "junegunn/fzf";
            onLoad = ''
              {'dir': '~/.fzf','do': './install.sh --all'}
            '';
          }
          {
            plugin = "junegunn/fzf.vim";
            config = ''
              let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
            '';
          }
          {
            # not available via coc-install unfortunately
            plugin = "antoinemadec/coc-fzf";
            config = ''
              " mappings
              nnoremap <silent> <space><space> :<C-u>CocFzfList<CR>
              nmap <silent> gd <Plug>(coc-definition)
              nmap <silent> gy <Plug>(coc-type-definition)
              nmap <silent> gi <Plug>(coc-implementation)
              nmap <silent> gr <Plug>(coc-references)
            '';
          }
          {
            plugin = "sheerun/vim-polyglot";
            config = ''
              " terraform
              let g:terraform_align=1
              let g:terraform_fold_sections=1
            '';
          }
          { plugin = "elmcast/elm-vim"; }
          { plugin = "aklt/plantuml-syntax"; }
          { plugin = "leafgarland/typescript-vim"; }
          { plugin = "derekwyatt/vim-scala"; }
          { plugin = "jidn/vim-dbml"; }
          {
            plugin = "iamcco/markdown-preview.nvim";
            onLoad = ''
              {'do': 'cd app && yarn install'}
            '';
            config = ''
              let g:mkdp_auto_start = 0
              let g:mkdp_auto_close = 0
              let g:mkdp_command_for_global = 1
            '';
          }
          (let
            coc-install-plugins = [
              "CocInstall"
              "coc-json"
              "coc-format-json"
              "coc-pyright"
              "coc-tsserver"
              "coc-marketplace"
              "coc-spell-checker"
              "coc-denoland"
              "coc-explorer"
              "coc-html"
              "coc-sql"
              "coc-go"
              "coc-git"
              "coc-metals"
            ];
          in {
            plugin = "neoclide/coc.nvim";
            onLoad = "{'branch': 'release'}";
            config = ''
              set hidden
              set nobackup
              set nowritebackup
              set cmdheight=1
              set updatetime=300
              set shortmess+=c
              set signcolumn=auto

              function g:InstallIde()
                PlugInstall
                ${
                  builtins.concatStringsSep " "
                  coc-install-plugins
                }
              endfunction

              function g:UpdateIde()
                PlugUpdate
                CocUpdate
              endfunction

              nnoremap <C-n> :CocCommand explorer<CR>

              augroup coc_vimrc_filetype_jsx_support
                au!
                autocmd BufEnter *.jsx :setlocal filetype=javascript.jsx
                autocmd BufEnter *.tsx :setlocal filetype=typescript.tsx
              augroup end

              inoremap <silent><expr> <c-space> coc#refresh()
              inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
              set statusline^=%{get(g:,'coc_git_status',\'\')}%{get(b:,'coc_git_status',\'\')}%{get(b:,'coc_git_blame',\'\')}

              nnoremap <leader>gbl :CocCommand git.showBlameDoc<CR>
            '';
          })
          { plugin = "sharat87/roast.vim"; }
          { plugin = "diepm/vim-rest-console"; }
          {
            plugin = "ctrlpvim/ctrlp.vim";
            config = ''
              let g:ctrlp_cmd = 'CtrlPMRU'
            '';
          }
          {
            plugin = "NLKNguyen/papercolor-theme";
            config = ''
              set t_Co=256
              set background=dark
              let g:PaperColor_Theme_Options = {
              \   'theme': {
              \     'default': {
              \       'transparent_background': 1
              \     }
              \   }
              \ }

              colorscheme PaperColor
            '';
          }
          { plugin = "vim-python/python-syntax"; }
        ];
      };
  };

  programs.home-manager = {
    enable = true;
    path =
      "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  };

  programs.bat.enable = true;

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    autocd = true;
    sessionVariables = { EDITOR = "nvim"; };
    shellAliases = {
      c = "clear";
      ls = "exa";
      l = "exa -l";
      ll = "exa -lah";
      q = "exit";
      tree = "exa -T";
      d = "dirs -v";
      cat = "bat";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "mafredri/zsh-async"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "zdharma/fast-syntax-highlighting"; }
        { name = "scmbreeze/scm_breeze"; }
      ];
    };

    initExtraBeforeCompInit = ''
      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode

    '';

    initExtra = ''
      ${packages.utils.sourceWhenAvaliable [
        "~/.smoke"
        "~/.nvm/nvm.sh"
      ]}

      # not yet supported in hm module
      zplug "plugins/docker", from:oh-my-zsh
      zplug "plugins/docker-compose", from:oh-my-zsh
      zplug install 2> /dev/null
      zplug load

    '';
  };

  programs.git = {
    extraConfig = {
      user.name = "Ismail Bello";
      credential.helper = "store";
      core.excludesfile =
        "$XDG_CONFIG_HOME/git/gitignore.global";
      pull.rebase = true;
    };
    includes = [{ path = "~/.gitconfig"; }];
    aliases = { git-clean = "git clean -xdf -e .vim"; };
  };

  home.activation = {
    rangerCopyConfigs = with packages.utils;
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.config/ranger/*
        $DRY_RUN_CMD ${pkgs.ranger}/bin/ranger --copy-config=all

        ${setRangerPreviewMethod { }}
        ${ranger-rifle-conf-patch { }}
      '';
  };

}
