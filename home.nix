{ pkgs, ... }:
let

  commons = import ./common.nix { pkgs = pkgs; };
  isDarwin = commons.isDarwin;

in {

  home.packages = builtins.concatLists [
    commons.basics
    commons.compilers
    commons.jsTooling
    (if isDarwin then [ ] else commons.pythonTooling)
  ];

  programs.neovim = {
    enable = true;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
  };

  programs.home-manager.enable = true;

  programs.zsh = commons.zsh;

}
