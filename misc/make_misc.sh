#! /usr/bin/env bash


make_term_colors() {

    mkdir -p ~/.termcolors
    for i in $(ls termcolors)
    do
        cp -s $(pwd)/termcolors/${i} ~/.termcolors/${i}
    done

}


make_xresources() {

    mkdir -p ~/.xrdb.d
    for i in $(ls xrdb.d)
    do
        cp -s $(pwd)/xrdb.d/${i} ~/.xrdb.d/${i}
    done
    cp $(pwd)/Xresources ~/.Xresources

}

make_scripts() {

    mkdir -p "~/.local/bin"
    for i in $(ls scripts)
    do
        cp -s $(pwd)/scripts/${i} ~/.local/bin/${i}
    done

}


case ${1} in
    termcolors ) make_term_colors;;
    xresources ) make_xresources;;
    scripts ) make_scripts;;
    pretzo ) ./pretzo/make_pretzo_config.sh;;
esac
