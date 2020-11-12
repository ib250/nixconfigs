{ pkgs, lib, config, options, modulesPath }:
let

  commons = import ./common pkgs;
  devTools = commons.devTools;


  # programs.neovim manages its own install of neovim so no need here
  homePackages = with pkgs.lib;
    filter (drv: !(hasInfix "neovim" drv.name)) commons.basics;

  # misc extras
  extraPackages = [ pkgs.httpie devTools.coc-extra-lsps ];

  _ = lib.asserts.assertMsg
    (pkgs.lib.version != lib.version)
    "lib and pkgs versions dont match ${pkgs.lib.version} ~ ${lib.version}";

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
    extraPython3Packages = (ps: with ps; [ pynvim mypy ]);
    configure = commons.neovim.configure;
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

    initExtraBeforeCompInit = commons.zplugrc {
      plugins = [
        "mafredri/zsh-async"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "zdharma/fast-syntax-highlighting"
      ];

      epilogue = ''
        bindkey jk vi-cmd-mode
        bindkey kj vi-cmd-mode
        # autoload bashcompinit && bashcompinit
      '';

      sourceWhenAvaliable = [ "~/.smoke" ];
    };

  };

}
