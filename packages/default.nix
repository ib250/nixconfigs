pkgs:
let

  hostPlatform = import ./hostPlatform.nix { pkgs = pkgs; };

in {

  basics = import ./basics.nix { pkgs = pkgs; };

  devTools = import ./devTools.nix { pkgs = pkgs; };

  nixosPackages =
    import ./nixosPackages.nix { pkgs = pkgs; };

  neovim = import ./neovim.nix { pkgs = pkgs; };

  utils = rec {

    unlines = strings:
      with pkgs.lib;
      concatStrings (intersperse "\n" strings);

    sourceWhenAvaliable = files:
      unlines
      (map (fp: "[ -e ${fp} ] && source ${fp}") files);

    setRangerPreviewMethod = { }:
      let
        setPreview = method:
          "set preview_images_method ${method}";
        previewMethod = setPreview
          (if hostPlatform.isDarwin then
            "iterm2"
          else
            "ueberzug");

        fixUpScript = ''
          cat ~/.config/ranger/rc.conf \
            | sed -e "s/${
              setPreview "w3m"
            }/${previewMethod}/g" \
            > ~/.config/ranger/rc.conf.new
        '';

      in ''
        ${fixUpScript}
        echo "fixed up ranger/rc.conf:"
        $DRY_RUN_CMD diff --color \
          ~/.config/ranger/rc.conf \
          ~/.config/ranger/rc.conf.new || (
          $DRY_RUN_CMD mv -f $VERBOSE_ARG ~/.config/ranger/rc.conf.new \
            ~/.config/ranger/rc.conf
        )
      '';

    vimPluginUtils =
      import ./vimPlugins.nix { pkgs = pkgs; };

  };

}
