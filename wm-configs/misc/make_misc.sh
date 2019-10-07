#! /usr/bin/env bash


__USAGE__="
./make_misc.sh <option>
where option = termcolors
             | xresources
             | all
"

make_term_colors() {
    which xrdb && {

        mkdir -p ${HOME}/.termcolors
        for i in $(ls termcolors)
        do
            cp -sf $(pwd)/termcolors/${i} ${HOME}/.termcolors/${i}
        done

    } || echo "you need xrdb installed for this... xrdb not found"
}


make_xresources() {
    which xrdb && {

        mkdir -p ${HOME}/.xrdb.d
        for i in $(ls xrdb.d)
        do
            cp -sf $(pwd)/xrdb.d/${i} ${HOME}/.xrdb.d/${i}
        done
        cp $(pwd)/Xresources ${HOME}/.Xresources

    } || echo "you need xrdb installed for this... xrdb not found"
}



case ${1} in
    termcolors ) make_term_colors;;
    xresources ) make_xresources;;
    all )
        make_term_colors
        make_xresources
        make_scripts

    * ) echo ${__USAGE__};;
esac
