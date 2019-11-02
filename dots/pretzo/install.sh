
#! /usr/bin/env bash

function install() {

    [ -e "${ZDOTDIR:-$HOME}/.zpretzo" ] || {
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || {
            echo "unable to clone pretzo, probable you already have this available..."
        }
    }
    
    
    for rcfile in $(ls z*);
    do
        [ -e ~/.${rcfile} ] || {
            ln -sf $(pwd)/${rcfile} ~/.${rcfile}
        } && {
            echo "~/.${rcfile} is already available, skipping..."
        }
    
    done
    
    
    [ -e ${HOME}/.bash_aliases ] || {
        ln -sf $(pwd)/bash_aliases ${HOME}/.bash_aliases
    }

}

USAGE="
${0} will symlink latest zpretzo config
"

case ${1} in
    --help | -h ) echo ${USAGE};;
    * ) install;;
esac
				
