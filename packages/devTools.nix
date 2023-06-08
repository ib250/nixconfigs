{ pkgs, hostPlatform ? import ./hostPlatform.nix { inherit pkgs; } }:
with pkgs; {

  jvm-family = [ scala-cli sbt maven coursier ];

  haskell = let
    globalHaskellPackages = hackage:
      with hackage; [
        haskell-language-server
        hoogle
        hlint
        stylish-haskell
        hpack
        hspec
        dotenv
      ];
  in [ stack (ghc.withPackages globalHaskellPackages) ];

  c-family = with hostPlatform;
    let
      compiler =
        if isWsl then [ gcc ] else if isDarwin then [ ] else [ clang_13 ];
      # collision between binutils and
      # clang/gcc use nix-shell for now
    in [ cmake gnumake stdmanpages ] ++ compiler;

  js = [ deno yarn yarn2nix nodePackages.node2nix ];

  ts = [ nodePackages.typescript ];

  python = [ nodePackages.pyright ];

  nix = [ nil nix-doc nixpkgs-fmt rnix-lsp statix deadnix ];

  terraform = lib.optional (!hostPlatform.isDarwin) terraform;

  lsps = [
    # haskellPackages.ghcide
    # metals -> switch to coc-metals
    clang-tools
    rnix-lsp
    nodePackages.bash-language-server
    # nodePackages.purescript-language-server
    # terraform-lsp
    # yaml-language-server
    # graphql-language-service-cli
  ];

}
