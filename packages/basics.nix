{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs;
let

  commonPackages = [
    awscli
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
    ranger
    neovim
    git
    ruby
    gitAndTools.git-extras
    pre-commit
    htop
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
    gh
    loc
  ];

  linuxExtras = lib.optional hostPlatform.isLinux ueberzug;

  osxExtras =
    lib.optional hostPlatform.isDarwin coreutils-prefixed;

in linuxExtras ++ commonPackages ++ osxExtras
