{pkgs}:
pkgs.mkShell {
  NIX_CONFIG = "experimental-features = nix-command flakes";
  NIXPKGS_ALLOW_UNFREE = "1";
  buildInputs = with pkgs; [git fd exa silver-searcher coreutils zsh];
}
