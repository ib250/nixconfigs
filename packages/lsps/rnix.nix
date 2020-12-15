drv: {
  nix = {
    command = "${drv}/bin/rnix-lsp";
    filetypes = [ "nix" ];
  };
}
