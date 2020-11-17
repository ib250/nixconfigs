{ pkgs ? import <nixpkgs> { } }:
let

  fmt = pkgs.writeScriptBin "format-all" ''
    #!${pkgs.stdenv.shell}
    nixfmt --width=75 $(fd .nix | xargs)
  '';

in pkgs.mkShell {

  HOME_MANAGER =
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";

  NIXPKGS = "https://nixos.org/channels/nixpkgs-unstable";

  POETRY2NIX =
    "https://github.com/nix-community/poetry2nix/archive/master.tar.gz";

  buildInputs = with pkgs; [ fmt fd exa coreutils zsh ];

}
