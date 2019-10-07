
#! /usr/bin/env bash

[ -e "${ZDOTDIR:-$HOME}/.zpretzo" ] || {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || {
        echo "unable to clone pretzo, probable you already have this available..."
    }
}


for rcfile in $(ls z*);
do
    [ -e ~/.${rcfile} ] || {
        cp -sf $(pwd)/${rcfile} ~/.${rcfile}
    } && {
        echo "~/.${rcfile} is already available, skipping..."
    }

done


[ -e ${HOME}/.bash_aliases ] || {
    cp -s $(pwd)/bash_aliases ${HOME}/.bash_aliases
}
