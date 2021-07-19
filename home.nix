{ pkgs, lib, ... }:
let

  packages = import ./packages pkgs;

  devTools = packages.devTools;

  # programs.neovim manages its own install of neovim so no need here
  homePackages = with lib;
    filter (drv: !(hasInfix "neovim" drv.name))
    packages.basics;

in rec {

  nixpkgs.config = packages.nixpkgs-config;

  xdg.configFile."nixpkgs/config.nix".source =
    ./packages/nixpkgs-config.nix;
  xdg.configFile."nixpkgs/overlays.nix".source =
    ./packages/overlays.nix;

  home.packages = with builtins;
    concatLists [
      homePackages
      devTools.js
      devTools.c-family
      devTools.nix
      devTools.haskell
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
        packages.lsps.coc-settings-json;

      ".config/coc/extensions/package.json" = {
        text = builtins.toJSON {
          dependencies = {
            coc-json = "==1.3.5";
            coc-format-json = ">=0.2.0";
            coc-java = ">=1.5.0";
            coc-pyright = "1.1.156";
            coc-tsserver = "1.8.1";
            coc-marketplace = ">=1.8.0";
            coc-spell-checker = ">=1.2.0";
            coc-denoland = ">=3.0.0";
            coc-html = ">=1.4.1";
            coc-sql = ">=0.5.0";
          };
        };

        onChange = ''
          cd ~/.config/coc/extensions
          echo "
            * New coc-nvim changes detected, installing...
          "
          [ -e ./packages-json.lock ] && rm -rf ./packages-json.lock
          ${pkgs.nodejs}/bin/npm install \
            --ignore-scripts --no-logfile --production --legacy-peer-deps
        '';
      };

    };

  programs.neovim = {

    # nvim 0.5.0
    package =
      (import <nixpkgs-unstable> { }).neovim-unwrapped;
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = [ pkgs.yarn pkgs.nodePackages.pyright ];
    extraPython3Packages =
      (ps: with ps; [ pynvim jedi mypy pylint ]);

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
          {
            plugin = "neoclide/coc.nvim";
            onLoad = "{'branch': 'release'}";
            config = ''
              set hidden
              set nobackup
              set nowritebackup
              set cmdheight=1
              set updatetime=300
              set shortmess+=c
              set signcolumn
            '';
          }
          {
            plugin = "ctrlpvim/ctrlp.vim";
            config = ''
              let g:ctrlp_cmd = 'CtrlPMRU'
            '';
          }
          {
            plugin = "preservim/nerdtree";
            config = ''
              nnoremap <C-n> :NERDTreeToggle<CR>
            '';
          }
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
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right \
        | source /dev/stdin

      ${packages.utils.sourceWhenAvaliable [ "~/.smoke" ]}

      source <(${pkgs.awless}/bin/awless completion zsh)
    '';
  };

  programs.git = {
    extraConfig = {
      user.name = "Ismail Bello";
      credential.helper = "store";
    };
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
