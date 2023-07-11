{pkgs, ...}:
with pkgs; let
  jvm-family = [scala-cli sbt maven coursier metals];

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
  in [stack (ghc.withPackages globalHaskellPackages)];

  c-family = [clang clang-tools cmake gnumake stdmanpages gcc];

  js = [deno yarn yarn2nix nodePackages.node2nix];

  ts = [nodePackages.typescript];

  python = [nodePackages.pyright];

  nix = [nil nix-doc alejandra statix deadnix];

  tf = [terraform terraform-lsp];

  lsps = [
    nodePackages.bash-language-server
    nodePackages.purescript-language-server
    yaml-language-server
  ];

  rust = [cargo rustup rust-analyzer];

  golang = [go_1_20];

  lua = [luarocks];

  treesitterFull = [(tree-sitter.withPlugins (_: tree-sitter.allGrammars))];
in {
  config = {
    extraPackages =
      builtins.concatLists [
        jvm-family
        haskell
        c-family
        js
        ts
        python
        nix
        tf
        lsps
        rust
        golang
        lua
        treesitterFull
      ]
      ++ [git];
  };
}
