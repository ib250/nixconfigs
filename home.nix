{
  pkgs,
  specialArgs,
  ...
}: {
  home.packages = with (import ./modules/basics.nix {inherit pkgs;}); let
    inherit (specialArgs) neovim-configured;
  in
    homePackages ++ [neovim-configured];

  home.sessionVariables.EDITOR = "nvim";

  programs.broot = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {modal = true;};
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      disable_stdin = false;
      strict_env = true;
    };
  };

  programs.git = {
    extraConfig = {
      user.name = "Ismail Bello";
      credential.helper = "store";
      core.excludesfile = "$XDG_CONFIG_HOME/git/gitignore.global";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    includes = [{path = "~/.gitconfig";}];
  };

  programs.scmpuff.enable = true;
  programs.zoxide.enable = true;
  programs.lf.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.helix = {enable = true;};

  home.stateVersion = "23.05";

  nixpkgs.config = {allowUnfreePredicate = _: true;};
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    allow-import-from-derivation = true
  '';

  xdg.configFile."git/gitignore.global".text = ''
    *~
    *.swp
    .vim
    .nvim
    scratch
    .scratch
    scratch.*
    .roast
    .http
    .DS_Store
  '';

  programs.neovim.defaultEditor = true;

  programs.bat = {
    enable = true;
    config = {theme = "Nord";};
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      gcloud = {format = "on [$symbol$account(@$domain/$project)]($style)";};
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    autocd = true;
    shellAliases = {
      c = "clear";
      ls = "exa";
      l = "exa -l";
      ll = "exa -lah";
      q = "exit";
      tree = "exa -T";
      d = "dirs -v";
      cat = "bat";
      gc = "git commit";
      ga = "git add";
      gb = "git branch";
      gf = "git fetch";
      gps = "git push";
      gm = "git merge";
      gpl = "git pull";
      gsh = "git show";
      ranger = "lf";
    };

    zplug = {
      enable = true;
      plugins = [
        {name = "mafredri/zsh-async";}
        {name = "zsh-users/zsh-completions";}
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "zsh-users/zsh-history-substring-search";}
        {name = "zdharma/fast-syntax-highlighting";}
      ];
    };

    initExtraBeforeCompInit = ''
      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode
    '';

    initExtra = let
      inherit (import ./modules {inherit pkgs;}) utils;
    in ''
      ${utils.sourceWhenAvaliable ["~/.smoke" "~/.nvm/nvm.sh"]}

      # not yet supported in hm module
      zplug "plugins/docker", from:oh-my-zsh
      zplug "plugins/docker-compose", from:oh-my-zsh
      zplug install 2> /dev/null
      zplug load

      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

    '';
  };
}
