#!/usr/bin/env nix-shell
#! nix-shell -i zsh

__USAGE__="
${0} [... options]
options supported:
link-home:              link relevant configs for dotfiles
link-nix:               link relevant configus for nixos (nixos only)
set-[nvim | vim]-lsps:  setup coc extra configuration for vim or nvim
clean:                  delete current configurations
show:                   show links to current configuration
set-channels:           setup nix channels
home-manager-install:   install home-manager
switch:                 home-manager switch via home-manager channel
"

function link-configs() {
    case $1 in
        home ) cp -rsf $(pwd)/{home.nix,common} ~/.config/nixpkgs/.;;
        nixos ) cp -rsf $(pwd)/{configuration.nix,common} /etc/nixos/.;;
        * ) echo "link options: home | nixos";;
    esac
}


function clean-configs() {
    rm -rf ~/.config/{nvim,coc} ~/.vim
}


function set-lsps() {
    case $1 in
        --nvim ) mkdir -p ~/.config/nvim
            coc-extra-lsps | jq > ~/.config/nvim/coc-settings.json
            ;;
        --vim ) mkdir -p ~/.vim
            coc-extra-lsps | jq > ~/.vim/coc-settings.json
            ;;
    esac
}


function set-channels() {
    nix-channel --add ${HOME_MANAGER} home-manager
    nix-channel --add ${NIXPKGS} nixpkgs
    nix-channel --add ${POETRY2NIX} poetry2nix
    nix-channel --update
}


function home-manager-install() {
    [ -e "$(which home-manager)" ] && {
        echo "home-manager is already installed, to update, uninstall first"
        exit 1
    }

    case ${CHATTY} in
        yes | 1 ) nix-shell --verbose --show-trace ${HOME_MANAGER} -A install;;
        no | * ) nix-shell ${HOME_MANAGER} -A install;;
    esac
}

function show-configs() {
    exa -T ~/.config/nixpkgs
    [ -e /etc/nixos ] && nix run nixpkgs.exa -c exa -T /etc/nixos
}


function main() {
    for step in $@
    do
        case $step in
            link-home ) link-configs home;;
            link-nix ) link-configs nixos;;
            set-nvim-lsps ) set-lsps --nvim;;
            set-channels ) set-channels;;
            set-vim-lsps ) set-lsps --vim;;
            clean ) clean-configs;;
            switch ) nix run home-manager.home-manager -c home-manager switch;;
            home-manager-install ) home-manager-install;;
            show ) show-configs;;
            * ) return 1;;
        esac
    done
}


main $@ || echo "${__USAGE__}"
