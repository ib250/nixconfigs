{pkgs, ...}: let
  hostPlatform = import ./hostPlatform.nix {inherit pkgs;};
  commonPackages = with pkgs; [
    linode-cli
    awscli2
    google-cloud-sdk
    pgcli
    mycli
    wget
    gawk
    coreutils
    binutils
    man-pages
    pstree
    zplug
    git
    ruby
    gitAndTools.git-extras
    pre-commit
    highlight
    jq
    fd
    silver-searcher
    zip
    unzip
    httpie
    gnused
    nix-info
    nox
    loc
  ];

  linuxExtras = with pkgs; lib.optional hostPlatform.isLinux ueberzug;
  fonts = with pkgs; [fira-code fira-mono];
in {homePackages = commonPackages ++ linuxExtras ++ fonts;}
