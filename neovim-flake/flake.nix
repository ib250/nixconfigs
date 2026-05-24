{
  description = "Neovim derivation based on nightly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # NOTE(broken): neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-appimage.url = "github:ralismark/nix-appimage";
    nix-appimage.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      # NOTE(broken): neovim-nightly-overlay,
      nix-appimage,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      named = drv: {
        name = drv.pname or drv.name;
        value = drv;
      };

      matches = regex: string: !(isNull (builtins.match regex string));
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # NOTE(treesitter): this allows the queries to be bundled into nvim-treesitter
        # for the parsers themselves, we need to handle that separately
        nvim-treesitter-package = with pkgs.vimPlugins; nvim-treesitter.withAllGrammars;

        # NOTE(broken): neovim-nightly-overlay.packages.${system}.default;
        _neovim = pkgs.neovim;
      in
      {
        packages = rec {
          default = pkgs.buildEnv {
            pname = "nvim";
            inherit (_neovim) version;
            name = "neovim-nightly-env";
            paths =
              let
                plugins = with pkgs.vimPlugins; {
                  start = map named [
                    nvim-treesitter-package
                    nvim-treesitter-context
                    nvim-treesitter-textobjects

                    nvim-origami

                    oil-nvim
                    guess-indent-nvim
                    rose-pine

                    which-key-nvim
                    comment-nvim
                    todo-comments-nvim

                    plenary-nvim
                  ];

                  opt = map named [
                    gitsigns-nvim

                    telescope-nvim
                    telescope-frecency-nvim
                    telescope-fzf-native-nvim
                    telescope-ui-select-nvim

                    nvim-lspconfig
                    blink-cmp

                    clangd_extensions-nvim
                    rustaceanvim
                    vim-just

                    sqlite-lua
                  ];
                };

                start = pkgs.linkFarm "opt-start-contents" (builtins.listToAttrs plugins.start);

                opt = pkgs.linkFarm "opt-opt-contents" (builtins.listToAttrs plugins.opt);

                # NOTE: bundle the parsers in a single directory
                # so we can add it somewhere in packpath/start
                ts-grammars =
                  with nvim-treesitter-package.passthru;
                  pkgs.symlinkJoin {
                    name = "nvim-treesitter-grammars";
                    paths = dependencies;
                  };

                packdir = pkgs.runCommand "neovim-nightly-env-plugins" { } ''
                  mkdir -p $out/opt/pack/nightly-plugin/{start,opt}

                  ln -snf ${start}/* $out/opt/pack/nightly-plugin/start/
                  ln -snf ${ts-grammars} \
                    $out/opt/pack/nightly-plugin/start/${ts-grammars.name}

                  ln -snf ${opt}/* $out/opt/pack/nightly-plugin/opt/
                '';

                cfgdir = pkgs.runCommand "neovim-nightly-appconfig" { } ''
                  mkdir -p $out/opt/config/nvim
                  ln -snf ${./config}/nvim/* $out/opt/config/nvim/
                  ln -snf ${packdir}/opt/pack $out/opt/config/nvim/

                  mkdir -p $out/opt/config/nvim/{parser,queries}
                  ln -snf ${ts-grammars}/parser/* $out/opt/config/nvim/parser/
                  ln -snf ${ts-grammars}/queries/* $out/opt/config/nvim/queries/
                '';
              in
              [
                _neovim
                pkgs.tree-sitter
                pkgs.nixfmt
                pkgs.nil
                pkgs.lua-language-server
                pkgs.luajitPackages.luacheck
                pkgs.stylua
                pkgs.statix
                pkgs.bash-language-server
                pkgs.efm-langserver
                packdir
                cfgdir
              ];
          };

          nvim = default;

        }
        // pkgs.lib.optionalAttrs (matches "^.*-linux" system) {
          appimage =
            with nix-appimage.lib.${system};
            mkAppImage {
              program = "${nvim}/bin/nvim";
            };

        };

        devShells = {
          default = pkgs.mkShell {
            name = "nvim-devShell";
            buildInputs = with self.outputs.packages.${system}; [
              nvim
              (pkgs.writeScriptBin "nvim.test"
                # bash
                ''
                  export XDG_CONFIG_HOME=${nvim}/opt/config
                  ${nvim}/bin/nvim "$@"
                ''
              )
            ];
          };
        };
        formatter = pkgs.nixfmt;
      }
    );
}
