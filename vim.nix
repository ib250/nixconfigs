
with import <nixpkgs> {};

let
    isRoot = builtins.getEnv "USER" == "root";

    nonRoot =
        if isRoot then {
            usePlugins = [];
            extraVimrc = "";
            loadPlugins = [];
        } else {

            extraVimrc = "";
            usePlugins = [
                "UltiSnips" "vim-snippets"
                "Solarized" "vim-addon-nix"
                "vim-addon-completion"
                "vim-addon-manager"
            ]; 

            loadPlugins = [
                { name = "vimtex";
                  ft_regex = "^tex\$";
                }

                { name = "flake8-vim";
                  ft_regex = "^python\$";
                }

                { names = ["vim2hs" "haskell-vim" "Hoogle"];
                  ft_regex = "^haskell\$";
                }
            ];
        };

in vim_configurable.customize {
    # Specifies the vim binary name.
    # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
    # This allows to have multiple vim packages installed
    # (e.g. with a different set of plugins)
    
    name = "vim_custom_minimal";

    vimrcConfig.customRC = # ~/.vimrc
        ''${builtins.readFile ./vimrc_minimal}
          ${nonRoot.extraVimrc}'';

    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;

    vimrcConfig.vam.pluginDictionaries = [
        { names = [
            "Syntastic" "ctrlp"
            "The_NERD_Commenter"
            "The_NERD_tree" "surround"
            "rainbow_parentheses" "vim-nix"
            "vim-indent-guides" "vim-repeat"
            ] ++ nonRoot.usePlugins;
        }
    ] ++ nonRoot.loadPlugins;
}
