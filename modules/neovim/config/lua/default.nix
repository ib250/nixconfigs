{
  extraConfigLuaPre = builtins.readFile ./lua/before.lua;
  extraConfigLuaPost = builtins.readFile ./lua/after.lua;
}
