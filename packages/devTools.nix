{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs; {

  jvm-family = [ scala sbt maven metals jdk11 ];

  haskell = let
    compiler = ghc.withPackages (hackage:
      with hackage; [
        ghcide
        hoogle
        hlint
        stylish-haskell
        hpack
      ]);
  in [ stack compiler ];

  c-family = let
    compilers = if hostPlatform.isWsl then
      [ gcc ]
    else if hostPlatform.isDarwin then
      [ ]
    else
      [ clang_10 ];
  in [ cmake gnumake clang-tools ] ++ compilers;

  js = [
    nodejs
    deno
    yarn
    yarn2nix
    nodePackages.node2nix
    nodePackages.typescript
  ];

  python = let
    fromPypi = pypi:
      with pypi;
      let
        extras = [
          pip
          pipx
          poetry
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
        nonOSXExtras = if hostPlatform.isDarwin then
          [ ]
        else [
          jupyter
          jupyterlab
        ];
        linting = [ mypy flake8 jedi ];
      in builtins.concatLists [
        extras
        linting
        nonOSXExtras
      ];

  in [ pipenv (python38.withPackages fromPypi) ];

  nix = [ nixfmt nixpkgs-fmt rnix-lsp ];

  shell = [ nodePackages.bash-language-server ];

  coc-extra-lsps = import ./lsps.nix {
    enabled = [
      haskellPackages.ghcide
      metals
      clang-tools
      rnix-lsp
      nodePackages.bash-language-server
    ];
  };

}

