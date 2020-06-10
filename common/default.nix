pkgs:
let

  unlines = strings: with pkgs.lib; concatStrings (intersperse "\n" strings);

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
    htop
    highlight
    jq
    yq
    fd
    ag
    exa
    zip
    unzip
  ];

  devTools = with pkgs; {

    jvm-family = [ scala sbt maven metals jdk11 ];

    haskell = [ stack (ghc.withPackages (hackage: [ hackage.ghcide ])) ];

    c-family = let

      compilers =
        if isWsl then [ gcc ] else if isDarwin then [ ] else [ clang_10 ];

    in [ cmake gnumake clang-tools ] ++ compilers;

    js = [ nodejs yarn yarn2nix nodePackages.serverless nodePackages.node2nix ];

    python = let

      default-python = python38.withPackages (pypi: with pypi; [ pip ipython ]);

    in [ black pipenv poetry default-python ];

    nix = [ nixfmt rnix-lsp ];

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

  zplugrc =
    { plugins ? [ ], sourceWhenAvaliable ? [ ], prelude ? "", epilogue ? "" }:
    let

      declarePlugins = map (plugin: ''zplug "${plugin}"'');

      sourceMaybe =
        unlines (map (fp: "[ -e ${fp} ] && source ${fp}") sourceWhenAvaliable);

      zplugDeclarations = if plugins == [ ] then
        ""
      else ''
        # zplug declarations:

        source ${pkgs.zplug}/init.zsh
        ${unlines (declarePlugins plugins)}
        zplug load
      '';

    in unlines [ prelude zplugDeclarations sourceMaybe epilogue ];

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
          typescript-vim
          vim-scala
          coc-nvim

          coc-json
          coc-yaml
          coc-python
          coc-tsserver
          coc-java

        ];

        opt = [ ];
      };

    };

  };


}
