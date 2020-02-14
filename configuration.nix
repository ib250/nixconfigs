# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {

  imports = [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader. 
  boot.kernelModules = [
    "kvm-intel"
    "ipv6"
    "cpufreq_powersave"
    "loop"
    "atkbd"
    "snd_pcm_oss"
    "vboxdrv"
    "vboxnetadp"
    "vboxnetft"
  ];

  boot.extraModulePackages = [ pkgs.linuxPackages.virtualbox ];

  boot.loader = {
    efi.canTouchEfiVariables = false;
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  networking = {
    hostName = "ib250nix";
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" ];
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_GB.UTF-8"; };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # opengl
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    libvdpau
    vaapiVdpau
  ];

  hardware.pulseaudio.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;

    let

      basics = [
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
      ];

      wmRelatedPackages = [
        wget
        sudo
        w3m
        nox
        nix-index
        nix-info
        nixfmt
        manpages
        pulseaudioFull
        pulsemixer
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
        hsetroot
        rxvt_unicode_with-plugins
        unclutter
        xorg_sys_opengl
        wmutils-core
        wmutils-opt
        compton
      ];

      productivityPackages = [
        zsh
        zsh-prezto
        polybar
        font-manager
        acpi
        htop
        git
        exa
        neovim
        ranger
        firefox
        zathura
      ];

      developerTools = [
        gcc9
        clang_9
        clang-tools
        cmake
        nodejs
        stack
        sbt
        scala
        pipenv
        poetry
        python38Full
      ];

    in builtins.concatLists [
      basics
      wmRelatedPackages
      productivityPackages
      developerTools
    ];

  fonts.fonts = with pkgs; [
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = let
    customAliases = {
      c = "clear";
      l = "exa --long --all --git";
      ls = "exa";
      r = "ranger";
      ll = "exa --long --git";
      rmi = "rm -iv";
      cpi = "cp -iv";
      mvi = "mv -iv";
      trls = "exa -T -L 1";
      tree = "exa -T";
      quickLuaTex = "latexmk -lualatex";
      quickPdfTex = "latexmk -pdf";
      q = "exit";
    };

    bashConfig = {
      enableCompletion = true;
      shellAliases = customAliases;
    };

    zhighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "root" "line" ];
    };

    zshConfig = with zhighlighting; {
      enable = true;
      autosuggestions = { enable = true; };
      enableCompletion = true;
      shellAliases = customAliases;
      syntaxHighlighting = zhighlighting;
    };

  in {
    mtr = { enable = true; };
    bash = bashConfig;
    zsh = zshConfig;
    vim = { defaultEditor = true; };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services.openssh.enable = true;
  services.xserver = {

    enable = true;
    layout = "gb";

    libinput.enable = true;
    enableCtrlAltBackspace = true;
    exportConfiguration = true;

    videoDrivers = [ "intel" ];

    displayManager = {

      job = {
        logToFile = true;
        preStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -f -o &";
      };

      sessionCommands = with pkgs; lib.mkAfter "xmodmap ~/.Xmodmap";
      session = [{
        manage = "window";
        name = "bspwm";
        start = ''
          ${pkgs.sxhkd}/bin/sxhkd &
          ${pkgs.bspwm}/bin/bspwm
        '';
      }];

      defaultSession = "none+bspwm";

    };

  };

  services.compton = rec {
    enable = true;
    fade = false;
    shadow = true;
    backend = "xrender";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;

  users.extraUsers.ismail = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "vboxusers" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
