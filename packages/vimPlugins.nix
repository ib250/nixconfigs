{ pkgs ? import <nixpkgs> { } }:
let

  unlines = strings: with pkgs.lib; concatStrings (intersperse "\n" strings);

  vimPlugSrc = version:
    builtins.fetchurl
    "http://raw.githubusercontent.com/junegunn/vim-plug/${version}/plug.vim";

in rec {

  vimPlugRc = { pluginInstallDir, plugins, extraRc }:
    let

      mkPlugAdd = { plugin, onLoad ? null, ... }:
        let onLoadMap = if onLoad == null then "" else ", " + onLoad;
        in "Plug '${plugin}'" + onLoadMap;

      mkPlugPluginRc = { plugin, config ? "", ... }: ''
        " -- ${plugin} configuration
        ${config}
      '';

    in ''
      ${extraRc}

      if &compatible
        set nocompatible
      endif

      set rtp+=${pkgs.vimPlugins.vim-plug}/share/vim-plugins/vim-plug

      call plug#begin('${pluginInstallDir}')

      ${unlines (map mkPlugAdd plugins)}

      call plug#end()

      " Plug specific configuration
      ${unlines (map mkPlugPluginRc plugins)}
    '';

  install = { pluginManager, version }:
    homeFiles:
    let

      opts = if pluginManager == "vim-plug" then {
        key = ".local/share/nvim/site/autoload/plug.vim";
        drv = vimPlugSrc version;
      } else
        abort ''
          Unsupported plugin manager ${pluginManager}. 
          choose one of 'vim-plug' or 'dein.vim'
        '';

    in homeFiles // { "${opts.key}".source = opts.drv; };

}
