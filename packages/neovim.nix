{ pkgs }: {

  package = pkgs.neovim-unwrapped;

  extraConfig = builtins.readFile ./minimal.vim;

  plugins = with pkgs.vimPlugins; [
    nerdcommenter
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
    {
      plugin = ctrlp;
      config = "let g:ctrlp_cmd = 'CtrlPMRU'";
    }
    {
      plugin = nerdtree;
      config = ''
        nnoremap <C-n> :NERDTreeToggle<cr>
      '';
    }
    {
      plugin =
        import ./markdown-preview-nvim.nix { pkgs = pkgs; };
      config = "let g:mkdp_auto_start = 1";
    }
  ];

}
