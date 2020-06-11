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


function main() {
    for step in $@
    do
        case $step in
            link-home ) link-configs home;;
            link-nix ) link-configs nixos;;
            set-nvim-lsps ) set-lsps --nvim;;
            set-vim-lsps ) set-lsps --vim;;
            clean ) clean-configs;;
            show )
                exa -T ~/.config/nixpkgs
                [ -e /etc/nixos ] && exa -T /etc/nixos;;
            * ) echo "options supported: [link-home | link-nix | set-[nvim | vim]-lsps | clean | show]";;
        esac
    done

}


main $@
