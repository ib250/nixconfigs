{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs; {
  jvm-family = [ scala sbt maven ];

  haskell = let
    globalHaskellPackages = hackage:
      with hackage; [
        hoogle
        hlint
        stylish-haskell
        hpack
        hspec
        dotenv
      ];
  in [ stack (ghc.withPackages (globalHaskellPackages)) ];

  c-family = with hostPlatform;
    [ cmake gnumake stdmanpages ] ++ lib.optional isWsl gcc
    ++ lib.optional (isLinux && !isWsl) clang_10;

  js = [ deno yarn yarn2nix nodePackages.node2nix ];

  ts = [ nodePackages.typescript ];

  python = let
    fromPypi = pypi:
      with pypi;
      let
        extras = [
          pip
          pipx
          tox
          black
          isort
          boto3
          ipython
          pandas
          matplotlib
          numpy
          scipy
        ];

        nonOSXExtras =
          lib.optionals (!hostPlatform.isDarwin) [
            jupyter
            jupyterlab
          ];

        linting = [ mypy flake8 jedi ];

      in extras ++ linting ++ nonOSXExtras;

  in [
    pipenv
    poetry
    (python38.withPackages fromPypi)
    nodePackages.pyright
  ];

  nix = [ nix-doc nixfmt nixpkgs-fmt ];

  terraform =
    lib.optional (!hostPlatform.isDarwin) terraform;

  lsps = [
    haskellPackages.ghcide
    # metals -> switch to coc-metals
    clang-tools
    rnix-lsp
    nodePackages.bash-language-server
    # nodePackages.purescript-language-server
    terraform-lsp
    yaml-language-server
    # graphql-language-service-cli
  ];

}

