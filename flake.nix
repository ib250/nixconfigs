{
  description = "Ismail Bello's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    nixvim.url = "github:ib250/nixvim/nixos-23.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    nixvim,
    flake-utils,
    ...
  }:
    {
      darwinConfigurations = {
        "Ismails-Laptop" = let
          username = "ismailbello";
          system = "aarch64-darwin";
        in
          darwin.lib.darwinSystem {
            inherit system;
            modules = [
              ./machines/darwin-configuration.nix
              home-manager.darwinModules.home-manager
              nixvim.nixDarwinModules.nixvim
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import ./home.nix {
                  pkgs = nixpkgs.legacyPackages.${system};
                  extraSpecialArgs = {inherit nixvim;};
                };
              }
            ];
          };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {devShell = import ./shell.nix {inherit pkgs;};});
}
