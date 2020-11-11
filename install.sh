#!/usr/bin/env bash


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
    HOME_MANAGER=https://github.com/nix-community/home-manager/archive/master.tar.gz
    NIXPKGS=https://nixos.org/channels/nixos-unstable
    POETRY2NIX=https://github.com/nix-community/poetry2nix/archive/master.tar.gz

    nix-channel --add ${HOME_MANAGER} home-manager
    nix-channel --add ${NIXPKGS} nixpkgs
    nix-channel --add ${POETRY2NIX} poetry2nix
    nix-channel --update
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
            home-manager-install ) nix-shell '<home-manager>' -A install;;
            show )
                nix run nixpkgs.exa -c exa -T ~/.config/nixpkgs
                [ -e /etc/nixos ] && nix run nixpkgs.exa -c exa -T /etc/nixos;;
            * ) echo "options supported: [link-home | link-nix | set-[nvim | vim]-lsps | clean | show | set-channels | home-manager-install]";;
        esac
    done

}


main $@
