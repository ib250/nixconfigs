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

    settings = {
      auto-optimise-store = true;
      extra-trusted-users = ["@admin"];
    };
    linux-builder.enable = false;
    linux-builder.config = {pkgs, ...}: {
      nix.enable = true;
      nix.package = pkgs.nixFlakes;
      programs = {
        zsh = {
          autosuggestions.enable = true;
          enable = true;
          enableCompletion = true;
          syntaxHighlighting.enable = true;
        };
        neovim.enable = true;
        neovim.defaultEditor = true;
      };
    };
  };
  homebrew = {
    enable = true;
    casks = [
      "iterm2"
      "docker"
      "cisco-jabber"
    ];

    brews = [
      "tmux"
    ];
  };
}
