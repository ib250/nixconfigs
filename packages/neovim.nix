{ pkgs }: {
  package = pkgs.neovim-unwrapped;

  configure = {
    customRC = builtins.readFile ./minimal.vim;

    packages.myVimPackages = with pkgs.vimPlugins; {
      start = [
        ctrlp
        nerdcommenter
        nerdtree
        vim-surround
        vim-repeat
        rainbow_parentheses
        vim-nix
        vim-indent-guides
        elm-vim
        plantuml-syntax
        typescript-vim
        vim-scala
        kotlin-vim
        coc-nvim
      ];

      opt = [ ];
    };

  };
}
