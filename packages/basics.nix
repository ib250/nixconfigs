{ pkgs }:
with pkgs; [
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
]
