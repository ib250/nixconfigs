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

    linux-builder.enable = true;
    settings.extra-trusted-users = ["@admin"];
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
