{ pkgs ? import <nixpkgs> { } }:
let
  unlines = strings:
    with pkgs.lib;
    concatStrings (intersperse "\n" strings);

in {

  deinSrc = version:
    builtins.fetchTarball
    "https://github.com/Shougo/dein.vim/archive/${version}.tar.gz";

  deinRc = { deinInstallDir, plugins, extraRc }:
    let

      mkDeinAdd = { plugin, onLoad ? null, ... }:
        let

          args = if onLoad == null then
            "'${plugin}'"
          else
            "'${plugin}'" + ", " + onLoad;

        in "call dein#add(${args})";

      mkDeinPluginRc = { plugin, config ? "", ... }: ''
        " ${plugin} specific configuration
        ${config}
      '';

    in ''
      if &compatible
        set nocompatible
      endif

      set rtp+=${deinInstallDir}/dein/repos/github.com/Shougo/dein.vim

      if dein#load_state('${deinInstallDir}/dein')
        call dein#begin('${deinInstallDir}/dein')

        " use home-manager for this one
        " call dein#add('${deinInstallDir}/dein/repos/github.com/Shougo/dein.vim')

        ${unlines (map mkDeinAdd plugins)}

        call dein#end()
        call dein#save_state()

      endif

      filetype plugin indent on
      syntax enable

      ${extraRc}

      " Plugin specific configuration:
      ${unlines (map mkDeinPluginRc plugins)}
    '';

  vimPlugRc = { plugins, extraRc }: let in "";

}
