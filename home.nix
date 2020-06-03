{ pkgs, ... }:
let

  commons = import ./common.nix { pkgs = pkgs; };
  isDarwin = commons.isDarwin;

  home-manager-basics = with pkgs.lib;
    filter (drv: !(hasInfix "neovim" drv.name)) commons.basics;

  home-manager-extra-packages = with pkgs; [
      rnix-lsp
      nodePackages.bash-language-server
  ];

in {

  home.packages = builtins.concatLists [
    home-manager-basics
    home-manager-extra-packages
    commons.compilers
    commons.jsTooling
    commons.pythonTooling
    (if isDarwin then [ ] else commons.pythonTooling)
  ];

  programs.neovim = {
    enable = true;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
  };

  programs.home-manager.enable = true;

  programs.zsh = commons.zsh;

}
