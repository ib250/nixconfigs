{ pkgs, ... }:
let
  hostPlatform = import ./hostPlatform.nix { inherit pkgs; };
  commonPackages = with pkgs; [
    awscli2
    google-cloud-sdk
    fzf
    pgcli
    mycli
    wget
    gawk
    coreutils
    binutils
    man-pages
    pstree
    zsh
    zplug
    git
    ruby
    gitAndTools.git-extras
    pre-commit
    htop
    joshuto
    highlight
    jq
    fd
    silver-searcher
    exa
    zip
    unzip
    ripgrep
    httpie
    gnused
    nix-info
    nox
    gh
    loc
  ];
  linuxExtras = with pkgs; lib.optional hostPlatform.isLinux ueberzug;
  osxExtras = with pkgs; lib.optional hostPlatform.isDarwin coreutils-prefixed;

in { homePackages = commonPackages ++ linuxExtras ++ osxExtras; }
