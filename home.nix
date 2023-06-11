{ pkgs, lib, ... }:
let

  packages = import ./packages pkgs;

  inherit (packages) devTools;

in {

  home.packages = packages.basics;

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.config = {
    disable_stdin = false;
    strict_env = true;
  };

  programs.scmpuff.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;

  home.stateVersion = "23.05";
  home.username = "ismailbello";
  home.homeDirectory = "/Users/ismailbello";

  nixpkgs.config = packages.nixpkgs-config;

  xdg.configFile."nixpkgs/config.nix".source =
    ./packages/nixpkgs-config.nix;

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

  xdg.configFile."nvim" = {
    source = ./dots/nvim;
    recursive = true;
  };

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    allow-import-from-derivation = true
  '';

  programs.neovim = {
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ pynvim ];
    defaultEditor = true;
    # TODO(config): see `xdg.configFile."nvim"`
    extraPackages = with builtins;
      concatLists [
        devTools.js
        devTools.c-family
        devTools.nix
        devTools.haskell
        devTools.jvm-family
        devTools.python
        devTools.ts
        devTools.terraform
        [
          pkgs.gcc
          pkgs.luarocks
          pkgs.tree-sitter
          pkgs.cargo
        ]
      ];
  };

  programs.helix = { enable = true; };

  programs.home-manager = { enable = true; };

  programs.bat = {
    enable = true;
    config = { theme = "ansi"; };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      gcloud = {
        format =
          "on [$symbol$account(@$domain/$project)]($style)";
      };
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
      push.autoSetupRemote = true;
    };
    includes = [{ path = "~/.gitconfig"; }];
  };

}
