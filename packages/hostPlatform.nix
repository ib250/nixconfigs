{ pkgs }: rec {

  isWsl = with builtins; (getEnv "WSL_DISTRO_NAME") != "";

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  basedOnHost = attrset:
    builtins.intersetAttrs { inherit isWsl isDarwin isLinux; } attrset;

}
