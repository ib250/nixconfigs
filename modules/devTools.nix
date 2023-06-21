{ pkgs, ... }:
let hostPlatform = import ./hostPlatform.nix { inherit pkgs; };
in with pkgs; rec {

  jvm-family = [ scala-cli sbt maven coursier metals ];

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

  c-family = [ clang-tools cmake gnumake stdmanpages gcc ];

  js = [ deno yarn yarn2nix nodePackages.node2nix ];

  ts = [ nodePackages.typescript ];

  python = [ nodePackages.pyright ];

  nix = [ nil nix-doc nixpkgs-fmt rnix-lsp statix deadnix ];

  terraform = lib.optional (!hostPlatform.isDarwin) [ terraform terraform-lsp ];

  lsps = [
    nodePackages.bash-language-server
    nodePackages.purescript-language-server
    yaml-language-server
  ];

  rust = [ cargo rustup ];

  lua = [ luarocks ];

  treesitterFull = [ (tree-sitter.withPlugins (_: tree-sitter.allGrammars)) ];

  allDevtools = builtins.concatLists [
    jvm-family
    haskell
    c-family
    js
    ts
    python
    nix
    terraform
    lsps
    rust
    lua
    treesitterFull
  ];

}
