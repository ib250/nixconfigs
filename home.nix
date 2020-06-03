{ pkgs, ... }:
let

  commons = import ./common.nix { pkgs = pkgs; };
  isDarwinOrWsl = commons.isDarwin || commons.isWsl;

  # programs.neovim manages its own install of neovim so no need here
  homePackages = with pkgs.lib;
    filter (drv: !(hasInfix "neovim" drv.name)) commons.basics;

in {

  home.packages = with builtins;
    concatLists [
      homePackages
      commons.devTools.js
      commons.devTools.c-family
      commons.devTools.nix
      commons.devTools.haskell
      # python tooling woes never end
      (if isDarwinOrWsl then [ ] else commons.devTools.python)
    ];

  programs.neovim = {
    enable = true;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    sessionVariables = { EDITOR = "nvim"; };
    shellAliases = {
      c = "clear";
      ls = "exa";
      l = "exa -l";
      ll = "exa -lah";
      q = "exit";
      tree = "exa -T";
    };

    initExtra = commons.zplugrc {

      plugins = [
        "mafredri/zsh-async"
        "sindresorhus/pure"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "zdharma/fast-syntax-highlighting"
      ];

      epilogue = ''
        bindkey jk vi-cmd-mode
        bindkey kj vi-cmd-mode
        autoload bashcompinit && bashcompinit
        autoload -U promptinit && promptinit
      '';

      sourceWhenAvaliable = [ ~/.smoke ];

    };

  };

}
