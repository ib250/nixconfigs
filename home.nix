{ pkgs, lib, config, options, modulesPath }:
let

  commons = import ./common pkgs;
  devTools = commons.devTools;

  cocConfig = devTools.coc-extra-lsps;

  sourceWhenAvaliable = commons.sourceWhenAvaliable;

  # programs.neovim manages its own install of neovim so no need here
  homePackages = with pkgs.lib;
    filter (drv: !(hasInfix "neovim" drv.name)) commons.basics;

  # misc extras
  extraPackages = [ pkgs.httpie ];

in rec {

  home.packages = with builtins;
    concatLists [
      homePackages
      devTools.js
      devTools.c-family
      devTools.nix
      devTools.haskell
      devTools.jvm-family
      devTools.shell
      devTools.python
      extraPackages
    ];

  programs.neovim = {
    enable = true;
    package = commons.neovim.package;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
    configure = commons.neovim.configure;
  };

  home.file = {
    ".config/nvim/coc-settings.json".source = cocConfig.contents;
    ".config/coc/extensions/package.json" = {
      text = builtins.toJSON {
        dependencies = {
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
      ];
    };

    initExtraBeforeCompInit = ''
      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode
    '';

    initExtra = sourceWhenAvaliable [ "~/.smoke" ];

  };

}
