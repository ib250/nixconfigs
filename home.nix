{ pkgs, lib, config, options, modulesPath }:
let

  packages = import ./packages pkgs;

  devTools = packages.devTools;

  lsps = import ./packages/lsps {
    enabled = devTools.lsps;
    pkgs = pkgs;
  };

  sourceWhenAvaliable = packages.utils.sourceWhenAvaliable;

  # programs.neovim manages its own install of neovim so no need here
  homePackages = with pkgs.lib;
    filter (drv: !(hasInfix "neovim" drv.name))
    packages.basics;

in rec {

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
      devTools.purescript
      devTools.terraform
      [ lsps.package ]
    ];

  programs.neovim = {
    inherit (packages.neovim) package configure;

    enable = true;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
  };

  home.file = {
    ".config/nvim/coc-settings.json".source =
      lsps.coc-settings-json;

    ".config/coc/extensions/package.json" = {
      text = builtins.toJSON {
        dependencies = {
          coc-json = ">=1.3.2";
          coc-yaml = ">=1.1.2";
          coc-format-json = ">=0.2.0";
          coc-python = ">=1.2.13";
          coc-java = ">=1.5.0";
          coc-tsserver = "1.6.0";
          coc-deno = ">=0.11.0";
          coc-marketplace = ">=1.8.0";
          coc-spell-checker = ">=1.2.0";
        };
      };

      onChange = ''
        cd ~/.config/coc/extensions
        echo "
          * New coc-nvim changes detected, installing...
        "
        ${pkgs.nodejs}/bin/npm install \
          --ignore-scripts --no-logfile --production --legacy-peer-deps
      '';
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
      ${pkgs.any-nix-shell}/bin/any-nix-shell \
          zsh --info-right | source /dev/stdin
      ${sourceWhenAvaliable [ "~/.smoke" ]}
    '';

  };

  home.activation = {

    # * re-write ranger config because...
    # TODO: write hm module for ranger?
    rangerCopyConfigs =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''

        $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.config/ranger/*
        $DRY_RUN_CMD ${pkgs.ranger}/bin/ranger --copy-config=all

        ${packages.utils.setRangerPreviewMethod { }}
      '';


  };

}
