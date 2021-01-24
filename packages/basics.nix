{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs;
let

  commonPackages = [
    awscli
    wget
    gawk
    coreutils
    binutils
    manpages
    pstree
    zsh
    zplug
    ranger
    neovim
    git
    ruby
    gitAndTools.git-extras
    htop
    highlight
    jq
    fd
    ag
    exa
    zip
    unzip
    ripgrep
    httpie
    gnused
    any-nix-shell
  ];

  linuxExtras = lib.optional hostPlatform.isLinux ueberzug;

in linuxExtras ++ commonPackages
