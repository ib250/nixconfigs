{ pkgs, ... }: {

  home.packages = with pkgs; [

    coreutils
    pstree

    zsh
    antibody

    jq
    yq
    fd
    ag
    exa

    nixfmt
    gnumake

    ranger
    neovim
    git
    htop

    scala
    metals
    stack
    cmake
    clang-tools
    gcc
    ghc

    black
    pipenv
    poetry
    (python38Full.withPackages (pypi: with pypi; [ pip jedi mypy ]))

    nodejs

    highlight

  ];

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
    initExtra = ''
      source <(antibody init)
      bindkey jk vi-cmd-mode
      bindkey kj vi-cmd-mode
    '';

    shellAliases = {
      c = "clear";
      ls = "exa";
      l = "exa -l";
      ll = "exa -lah";
    };
  };

}
