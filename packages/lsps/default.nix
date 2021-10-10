{ enabled, pkgs ? import <nixpkgs> { } }:
let

  defaultLspConfig = drv:
    with pkgs.lib;
    if hasInfix "ghcide" drv.name then
      import ./ghcide.nix drv
    else if hasInfix "metals" drv.name then
      import ./scala-metals.nix drv
    else if hasInfix "clang-tools" drv.name then
      import ./clangd.nix drv
    else if hasInfix "rnix-lsp" drv.name then
      import ./rnix.nix drv
    else if hasInfix "bash-language-server" drv.name then
      import ./bash.nix drv
    else if hasInfix "kotlin-language-server" drv.name then
      import ./kotlin.nix drv
    else if hasInfix "purescript" drv.name then
      import ./purescript.nix drv
    else if hasInfix "terraform-ls" drv.name then
      import ./terraform.nix drv
    else if hasInfix "yaml-language-server" drv.name then
      import ./yaml-language-server.nix drv
    else if hasInfix "graphql" drv.name then
      import ./graphql.nix drv
    else
      abort "${drv.name} not matched to lsp configuration";

  jsonfmt = pkgs.formats.json { };

  createCocConfig = lsps:
    with pkgs.lib; {
      languageserver =
        foldr (drv: cfg: cfg // (defaultLspConfig drv)) { }
        lsps;
    };

  mkCocConfigJson = { extraConfig ? { } }:
    let data = (createCocConfig enabled) // extraConfig;
    in jsonfmt.generate "coc-config.json" data;

  versions = map (drv: drv.version);

in {

  mkCocConfigJson = mkCocConfigJson;

  coc-settings-json = mkCocConfigJson { };

  package = pkgs.stdenv.mkDerivation rec {

    name = "lsps";
    version = with builtins;
      hashString "md5"
      (concatStringsSep ":" (versions enabled));
    src = ./.;
    propagatedBuildInputs = enabled;

    installPhase = ''
      mkdir -p $out
      echo ${version} > $out/version
    '';

  };
}
