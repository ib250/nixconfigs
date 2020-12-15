drv: {
  purescript = {
    command = "${drv}/bin/purescript-language-server";
    args = [ "--stdio" ];
    filetypes = [ "purescript" ];
    "trace.server" = "off";
    rootPatterns = [
      "bower.json" "psc-package.json" "spago.dhall"
    ];
    settings = {
      "purescript.addSpagoSources" = true;
    };
  };
}
