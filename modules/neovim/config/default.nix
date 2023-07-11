{
  imports = [
    ./options.nix
    ./colors.nix
    ./treesitter.nix
    ./lsp.nix
    ./programs.nix
    ./plugins.nix
    ./cmp.nix
  ];

  extraConfigLuaPost = builtins.readFile ./lua/after.lua;
}
