{pkgs, ...}: {
  users.users."ismailbello".createHome = false;
  users.users."ismailbello".home = "/Users/ismailbello";
  environment.variables = {
    EDITOR = "nvim";
  };
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      allow-import-from-derivation = true
    '';
  };
  homebrew = {
    enable = true;
    casks = [
      "iterm2"
      "docker"
      "cisco-jabber"
    ];

    brews = [
      "tmux"
    ];
  };
}
