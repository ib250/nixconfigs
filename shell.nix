{ pkgs ? import <nixpkgs> { } }:
let

  fmt = pkgs.writeScriptBin "autoformat" ''
    #!${pkgs.stdenv.shell}
    nixfmt --width=60 $@ $(fd .nix | xargs)
  '';

  hostPlatform =
    import ./packages/hostPlatform.nix { pkgs = pkgs; };

  homeManagerBase =
    "https://github.com/nix-community/home-manager/archive";

  nixChannelsBase = "https://nixos.org/channels";

  poetry2nixBase =
    "https://github.com/nix-community/poetry2nix/archive";

  mkUrl = builtins.concatStringsSep "/";

  channels = {
    hm = if hostPlatform.isDarwin then
      "release-21.05.tar.gz"
    else
      "master.tar.gz";

    nixpkgs = if hostPlatform.isDarwin then
      "nixpkgs-21.05-darwin"
    else
      "master.tar.gz";

    poetry2nix = "master.tar.gz";

    nixpkgs-unstable = "nixpkgs-unstable";

  };

in pkgs.mkShell rec {

  inherit (channels) hm nixpkgs poetry2nix nixpkgs-unstable;

  HOME_MANAGER = mkUrl [ homeManagerBase hm ];
  POETRY2NIX = mkUrl [ poetry2nixBase poetry2nix ];
  NIXPKGS = mkUrl [ nixChannelsBase nixpkgs ];
  NIXPKGS_UNSTABLE =
    mkUrl [ nixChannelsBase nixpkgs-unstable ];

  buildInputs = with pkgs; [ fmt fd exa coreutils zsh ];

}
