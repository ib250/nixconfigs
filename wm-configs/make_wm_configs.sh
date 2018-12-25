#! /usr/bin/env bash


__USAGE__="
./make_wm_configs.sh <option>
where
option = bsp | polybar | all
"

make_bsp() {

    which bspc && {

        mkdir -p ~/.config/bspwm
        cp -s $(pwd)/bspwmrc ~/.config/bspwm/bspwmrc && {

            which sxhkd && {
                mkdir -p ~/.config/skhkd
                cp -s $(pwd)/sxhkdrc ~/.config/sxhkd/sxhkdrc || {
                    echo "unable to copy sxhkd config"
                }

            } || echo "sxhkd not found, doing nothing"

        } || echo "unable to copy bspwm configuration"

    } || echo "bspwm not found, doing nothing"

}

make_polybar() {

    which polybar && {

        mkdir -p ~/.config/polybar
        cp -s $(pwd)/polybar_config ~/.config/polybar/config || {
            echo "unable to copy polybar config"
        }

    } || echo "polybar not installed, doing nothing"

}


case ${1} in
    bsp ) make_bsp;;
    polybar ) make_polybar;;
    all ) make_bsp && make_polybar;;
    * ) echo ${__USAGE__};;
esac
