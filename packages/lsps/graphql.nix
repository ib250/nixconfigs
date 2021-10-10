drv: {
  graphql = {
    command = "graphql-lsp";
    args = ["server" "-m" "stream"];
    filetypes = ["typescript" "typescriptreact" "javascript" "javascriptreact" "graphql"];
  };
}
