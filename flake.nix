{
  description = "Ismail Bello's Nix configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils/main";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-appimage.url = "github:ralismark/nix-appimage";
    nix-appimage.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    darwin,
    flake-utils,
    nix-appimage,
    ...
  }:
    (
      # devshells, fmt, editor, standalone hm-configurations
      flake-utils.lib.eachDefaultSystem (
        system: let
          username = "ismailbello";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

          homeRoot =
            if pkgs.hostPlatform.isDarwin
            then "Users"
            else "home";

          neovim-packages = import ./neovim-flake/packages.nix {
            pkgs = pkgs-unstable;
            inherit nix-appimage;
          };

          _neovim-configured-packages = removeAttrs neovim-packages ["default"];
        in rec {
          devShell = import ./shell.nix {inherit pkgs;};
          formatter = pkgs.alejandra;
          packages =
            _neovim-configured-packages
            // {
              # if any...
            };
          devShells = {
            default = devShell;
            nvim = import ./neovim-flake/shell.nix {
              pkgs = pkgs-unstable;
              nvim = packages.nvim;
            };
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
              extraSpecialArgs = {
                neovim-configured = packages.nvim;
              };
            };
          };
        }
      )
    )
    // {
      # Darwin hosts
      darwinConfigurations = {
        "Ismails-Laptop" = let
          username = "ismailbello";
          system = with flake-utils.lib.system; aarch64-darwin;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
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
                    neovim-configured =
                      (import ./neovim-flake/packages.nix {
                        pkgs = pkgs-unstable;
                        inherit nix-appimage;
                      })
                      .default;
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
