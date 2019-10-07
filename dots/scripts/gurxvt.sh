#!/usr/bin/env bash

gurxvt() {
	# set things up
		urxvtc -name ${1}
		PFW="$(xdo id -n ${1})"
		bspc node ${PFW} -t floating -l above -g sticky &&
		bspc config -n ${PFW} border_width ${2}
}

borderColor=$(xrdb -query | grep "*color9" | awk '{print $NF}')

case $1 in
	pullup ) 
			classname="URxvtQuake"
			gurxvt "${classname}" 0 && {
			PFW="$(xdo id -n ${classname})"
			# snap
			snap.sh j ${PFW} "+" && wtf ${PFW} & TPID2=$!
			# wait for the process to complete
			wait ${TPID2}
			} && bspc node -f "${PFW}"
        #bspc config -n  focused_border_color "${borderColor}"
		;;
	center )
			classname="URxvtRun"
			gurxvt "${classname}" 7 && {
			PFW="$(xdo id -n ${classname})"
			wtf ${PFW} & TPID2=$!
			# wait for the process to complete
			wait ${TPID2}
			} && bspc node -f "${PFW}"
        #bspc config -n newer focused_border_color "${borderColor}"
		;;
esac

## TODO: find a way to make this togglable
