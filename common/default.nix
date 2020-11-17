pkgs:
let
  unlines = strings:
    with pkgs.lib;
    concatStrings (intersperse "\n" strings);

  isWsl = with builtins; (getEnv "WSL_DISTRO_NAME") != "";

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  isLinux = pkgs.stdenv.hostPlatform.isLinux;

in {

  isWsl = isWsl;
  isDarwin = isDarwin;
  isLinux = isLinux;

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
    ranger
    neovim
    git
    gitAndTools.git-extras
    htop
    highlight
    jq
    fd
    ag
    exa
    zip
    unzip
    ripgrep
  ];

  devTools = with pkgs; {
    jvm-family = [ scala sbt maven metals jdk11 ];

    haskell = let
      compiler = ghc.withPackages (hackage:
        with hackage; [
          ghcide
          hoogle
          hlint
          stylish-haskell
          hpack
        ]);
    in [ stack compiler ];

    c-family = let
      compilers =
        if isWsl then [ gcc ] else if isDarwin then [ ] else [ clang_10 ];
    in [ cmake gnumake clang-tools ] ++ compilers;

    js = [
      nodejs
      deno
      yarn
      yarn2nix
      nodePackages.node2nix
      nodePackages.typescript
    ];

    python = let
      fromPypi = pypi:
        with pypi;
        let
          extras = [
            pip
            pipx
            poetry
            tox
            black
            isort
            boto3
            ipython
            pandas
            matplotlib
            numpy
            scipy
          ];
          nonOSXExtras = if isDarwin then [ ] else [ jupyter jupyterlab ];
          linting = [ mypy flake8 jedi ];
        in builtins.concatLists [ extras linting nonOSXExtras ];

    in [ pipenv (python38.withPackages fromPypi) ];

    nix = [ nixfmt nixpkgs-fmt rnix-lsp ];

    shell = [ nodePackages.bash-language-server ];

    coc-extra-lsps = import ./lsps.nix {
      enabled = [
        haskellPackages.ghcide
        metals
        clang-tools
        rnix-lsp
        nodePackages.bash-language-server
      ];
    };

  };

  nixosPackages = with pkgs; {
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
      spotify
      rofi
      lxappearance
      mate.mate-power-manager
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

    productivityPackages =
      [ polybar font-manager acpi ranger zathura google-chrome ];

    extraDevTools = [ docker ];
  };

  sourceWhenAvaliable = files:
    unlines (map (fp: "[ -e ${fp} ] && source ${fp}") files);

  neovim = {
    package = pkgs.neovim-unwrapped;

    configure = {
      customRC = builtins.readFile ./minimal.vim;

      packages.myVimPackages = with pkgs.vimPlugins; {
        start = [
          ctrlp
          nerdcommenter
          nerdtree
          vim-surround
          vim-repeat
          rainbow_parentheses
          vim-nix
          vim-indent-guides
          elm-vim
          plantuml-syntax
          typescript-vim
          vim-scala
          kotlin-vim
          coc-nvim
        ];

        opt = [ ];
      };

    };
  };

}
