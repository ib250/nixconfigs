#!/usr/bin/env bash

# start
function lemstart() {
	currentpadding="$(bspc config -m eDP1 top_padding)"
	bspc config -m eDP1 top_padding $((${currentpadding}+20))
	lemonbuddy_wrapper top
}
# stop
function lemstop() {
	currentpadding="$(bspc config -m eDP1 top_padding)"
	lemonbuddy_terminate noconfirm 
	#&& bspc config -m eDP1 top_padding 0
	#$((${currentpadding}-20))
}
# lower
function lowerbar() {
	barid="$(xdo id -a mybar)"
	rootid="$(xdo id -a eDP1)"
	xdo below -t "${rootid}" "${barid}"
}

export barBG=$(xrdb -query | grep "*background" | awk '{print $NF}')
export barFG=$(xrdb -query | grep "*foreground" | awk '{print $NF}')

source $HOME/.bash_aliases

# zero input case just toggle start stop
case $1 in
	start )
		( pidof lemonbar ) || {
		lemstart
		lowerbar
		}
		;;
	stop ) ( pidof lemonbar ) && {
		lemstop 
		bspc config -m eDP1 top_padding 0
		}
		;;
	toggle )
		( pidof lemonbar ) && lemstop || {
		lemstart
		lowerbar
		}
		;;
	reload|* )
		( pidof lemonbar ) && lemstop &&
		{
			lemstart
			lowerbar
		}
		;;
esac
