pkgs:
let

  hostPlatform =
    import ./hostPlatform.nix { inherit pkgs; };

in {

  basics = import ./basics.nix { pkgs = pkgs; };

  devTools = import ./devTools.nix { pkgs = pkgs; };

  nixosPackages =
    import ./nixosPackages.nix { pkgs = pkgs; };

  nixpkgs-config = import ./nixpkgs-config.nix;

  utils = rec {

    unlines = strings:
      with pkgs.lib;
      concatStrings (intersperse "\n" strings);

    sourceWhenAvaliable = files:
      unlines
      (map (fp: "[ -e ${fp} ] && source ${fp}") files);

  };

}
