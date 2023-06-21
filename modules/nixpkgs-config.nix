{ pkgs, ... }:
let

  hostPlatform = import ./hostPlatform.nix { inherit pkgs; };

  lib-extentions = if hostPlatform.isDarwin then "dylib" else "so";

in {

  allowUnfree = true;

  plugin-files = "~/.nix-profile/lib/libnix_doc_plugin.${lib-extentions}";

}
