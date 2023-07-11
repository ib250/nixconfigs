{
  plugins.treesitter = {
    enable = true;
    folding = true;
    indent = true;
    moduleConfig.autotag.enable = true;
    nixvimInjections = true;
  };
  plugins.treesitter-context.enable = true;
  plugins.treesitter-playground.enable = true;
  plugins.treesitter-refactor.enable = true;
  plugins.treesitter-refactor.navigation.enable = true;
  plugins.treesitter-refactor.smartRename.enable = true;
  plugins.treesitter-rainbow.enable = true;
}
