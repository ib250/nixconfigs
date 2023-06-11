{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell rec {

  NIX_CONFIG = "experimental-features = nix-command flakes";
  buildInputs = with pkgs; [ fd exa coreutils zsh ];

}
