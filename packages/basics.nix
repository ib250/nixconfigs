{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs;
let

  commonPackages = [
    awscli
    google-cloud-sdk
    awless
    fzf
    pgcli
    mycli
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
    nix-info
    gh
    loc
  ];

  linuxExtras = lib.optional hostPlatform.isLinux ueberzug;

  osxExtras =
    lib.optional hostPlatform.isDarwin coreutils-prefixed;

in linuxExtras ++ commonPackages ++ osxExtras
