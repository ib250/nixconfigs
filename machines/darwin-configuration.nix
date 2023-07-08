{pkgs, ...}: {
  users.users."ismailbello".createHome = false;
  users.users."ismailbello".home = "/Users/ismailbello";
  environment.variables = {
    EDITOR = "nvim";
  };
  environment.systemPackages = [ pkgs.iterm2 ];
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    # nix-darwin 23.05 issue
    extraOptions = ''
      experimental-features = nix-command flakes
      allow-import-from-derivation = true
    '';
  };
}
