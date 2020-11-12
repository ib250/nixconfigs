{
  pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {

  HOME_MANAGER = https://github.com/nix-community/home-manager/archive/master.tar.gz;

  NIXPKGS = https://nixos.org/channels/nixos-unstable;

  POETRY2NIX = https://github.com/nix-community/poetry2nix/archive/master.tar.gz;

  buildInputs = with pkgs; [exa coreutils zsh];
}
