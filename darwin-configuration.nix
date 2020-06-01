{ config, pkgs, ... }:
{

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =

      let
          basics = with pkgs; [
              awscli
              zsh
              bash_5
              cmake
              autoconf
              pstree
              fd
              jq
              yq
              ag
              ammonite
              scala
              sbt
              coursier
              maven
              stack
              highlight
              ranger
              exa
              htop
              ccls
              git 
              gitAndTools.git-extras
              ktlint
              cachix
          ];

          from_darwin = [
              pkgs.bash_5
              pkgs.coreutils-full
              pkgs.coreutils-prefixed
          ];

      in
          basics ++ from_darwin;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;

  programs.zsh.enable = true;
  programs.zsh.enableSyntaxHighlighting = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 8;
  nix.buildCores = 1;

}
