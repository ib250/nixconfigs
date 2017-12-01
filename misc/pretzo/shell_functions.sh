# some possibly useless functions

ddboot() {
	# reminder for bootable stuff
	echo "dd bs=\$\3 if=\$\1 of=\$\2 status=progress && sync"
}

# not much use now that i've got locate but...
doihave() {
	# the 2 input case
	[[ $# == 2 ]] &&	ls --all $1 | grep -i $2
	# the one input case
	[[ $# == 1 ]] && ls --all $(pwd) | grep -i $1
}

fehwall() {
	comptontoggle start
	case $1 in
		blur )
			usethisone="$HOME/.wall.png"
			;;
		sharp )
			usethisone="$HOME/.sharp.png"
			;;
		* )
			usethisone="$HOME/.wall.png"
			;;
	esac
	feh --bg-fill "${usethisone}"
}

# set blurred wallpaper
setblurredwall() {
	# 2 input case
	[[ $# == 2 ]] && hsetroot -fill $1 -blur $2
	# 1 input case
	[[ $# == 1 ]] && hsetroot -fill $1 -blur 3
	# 0 input case
	[[ $# == 0 ]] && {
		hsetroot -fill $(tail -n 1 ~/.fehbg | awk '{print $NF}' | sed -e "s/'//g") -blur 20
	}
}

showwall() {
	feh $(tail -n 1 ~/.fehbg | awk '{print $NF}' | sed -e "s/'//g")
}

colorblocks() {
	 NAMES="█████"
	 #NAMES=">>"
    for f in $(seq 0 7); do
        echo -en "\033[m\033[$(($f+30))m ${NAMES}" # normal colors
    done
    echo	
    for f in $(seq 0 7); do
        echo -en "\033[m\033[1;$(($f+30))m ${NAMES}" # bold colors
    done
    echo -e "$rst\n"
}

# something to see how fonts behave on term
somechars() {
	echo "
THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG
the quick brown fox jumps over the lazy dog
1234567890
!\"£$%^&*():{}@~<>?,.¬\`|\\\?/=-+_
	"
}

# dump a list of packages
pacmanEmList() {
	packages="$HOME/packageList"
	[ -e "${packages}" ] && rm -f ${packages}
	pacman --query > ${packages}
}

# simple function to connect and disconnect HDMI
connectHDMI() {
	case $1 in
		+ )
			xrandr --output HDMI1 --auto --below eDP1
			export mymonitor="HDMI1"
			;;
		- )
			xrandr --output HDMI1 --off
			export mymonitor="eDP1"
			;;
		* )
			echo "Invalid input use + to connect and - to disconnect"
			;;
	esac
	blend
}

# dump the blurred wall
walldump() {
	# in and out
	inputimg="$(tail -n 1 ~/.fehbg | awk '{print $NF}' | sed -e "s/'//g")"
	outputimg="$HOME/.wall.png"
	# conversion:
	[[ $1 = all ]] && convert -blur 50x50 ${inputimg} ${outputimg}
	# symlink orginal
	ln -s "${inputimg}" "$HOME/.sharp.png"
}

comptontoggle() {
		case $1 in
			start ) pgrep compton || compton;;
			stop ) pgrep compton && pkill compton;;
			* ) pgrep compton && pkill compton || compton;;
		esac &> /dev/null
}

startmatlab() {
	# found that some java annoyances persist without this
	bspc desktop -l monocle && {
	wmname LG3D && export _JAVA_AWT_WM_NONREPARENTING=1 && matlab "$@"
	}
}

makecolors() {
	printheader() {
		echo "! $@ \n! bg fg blk bblk wht red grn ylw blu mag cyn"
	}
	makeandlink() {
		pathprefix="/home/ismail/.GitDots/ib250/${1}"
		printheader ${1} > ${pathprefix}
		ln -s ${pathprefix} $HOME/.termcolors/.
	}
	[ $# -eq 0 ] && echo "Must specify filename" || {
		for i in "$@" ; do
			makeandlink ${i}
		done
	}
}

mypdflatex() {
	pdflatex -syntex=1 -interaction=nonstopmode "$(find . -name "*.tex")"
}

mylualatex() {
	lualatex -syntex=1 -interaction=nonstopmode "$(find . -name "*.tex")"
}

mybibtex() {
	bibtex "$(find . -name "*.aux")"
}

#updatezathurarc() {
	#currbg=$(cat $HOME/.config/zathura/zathurarc.base | grep -i "default-bg" | awk '{print $NF}' | uniq)
	#currfg=$(cat $HOME/.config/zathura/zathurarc.base | grep -i "default-fg" | awk '{print $NF}' | uniq)
	#[ -e "$HOME/.config/zathura/zathurarc" ] && rm $HOME/.config/zathura/zathurarc
	#cat $HOME/.config/zathura/zathurarc.base | sed -e "s/"${currbg}"/\""${barBG}"\"/;
																 #s/"${currfg}"/\""${barFG}"\"/" > $HOME/.config/zathura/zathurarc
#}

lowerbar() {
	barid="$(xdo id -a mybar)"
	rootid="$(xdo id -a eDP1)"
	xdo below -t "${rootid}" "${barid}"
}


ofoam() {
  source /opt/OpenFOAM/OpenFOAM-3.0.1/etc/bashrc 
  PATH=/opt/paraview/bin:${PATH}
}

movebooks() {
  echo "Found: \n"
  exa -l *.${1} && {
    mv *.${1} $HOME/.Library
  }
}

haskeleton() {
  stack new haskeleton
  rename haskeleton ${1} haskeleton
  cat ${1}/haskeleton.cabal | \
    sed -e "s/haskeleton/${1}/g" \
    > ${1}/${1}.cabal
  rm -rf ${1}/haskeleton.cabal
  echo "\nGo on then..."
  exa -T ${1}
}

clean_src() {
  rm $(find -depth -name ${1} | xargs) && {
    exa -T .
  } || {
    echo "Nothing to clean"
  }
}

show_imports() {
  grep "import" $(find -depth -name ${1} | xargs)
}

interracts() {
  jupyter notebook --NotebookApp.iopub_data_rate_limit=1e10 $*
}
