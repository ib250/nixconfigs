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
      {nixpkgs = "flake:nixpkgs";}
      {nix-darwin = "flake:nix-darwin";}
      {nur = "flake:nur";}
      {
        nixpkgs-23-11-darwin = "https://nixos.org/channels/nixpkgs-23.11-darwin/nixexprs.tar.xz";
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
