
#! /usr/bin/env bash

[ -e "${ZDOTDIR:-$HOME}/.zpretzo" ] || {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
}

for rcfile in $(ls z*);
do
    cp -s $(pwd)/${rcfile} ~/.${rcfile}
done
