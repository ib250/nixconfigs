{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs;
let

  #purescript-language-server = import ./purescript-language-server {
    #pkgs = pkgs;
    #nodejs = nodejs;
  #};

in {

  jvm-family = [ scala sbt maven jdk11 ];

  haskell = let
    compiler = ghc.withPackages (hackage:
      with hackage; [
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
  in [ cmake gnumake stdmanpages ] ++ compilers;

  js = [
    nodejs
    deno
    yarn
    yarn2nix
    nodePackages.node2nix
  ];

  ts = [ nodePackages.typescript ];

  purescript = [ spago purescript ];

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

  in [ pipenv poetry (python38.withPackages fromPypi) ];

  nix = [ nixfmt nixpkgs-fmt ];

  terraform =
    if hostPlatform.isDarwin then
      [ /* tfenv on osx */ ]
    else
      [ terraform ];

  lsps = [
      haskellPackages.ghcide
      metals
      clang-tools
      rnix-lsp
      nodePackages.bash-language-server
      #purescript-language-server.package
      terraform-lsp
  ];

}

