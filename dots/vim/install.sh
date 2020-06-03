#!/usr/bin/env bash

function install_plugins() {
    editor_name=$1
    shift
    for p in "$@"
    do
        case ${p} in
            basics ) coc_basics "$editor_name";;
            * ) coc_custom "${p}" "$editor_name";;
        esac
    done

}


function for_vim() {
    rm -rf ${HOME}/.vim
    rm -rf ${HOME}/.config/coc
    cp -f $(pwd)/minimal.vim ${HOME}/.vimrc
    install_plugins --vim "$@"
}


function for_nvim() {
    rm -rf ${HOME}/.config/coc
    rm -rf ${HOME}/.config/nvim
    mkdir -p ${HOME}/.config/nvim
    rm -rf ~/.local/share/nvim
    cp -f $(pwd)/minimal.vim ${HOME}/.config/nvim/init.vim
    install_plugins --nvim "$@"
}


function _coc_config() {
    case ${1} in
        --vim ) echo "${HOME}/.vim/coc-settings.json";;
        --nvim ) echo "${HOME}/.config/nvim/coc-settings.json";;
    esac
}


function coc_basics() {
    cbs="CocInstall coc-json coc-yaml coc-python coc-tsserver coc-marketplace coc-vimlsp"

    case ${1} in
        --vim ) vim -c "${cbs}";;
        --nvim ) nvim -c "${cbs}";;
    esac
}


function coc_custom() {
    # coc_custom <lsp-bin> [ --vim | --nvim ]
    config_path="$(_coc_config ${2})"
    which ${1} && {
        $(pwd)/coc_with_config.js ${config_path} "$(which ${1})"
    } || echo "could not find executable for ${1}"
}


function usage() {
    echo "

$0 target [... (basics | lsp-programs)]
    
    install vimrc and a list of lsp-programs

$0 add-plugins (--vim | --nvim) [... (basics | lsp-programs)]

    add the lsp-programs to the current configuration

"
}

case ${1} in
    --vim ) shift && for_vim "$@";;
    --nvim ) shift && for_nvim "$@";;
    add-plugins ) shift && install_plugins "$@";;
    * | --help | -h ) usage;;
esac
