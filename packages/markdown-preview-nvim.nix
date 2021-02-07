{ pkgs ? import <nixpkgs> { } }:
let

  hostPlatform = import ./hostPlatform.nix { pkgs = pkgs; };

in pkgs.vimUtils.buildVimPlugin rec {

  pname = "markdown-preview.nvim";
  version = "0.0.9";

  src = builtins.fetchTarball
    "https://github.com/iamcco/markdown-preview.nvim/archive/v${version}.tar.gz";

  buildInputs = [ pkgs.yarn ];

  preInstall = if hostPlatform.isDarwin then ''
    pushd app
      yarn install
    popd
  '' else
  ''echo "WARNING!: packages/markdown-preview.nvim"
    echo "          Something wrong on WSL and linux..."
    echo "          markdown-preview.nvim may need help post-install to work"
  '';

  HOME = builtins.getEnv "TMP"; # HACK

}
