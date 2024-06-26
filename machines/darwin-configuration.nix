{pkgs, ...}: {
  users.users."ismailbello".createHome = false;
  users.users."ismailbello".home = "/Users/ismailbello";
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;

  environment = {
    pathsToLink = ["/share/zsh" "/share/doc" "/share/man"];
  };

  nix = {
    settings.trusted-users = ["root" "ismailbello"];
    package = pkgs.nixVersions.git;
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
      "nomachine-enterprise-client"
    ];

    brews = [
      "tmux"
    ];
  };
}
