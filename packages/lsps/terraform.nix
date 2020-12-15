drv: {
  terraform = {
    command = "${drv}/bin/terraform-lsp";
    filetypes = [ "terraform" "tf" ];
    initializationOptions = {};
    settings = {};
  };
}
