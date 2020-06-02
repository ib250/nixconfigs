{ pkgs, ... }: {

  home.packages = with pkgs;
    let

      basics = [
        awscli
        bashInteractive
        coreutils
        pstree
        zsh
        zplug
        nixfmt
        ranger
        neovim
        git
        htop
        highlight
        jq
        yq
        fd
        ag
        exa
        gnumake
      ];

      compilers = [
        scala
        sbt
        metals
        stack
        cmake
        clang-tools
        gcc
        (ghc.withPackages (hackage: [ hackage.ghcide ]))
      ];

      pythonTooling = let

        default-python =
          python38.withPackages (pypi: with pypi; [ pip jedi mypy ]);

        tooling = [ black pipenv poetry default-python ];

        # because on osx some python tools dont play nice with nix paths
      in (if system == "x86_64-darwin" then [ ] else tooling);

      jsTooling = [ nodejs ];

    in builtins.concatLists [ basics compilers pythonTooling jsTooling ];

  programs.neovim = {
    enable = true;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    sessionVariables = { EDITOR = "nvim"; };

    initExtra = let

      plugins = ''
        source ${pkgs.zplug}/init.zsh

        # this block is in alphabetic order
        zplug "mafredri/zsh-async"
        zplug "sindresorhus/pure"

        zplug "zsh-users/zsh-completions"
        zplug "zsh-users/zsh-autosuggestions"
        zplug "zsh-users/zsh-history-substring-search"

        zplug "zdharma/fast-syntax-highlighting"

        zplug load
      '';

    in with builtins; ''
      # I dont know the best way to do this:
      autoload bashcompinit && bashcompinit
      autoload -U promptinit && promptinit

      ${plugins}

      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode

    '';

    shellAliases = {
      c = "clear";
      ls = "exa";
      l = "exa -l";
      ll = "exa -lah";
      q = "exit";
    };

  };

}
