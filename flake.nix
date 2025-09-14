{
  description = "Ismail Bello's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim-configured.url = "github:ib250/neovim-flake/nightly-no-framework";
    neovim-configured.inputs.nixpkgs.follows = "nixpkgs-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    darwin,
    flake-utils,
    neovim-configured,
    ...
  }:
    ( # devshells, fmt, editor, standalone hm-configurations
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
          username = "ismailbello";
          system = with flake-utils.lib.system; aarch64-darwin;
          pkgs = import nixpkgs {inherit system;};
        in
          darwin.lib.darwinSystem {
            inherit pkgs system;
            modules = [
              ./machines/darwin-configuration.nix
              home-manager.darwinModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ./home.nix;
                  extraSpecialArgs = {
                    neovim-configured = neovim-configured.packages.${system}.default;
                  };
                };
              }
              {
                nix.nixPath = pkgs.lib.mkForce [
                  {
                    nixpkgs = nixpkgs.outPath;
                    nixpkgs-unstable = nixpkgs-unstable.outPath;
                  }
                ];
              }
            ];
          };
      };
    };
}
