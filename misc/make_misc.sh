#! /usr/bin/env bash


__USAGE__="
./make_misc.sh <option>
where option = termcolors
             | xresources
             | scripts
             | pretzo
             | all
"

make_term_colors() {
    which xrdb && {

        mkdir -p ${HOME}/.termcolors
        for i in $(ls termcolors)
        do
            cp -s $(pwd)/termcolors/${i} ${HOME}/.termcolors/${i}
        done

    } || echo "you need xrdb installed for this... xrdb not found"
}


make_xresources() {
    which xrdb && {

        mkdir -p ${HOME}/.xrdb.d
        for i in $(ls xrdb.d)
        do
            cp -s $(pwd)/xrdb.d/${i} ${HOME}/.xrdb.d/${i}
        done
        cp $(pwd)/Xresources ${HOME}/.Xresources

    } || echo "you need xrdb installed for this... xrdb not found"
}

make_scripts() {
    mkdir -p ${HOME}/.local/bin
    for i in $(ls scripts)
    do
        cp -s $(pwd)/scripts/${i} ~/.local/bin/${i}
    done
}


make_pretzo() {
    which zsh && ./pretzo/make_pretzo_config.sh || {
        echo "you need zsh for this..., zsh not found"
    }
}


case ${1} in
    termcolors ) make_term_colors;;

    xresources ) make_xresources;;

    scripts ) make_scripts;;

    pretzo ) make_pretzo;;

    all )
        make_term_colors
        make_xresources
        make_scripts
        make_pretzo;;

    * ) echo ${__USAGE__};;
esac
