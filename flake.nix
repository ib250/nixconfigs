{
  description = "Ismail Bello's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    neovim-configured.url = "github:ib250/neovim-flake/no-bins";
    neovim-configured.inputs.nixpkgs.follows = "nixpkgs";

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
    flake-utils,
    neovim-configured,
    ...
  }:
    ( # devshells + fmt
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = import ./shell.nix {inherit pkgs;};
        formatter = pkgs.alejandra;
        packages = {
          neovim = neovim-configured.packages.${system}.default;
        };
      })
    )
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
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import ./home.nix {
                  pkgs = import nixpkgs {inherit system;};
                  extraSpecialArgs = {
                    neovim-configured = neovim-configured.packages.${system}.default;
                  };
                };
              }
            ];
          };
      };
    };
}
