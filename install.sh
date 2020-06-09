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


function main() {
    for step in $@
    do
        case $step in
            link-home ) link-configs home;;
            link-nix ) link-configs nixos;;
            clean ) clean-configs;;
            * ) echo "options supported: [link-home | link-nix | clean]";;
        esac
    done
}


main $@
