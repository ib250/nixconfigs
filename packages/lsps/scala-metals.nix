drv: {
  metals = {
    command = "${drv}/bin/metals-vim";
    rootPatterns = [ "build.sbt" ];
    filetypes = [ "scala" "sbt" ];
  };
}
