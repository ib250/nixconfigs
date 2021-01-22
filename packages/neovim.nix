{ pkgs }: {

  package = pkgs.neovim-unwrapped;

  configure = {
    customRC = ''
      ${builtins.readFile ./minimal.vim}

      " because some things are not in nixpkgs
      call plug#begin(stdpath('data') . '/plugged')
      Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
      call plug#end()

      let g:mkdp_auto_start = 1
    '';

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
        purescript-vim
        vim-plug
      ];

      opt = [ ];
    };

  };

}
