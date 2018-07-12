#! /usr/bin/env bash

mkdir -p ~/.vim/bundle

[ -d ~/.vim/bundle/Vundle.vim ] || {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
} || {
    echo "Vundle already found..."
}

[ -e ~/.vimrc ] && {
    echo "An existing vimrc aready found"
} || {
    cat ./vimrc_vundle > ~/.vimrc
}
