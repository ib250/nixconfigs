rec {
  inlineLua = s: ''
    lua << EOF
    ${s}
    EOF
  '';

  luaConfig = p: inlineLua (builtins.readFile p);
}
