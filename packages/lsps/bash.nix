drv: {
  bash-lsp = {
    command = "${drv}/bin/bash-language-server";
    args = [ "start" ];
    filetypes = [ "sh" ];
    ignoredRootPaths = [ "~" ];
  };
}
