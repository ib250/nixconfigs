{pkgs}: {
  basics = import ./basics.nix {inherit pkgs;};

  devTools = import ./devTools.nix {inherit pkgs;};

  nixosPackages = import ./nixosPackages.nix {inherit pkgs;};

  utils = rec {
    unlines = strings: with pkgs.lib; concatStrings (intersperse "\n" strings);

    sourceWhenAvaliable = files:
      unlines (map (fp: "[ -e ${fp} ] && source ${fp}") files);
  };
}
