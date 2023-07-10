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

    extraPlugins = [pkgs.vimPlugins.mini-nvim pkgs.vimPlugins.nvim-treesitter-textobjects];
  };
}
