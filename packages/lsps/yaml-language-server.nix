drv: {
  yaml-language-server = {
    command = "${drv}/bin/yaml-language-server";
    args = [ "--stdio" ];
    filetypes = [ "yaml" "yml" ];
  };
}
