{ pkgs, ... }:
let

  commons = import ./common pkgs;
  isDarwinOrWsl = commons.isDarwin || commons.isWsl;
  devTools = commons.devTools;

  # programs.neovim manages its own install of neovim so no need here
  homePackages = with pkgs.lib;
    filter (drv: !(hasInfix "neovim" drv.name)) commons.basics;

in {

  home.packages = with builtins;
    concatLists [
      homePackages
      devTools.js
      devTools.c-family
      devTools.nix
      devTools.haskell
      devTools.jvm-family
      devTools.shell
      [pkgs.httpie devTools.coc-extra-lsps]

      # python tooling woes never end!
      #   on darwin: manage with brew pyenv
      #   on wsl: you are on your own
      (if isDarwinOrWsl then [ ] else devTools.python)

    ];

  programs.neovim = {
    enable = true;
    package = commons.neovim.package;
    extraPython3Packages = (
        ps: with ps; [ pynvim python-language-server mypy ]
    );
    configure = commons.neovim.configure;
  };

  programs.home-manager.enable = true;

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

      sourceWhenAvaliable = [ "~/.smoke" ];

    };

  };

}
