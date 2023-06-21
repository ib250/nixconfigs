{
  description =
    "Home Manager configuration of Ismail Bello";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url =
      "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    nixvim.url = "./nixvim";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, home-manager, flake-utils, ... }:
    let pkgs = nixpkgs.legacyPackages."aarch64-darwin";
    in
    {

      homeConfigurations = {
        "ismailbello" =
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./home.nix
              inputs.nixvim.homeManagerModules.nixvim
            ];
          };
      };

    } // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = import ./shell.nix { inherit pkgs; };
      });
}
