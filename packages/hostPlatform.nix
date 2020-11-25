{ pkgs }: {

  isWsl = with builtins; (getEnv "WSL_DISTRO_NAME") != "";

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  isLinux = pkgs.stdenv.hostPlatform.isLinux;

}
