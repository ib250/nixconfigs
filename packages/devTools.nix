{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
with pkgs; {

  jvm-family = [ scala-cli sbt maven coursier ];

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
    let
      compiler = if isWsl then [ gcc ] else [ clang_13 ];
      # collision between binutils and
      # clang/gcc use nix-shell for now
    in [ cmake gnumake stdmanpages ];

  js = [ deno yarn yarn2nix nodePackages.node2nix ];

  ts = [ nodePackages.typescript ];

  python = let
    fromPypi = pypi:
      with pypi;
      let
        extras = [ pip pipx tox black isort ];

        linting = [ mypy flake8 jedi ];

      in extras ++ linting;

  in [
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
