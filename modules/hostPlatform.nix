{pkgs}: rec {
  isWsl = with builtins; (getEnv "WSL_DISTRO_NAME") != "";

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  inherit (pkgs.stdenv.hostPlatform) isLinux;

  basedOnHost = builtins.intersetAttrs {inherit isWsl isDarwin isLinux;};
}
