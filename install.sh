#!/usr/bin/env bash

__USAGE__="
${0} [... options]
options supported:
link-home:              link relevant configs for dotfiles
link-nix:               link relevant configus for nixos (nixos only)
clean:                  delete current configurations
show:                   show links to current configuration
set-channels:           setup nix channels
home-manager-install:   install home-manager
switch:                 home-manager switch via home-manager channel
"

link-configs() {
    case $1 in
        home ) cp -rsf $(pwd)/{home.nix,packages} ~/.config/nixpkgs/.;;
        nixos ) cp -rsf $(pwd)/{configuration.nix,packages} /etc/nixos/.;;
        * ) echo "link options: home | nixos";;
    esac
}


clean-configs() {
    rm -rf ~/.config/{nvim,coc} ~/.vim
    rm -rf ~/.config/nixpkgs/*
    [ -e /etc/nixos ] && {
        rm -rf /etc/nixos/{configuration.nix,packages}
    } || echo "not a nixos system, skipping system-wide configuration"
}


nix-set-channels() {
    nix-channel --add ${HOME_MANAGER} home-manager
    nix-channel --add ${NIXPKGS} nixpkgs
    nix-channel --add ${POETRY2NIX} poetry2nix
    nix-channel --update
}


home-manager-install() {
    [ -e "$(which home-manager)" ] && {
        echo "home-manager is already installed, to update, uninstall first"
        exit 1
    }

    case ${CHATTY} in
        yes | 1 ) nix-shell --verbose --show-trace ${HOME_MANAGER} -A install;;
        no | * ) nix-shell ${HOME_MANAGER} -A install;;
    esac
}


home-manager-switch() {
    case ${CHATTY} in
        yes | 1 )
            nix run home-manager.home-manager -c \
                home-manager switch --verbose --show-trace;;
        no | * )
            nix run home-manager.home-manager -c home-manager switch;;
    esac
}

show-configs() {
    exa -T ~/.config/nixpkgs
    [ -e /etc/nixos ] && exa -T /etc/nixos || true
}


main() {
    for step in $@
    do
        case $step in
            link-home )
                link-configs home;;
            link-nix )
                link-configs nixos;;
            set-channels )
                nix-set-channels;;
            clean )
                clean-configs;;
            switch )
                home-manager-switch;;
            home-manager-install )
                home-manager-install;;
            show )
                show-configs;;
            * ) return 1;;
        esac
    done
}


main $@ || echo "${__USAGE__}"
