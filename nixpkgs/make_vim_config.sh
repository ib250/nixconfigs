#! /usr/bin/env bash

__USAGE__="
./make_vim_config.sh: links approprate configurations and setups for vim
"


make_vim_config() {

    status_=1
    rcend="
    source $(pwd)/vimrc_minimal
    \" add new stuff here
    "

    mkdir -p ~/.vim/bundle

    [ -d ~/.vim/bundle/Vundle.vim ] || {

        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || {
        status_=0
                echo "couldn't find vundle and was unable to clone into .vim"
                exit status_
            }

    } && echo "Vundle already found..."


    [ -e ~/.vimrc ] && echo "An existing vimrc aready found" || {

        cp vimrc_vundle ~/.vimrc || {
            status_=0
            echo "unable to create template vimrc"
            exit status_
        }

        echo ${rcend} >> ~/.vimrc

    }


    [ ${status_} -eq 1 ] && vim "+:PluginInstall"

}



[ ${1} ] || {
    make_vim_config 
} && {
    echo ${__USAGE__}
}
