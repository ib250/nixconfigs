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
    hm = "release-22.05.tar.gz";

    nixpkgs = if hostPlatform.isDarwin then
      "nixpkgs-22.11-darwin"
    else
      "nixpkgs-22.11";

    poetry2nix = "master.tar.gz";

    nixpkgs-unstable = "nixpkgs-unstable";

  };

in pkgs.mkShell rec {

  inherit (channels) hm nixpkgs poetry2nix nixpkgs-unstable;

  HOME_MANAGER = mkUrl [ homeManagerBase hm ];
  POETRY2NIX = mkUrl [ poetry2nixBase poetry2nix ];
  NIXPKGS_UNSTABLE =
    mkUrl [ nixChannelsBase nixpkgs-unstable ];

  NIXPKGS = mkUrl [ nixChannelsBase nixpkgs ];

  NIXPKGS_ALLOW_BROKEN = "1";

  buildInputs = with pkgs; [ fmt fd exa coreutils zsh ];

}
