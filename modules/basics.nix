{pkgs, ...}: let
  hostPlatform = import ./hostPlatform.nix {inherit pkgs;};
  commonPackages = with pkgs; [
    linode-cli
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
    highlight
    jq
    fd
    silver-searcher
    eza
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
in {homePackages = commonPackages ++ linuxExtras;}
