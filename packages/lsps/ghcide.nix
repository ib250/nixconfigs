drv: {
  ghcide = {
    command = "${drv}/bin/ghcide";
    args = [ "--lsp" ];
    rootPatterns = [
      ".stack.yaml"
      ".hie-bios"
      "BUILD.bazel"
      "cabal.config"
      "package.yaml"
    ];
    filetypes = [ "hs" "lhs" "haskell" ];
  };
}
