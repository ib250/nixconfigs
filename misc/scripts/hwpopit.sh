#!/usr/bin/env bash

barFG=$(xrdb -query | grep "*foreground" | awk '{print $NF}')
barBG=$(xrdb -query | grep "*background" | awk '{print $NF}')

sysInfo() {
	barlength=$(($(hwpopinfo | wc -c)*40/8))
	bare=$((638 - barlength/2))
	(echo "$(hwpopinfo)"; sleep 3) | lemonbar -F ${barFG} -B ${barBG} \
	-f "Misc Fixed:size=9" -g 1000x18+183+5
	#-f "dweep:size=9" -g ${barlength}x18+${bare}+5
}
bspWs() {
	barlength=40
	(echo "%{c} $(bspc wm -g | \
		sed -e "s/:/\n/g" | \
		grep -e "[F|O]" | \
		sed -e "s/[F|O]//g") "; sleep 1) | \
		lemonbar -F ${barFG} -B ${barBG} \
	-f "Misc Fixed:size=9" -g ${barlength}x18+5+5
}

pgrep polybar || {
	case $1 in
		-sys ) sysInfo ;;
		-ws ) bspWs ;;
	esac
}
