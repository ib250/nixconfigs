# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {

    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];

    # Use the systemd-boot EFI boot loader. 
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        grub = {
            enable = true;
            version = 2;
            device = "/dev/sda";
        };
    };

    # Define your hostname.
    # Enables wireless support via wpa_supplicant.
    networking = {
        hostName = "ib250nix";
        wireless.enable = true;
        useDHCP = true;
        nameservers = [ "8.8.8.8" ];
    };


    # Select internationalisation properties.
    i18n = {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "uk";
        defaultLocale = "en_GB.UTF-8";
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

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
        wget sudo nix-repl w3m

        (import ./vim.nix)

        manpages

        wpa_supplicant_gui
        pulseaudioFull
        vaapiIntel vaapiVdpau
        libvdpau
        libvdpau-va-gl

        rxvt_unicode bspwm-unstable
        sxhkd-unstable rofi unclutter
        xorg.xorgserver xorg.xdm
        xorg.xinit xorg.xrdb
        xorg.xrandr xorg.xprop
        xorg.xmodmap xorg.xauth
        hsetroot
        xorg_sys_opengl wmutils-core
        wmutils-opt compton zsh

        polybar # fonts for polybar
            siji unifont

        font-manager

        acpi htop
        gitAndTools.gitFull

        exa ranger

        ghc stack  # ihaskell
        haskellPackages.hlint

        gcc clang  # cling

        python3Full 
            python36Packages.ipython
            python36Packages.jupyter
            python36Packages.pip
            python36Packages.pylint
            python36Packages.flake8
            python36Packages.virtualenvwrapper

        python  # 2.7 as of
            python27Packages.pip
            python27Packages.pylint
            python27Packages.flake8
            python27Packages.virtualenvwrapper

        firefox 
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs = let
        customAliases = {
            _ = "sudo"; c = "clear";
            l = "exa --long --all --git";
            ls = "exa"; r = "ranger";
            vim = "vim_custom_minimal -U ~/.vimrc";
            ll = "exa --long --git";
            rmi = "rm -iv"; cpi = "cp -iv";
            mvi = "mv -iv";
            sxconf = "cat ~/.config/sxhkd/sxhkdrc \n";
            xsxconf = "vim $HOME/.config/sxhkd/sxhkdrc";
            trls = "exa -T -L 1"; tree = "exa -T";
            quickLuaTex = "latexmk -lualatex";
            quickPdfTex = "latexmk -pdf";
            alsi = "alsi -n"; q = "exit"; };

        shellFunctions =
            builtins.readFile ./shell_functions.sh;

        bashConfig = {
            enableCompletion = true;
            shellAliases = customAliases; }; 

        zhighlighting = {
            enable = true;
            highlighters = [
                "main" "brackets" "pattern"
                "cursor" "root" "line" ]; };

        zshConfig = with zhighlighting; {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            shellAliases = customAliases;
            shellInit = ''${shellFunctions}
                          bindkey jk vi-cmd-mode
                          bindkey kj vi-cmd-mode'';
            syntaxHighlighting = zhighlighting; };
        
        in { mtr = { enable = true; };
             bash = bashConfig;
             zsh = zshConfig;
             vim = { defaultEditor = true; };
             gnupg.agent = {
                 enable = true;
                 enableSSHSupport = true;};
           };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        layout = "gb";
        libinput.enable = true;
        enableCtrlAltBackspace = true;
        exportConfiguration = true;
        videoDrivers = [ "intel" ];
        xkbOptions = "grp:caps_toggle, grp_led:caps, terminate:ctrl_alt_bksp";
        desktopManager.default = "xterm";

        displayManager = {
            lightdm.enable = true;

            job = {
                logsXsession = true;
                preStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -f -o &";
            };

            sessionCommands =
                with pkgs; lib.mkAfter "xmodmap ~/.Xmodmap";

            session = let
                # Xterm session
                xterm_session = {
                    manage = "desktop";
                    name = "xterm";
                    start = ''${pkgs.xterm}/bin/xterm &
                              waitPID=$!'';
                };

                # bspwm session
                bspwm_session = {
                    manage = "window";
                    name = "bspwm";
                    start = ''${pkgs.sxhkd}/bin/sxhkd &
                              ${pkgs.bspwm}/bin/bspwm'';
                };

                # Xmodnad session
                xmonad_session = {
                    manage = "window";
                    name = "xmonad";
                    start = ''xmonad'';
                };

                # expose all
                in [ xterm_session bspwm_session xmonad_session ]; };
                
        windowManager = {
            default = "bspwm";
            bspwm = { enable = true; };

            xmonad = {
                enable = true;
                enableContribAndExtras = true; };
        };
    };

    services.compton = rec {
        enable = false;
        fade = false;
        shadow = true;
        backend = "xrender";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.defaultUserShell = pkgs.zsh;

    users.extraUsers.ismail = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" "video"
                        "networkmanager" ];
    };

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "17.09"; # Did you read the comment?  
}
