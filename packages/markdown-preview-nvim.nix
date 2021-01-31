{ pkgs ? import <nixpkgs> { } }:
pkgs.vimUtils.buildVimPlugin rec {

  pname = "markdown-preview.nvim";
  version = "0.0.9";

  src = builtins.fetchTarball
    "https://github.com/iamcco/markdown-preview.nvim/archive/v${version}.tar.gz";

  buildInputs = [ pkgs.yarn ];

  preInstall = ''
    pushd app
      yarn install
    popd
  '';

  HOME = builtins.getEnv "TMP"; # HACK

}
