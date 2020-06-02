{ pkgs, ... }: {

  isDarwin = with pkgs.lib; hasInfix "darwin" pkgs.system;

  isWsl = with builtins; (getEnv "WSL_DISTRO_NAME") != "";

  basics = with pkgs; [
    awscli
    gawk
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
  ];

  compilers = with pkgs; [
    scala
    sbt
    maven
    metals

    stack
    (ghc.withPackages (hackage: [ hackage.ghcide ]))

    cmake
    gnumake
    clang-tools
    gcc
  ];

  nixos-core = with pkgs; [
    zsync
    binutils
    autoconf
    gnumake
    fuse
    glib
    openssl
    libtool
    inotify-tools
    lz4
    desktop_file_utils
    cairo
    libarchive
    automake
    manpages
    pstree
  ];

  pythonTooling = let
    default-python =
      pkgs.python38.withPackages (pypi: with pypi; [ pip jedi mypy ]);
  in with pkgs; [ black pipenv poetry default-python ];

  jsTooling = with pkgs; [ nodejs ];

  zsh = let
    zplugWithPlugins = plugins:
      with pkgs.lib;
      let
        plugged = concatStrings
          (intersperse "\n" (map (plugin: ''zplug "${plugin}"'') plugins));
      in ''
        source ${pkgs.zplug}/init.zsh
        ${plugged}
        zplug load
      '';

  in {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    sessionVariables = { EDITOR = "nvim"; };

    initExtra = let

      plugins = zplugWithPlugins [
        "mafredri/zsh-async"
        "sindresorhus/pure"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "zdharma/fast-syntax-highlighting"
      ];

    in ''
      autoload bashcompinit && bashcompinit
      autoload -U promptinit && promptinit

      ${plugins}

      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode

      [ -e ~/.smoke ] && source ~/.smoke
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
