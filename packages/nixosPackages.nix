{ pkgs
, hostPlatform ? import ./hostPlatform.nix { pkgs = pkgs; }
}:
assert hostPlatform.isLinux;
assert !(hostPlatform.isDarwin || hostPlatform.isWsl);
with pkgs; {

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
    arandr
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
    [ polybar font-manager acpi zathura google-chrome ];

  extraDevTools = [ docker ];
}
