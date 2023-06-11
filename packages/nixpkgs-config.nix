let

  hostPlatform = import ./hostPlatform.nix (import <nixpkgs> { });

  lib-extentions = if hostPlatform.isDarwin then "dylib" else "so";

in {

  allowUnfree = true;

  plugin-files = "~/.nix-profile/lib/libnix_doc_plugin.${lib-extentions}";

}
