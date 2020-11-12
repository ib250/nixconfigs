{ enabled, pkgs ? import <nixpkgs> { }, ... }:
let
  ghcideOptions = {
    ghcide = {
      command = "ghcide";
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
  };

  metalsOptions = {
    metals = {
      command = "metals-vim";
      rootPatterns = [ "build.sbt" ];
      filetypes = [ "scala" "sbt" ];
    };
  };

  clangdOptions = {
    clangd = {
      command = "clangd";
      args = [ "--background-index" ];
      rootPatterns =
        [ "compile_flags.txt" "compile_commands.json" ".vim/" ".git/" ".hg/" ];
      filetypes = [ "c" "cpp" "objc" "objcpp" ];
    };
  };

  rnixLspOptions = {
    nix = {
      command = "rnix-lsp";
      filetypes = [ "nix" ];
    };
  };

  bashLspOptions = {
    bash-lsp = {
      command = "bash-language-server";
      args = [ "start" ];
      filetypes = [ "sh" ];
      ignoredRootPaths = [ "~" ];
    };
  };

  kotlinLspOptions = {
    kotlin = {
      command = "kotlin-language-server";
      filetypes = [ "kotlin" ];
    };
  };

  defaultLspConfig = drv:
    with pkgs.lib;
    if hasInfix "ghcide" drv.name then
      ghcideOptions
    else if hasInfix "metals" drv.name then
      metalsOptions
    else if hasInfix "clang" drv.name then
      clangdOptions
    else if hasInfix "rnix" drv.name then
      rnixLspOptions
    else if hasInfix "bash" drv.name then
      bashLspOptions
    else if hasInfix "kotlin" drv.name then
      kotlinLspOptions
    else
      { };

  jsonfmt = pkgs.formats.json { };

  createCocConfig = lsps:
    with pkgs.lib; {
      languageserver =
        foldr (drv: cfg: cfg // (defaultLspConfig drv)) { } lsps;
    };

  mkCocConfigJson = { }:
    let data = createCocConfig enabled;
    in jsonfmt.generate "coc-config.json" data;

in {
  lsps = enabled;
  contents = mkCocConfigJson { };
}
