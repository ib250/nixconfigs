{
  pkgs,
  specialArgs,
  ...
}: let
  inherit (specialArgs) neovim-configured;
in {
  home = {
    packages = with (import ./modules/basics.nix {inherit pkgs;});
      homePackages ++ [neovim-configured pkgs.fh];

    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "${neovim-configured}/bin/nvim";
    };
  };

  programs = {
    htop.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
    };

    ripgrep = {
      enable = true;
    };

    gh = {
      enable = true;
    };

    broot = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {modal = true;};
    };

    home-manager.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config = {
        disable_stdin = false;
        strict_env = true;
      };
    };

    git = {
      extraConfig = {
        user.name = "Ismail Bello";
        core = {
          excludesfile = "$XDG_CONFIG_HOME/git/gitignore.global";
          fsmonitor = true;
          preloadIndex = true;
        };
        maintenance = {
          auto = true;
          strategy = "incremental";
        };
        credential.helper = "store";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      includes = [{path = "~/.gitconfig";}];
    };

    scmpuff.enable = true;
    zoxide.enable = true;
    lf.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    helix = {enable = true;};

    neovim.defaultEditor = true;

    bat = {
      enable = true;
      config = {theme = "Nord";};
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        gcloud = {format = "on [$symbol$account(@$domain/$project)]($style)";};
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
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
        p = "bat";
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
        # not yet supported in hm module
        zplug "plugins/docker", from:oh-my-zsh
        zplug "plugins/docker-compose", from:oh-my-zsh
        zplug install 2> /dev/null
        zplug load

        ${utils.sourceWhenAvaliable [
          "~/.smoke"
          "~/.nvm/nvm.sh"
        ]}

      '';
    };
  };

  nixpkgs.config = {
    allowUnfreePredicate = _: true;
  };

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
}
