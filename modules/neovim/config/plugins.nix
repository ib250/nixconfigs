{pkgs, ...}: {
  config = {
    plugins = {
      todo-comments.enable = true;
      comment-nvim.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };
    };

    extraPlugins = [
      {
        plugin = pkgs.vimPlugins.mini-nvim;
        config = with import ./lib.nix;
          inlineLua ''
            require("mini.doc").setup()
            require("mini.sessions").setup()
            require("mini.starter").setup()
            require("mini.surround").setup()
          '';
      }
      pkgs.vimPlugins.nvim-treesitter-textobjects
    ];
  };
}
