{ pkgs, ... }: {

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  isWsl = with builtins; (getEnv "WSL_DISTRO_NAME") != "";

  basics = with pkgs; [
    awscli
    wget
    gawk
    coreutils
    binutils
    manpages
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

  nixos-packages = with pkgs; {

    basics = [
      sudo
      zsync
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
    ];

    graphical = [
      w3m
      pulseaudioFull
      pulsemixer
      pamixer
      bspwm
      sxhkd
      rofi
      xorg.xorgserver
      xorg.xdm
      xorg.xinit
      xorg.xrdb
      xorg.xrandr
      xorg.xprop
      xorg.xmodmap
      xorg.xauth
      xorg.xhost
      hsetroot
      rxvt_unicode
      termite
      unclutter
      xorg_sys_opengl
      wmutils-core
      wmutils-opt
      compton
    ];

    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-mono
      fira-code
      fira-code-symbols
      mplus-outline-fonts
      dina-font
      proggyfonts
      siji
      unifont
    ];

    devTools = [ docker ];

  };

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

      ${plugins}

      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode

      autoload bashcompinit && bashcompinit
      autoload -U promptinit && promptinit

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
