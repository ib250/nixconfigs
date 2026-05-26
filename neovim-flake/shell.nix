{ pkgs, nvim }:

pkgs.mkShell {
  name = "nvim-devShell";
  buildInputs = [
    nvim
    (
      pkgs.writeScriptBin "nvim.test"
      # bash
      ''
        export XDG_CONFIG_HOME=${nvim}/opt/config
        ${nvim}/bin/nvim "$@"
      ''
    )
  ];
}
