{
  pkgs,
  lib,
  ...
}: {
  users.users."ismailbello".createHome = false;
  users.users."ismailbello".home = "/Users/ismailbello";
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  nix = {
    settings.trusted-users = ["root" "ismailbello"];
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      allow-import-from-derivation = true
    '';
    nixPath = lib.mkForce [
      {
        nixpkgs = builtins.fetchTarball {
          url = "https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz";
          sha256 = "sha256:17n0arljd3zp0dbldsg0v0gv1zkbqhx0gvx28fq9jc304jm5idvr";
        };
      }
      {
        nixpkgs-23-11 = builtins.fetchTarball {
          url = "https://nixos.org/channels/nixpkgs-23.11-darwin/nixexprs.tar.xz";
          sha256 = "sha256:0vrrqwapknshqc0r6hhlqi2i3i8jswz7fvxn34miwi2shxi1m17g";
        };
      }
    ];

    settings.auto-optimise-store = true;
  };
  homebrew = {
    enable = true;
    casks = [
      "iterm2"
      "docker"
      "cisco-jabber"
      "nomachine-enterprise-client"
    ];

    brews = [
      "tmux"
    ];
  };
}
