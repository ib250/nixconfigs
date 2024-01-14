{
  description = "Ismail Bello's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";

    neovim-configured.url = "github:ib250/neovim-flake/no-bins";
    neovim-configured.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    fh.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    flake-utils,
    neovim-configured,
    ...
  }:
    ( # devshells, fmt, editor, hm-configurations
      flake-utils.lib.eachDefaultSystem (system: let
        username = "ismailbello";
        pkgs = import nixpkgs {inherit system;};
        homeRoot =
          if pkgs.hostPlatform.isDarwin
          then "Users"
          else "home";
      in rec {
        devShell = import ./shell.nix {inherit pkgs;};
        formatter = pkgs.alejandra;
        packages = {
          neovim = neovim-configured.packages.${system}.default;
        };
        legacyPackages = {
          homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              {
                home.username = username;
                home.homeDirectory = "/${homeRoot}/${username}";
                nix.package = pkgs.nixFlakes;
              }
              ./home.nix
            ];
            extraSpecialArgs = {neovim-configured = packages.neovim;};
          };
        };
      })
    )
    // {
      # Darwin hosts
      darwinConfigurations = {
        "Ismails-Laptop" = let
          system = with flake-utils.lib.system; aarch64-darwin;
        in
          darwin.lib.darwinSystem {
            inherit system;
            modules = [./machines/darwin-configuration.nix];
          };
      };
    };
}
