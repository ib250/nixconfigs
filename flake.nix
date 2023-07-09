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

    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs = {
    nixpkgs,
    home-manager,
    darwin,
    nixvim,
    flake-utils,
    ...
  }: let
    darwinSystems = with flake-utils.lib.system; [
      x86_64-darwin
      aarch64-darwin
    ];

    linuxSystems = with flake-utils.lib.system; [
      x86_64-linux
      aarch64-linux
    ];

    formatters = flake-utils.lib.eachDefaultSystem (system: {
      formatter = with import nixpkgs {inherit system;}; alejandra;
    });

    devShells = flake-utils.lib.eachDefaultSystem (system: {
      default = let
        pkgs = import nixpkgs {inherit system;};
      in
        import ./shell.nix {inherit pkgs;};
    });

    darwinBootstrap = flake-utils.lib.eachSystem darwinSystems (system: {
      bootstrap = with import nixpkgs {inherit system;};
        writeScriptBin "darwin-boostrap" ''
          echo ${pkgs.nix} system=${system}
        '';
    });
  in
    darwinBootstrap
    // formatters
    // devShells
    // {
      # Darwin hosts
      darwinConfigurations = {
        "Ismails-Laptop" = let
          username = "ismailbello";
          system = with flake-utils.lib.system; aarch64-darwin;
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
                  pkgs = import nixpkgs {inherit system;};
                  extraSpecialArgs = {inherit nixvim;};
                };
              }
            ];
          };
      };
    };
}
