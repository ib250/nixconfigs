
#! /usr/bin/env bash

[ -e "${ZDOTDIR:-$HOME}/.zpretzo" ] || {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || {
        echo "unable to clone pretzo, probable you already have this available..."
        exit
    }
}


for rcfile in $(ls z*);
do
    [ -e ~/.${rcfile} ] || {
        cp -s $(pwd)/${rcfile} ~/.${rcfile}
    } && {
        echo "~/.${rcfile} is already available, skipping..."
    }

done
