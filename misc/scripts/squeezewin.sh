#!/usr/bin/env bash

# needs wmutils
# and snap.sh from wmutils contrib

BSPCDF() {
	# shorthand
	bspc config "$@"
}

pmp() {
	# some caps
	ans="$((${1}+${2}))"
	case ${3} in
		-top ) [ ${ans} -lt 20 ] && ans=20 || {
				[ ${ans} -gt 200 ] && ans=200
				} ;;
		-bottom ) [ ${ans} -lt 0 ] && ans=0 || {
				[ ${ans} -gt 200 ] && ans=200
				} ;;
		* ) [ ${ans} -lt 0 ] && ans=0 || {
				[ ${ans} -gt 300 ] && ans=300
				} ;;
	esac
	# result
	echo "${ans}"
}

# querry current values
top_padding_curr="$(BSPCDF top_padding)"
left_padding_curr="$(BSPCDF left_padding)"
right_padding_curr="$(BSPCDF right_padding)"
bottom_padding_curr="$(BSPCDF bottom_padding)"

[ "${1}" = "-fix" ] && {
  case "${2}" in
    -bar|-b ) BSPCDF top_padding "$((${top_padding_curr}-20))" && exit ;;
    +bar|+b ) BSPCDF top_padding "$((${top_padding_curr}+20))" && exit ;;
  esac
} || {
  case "${2}" in
    +bar|+b )
        BSPCDF top_padding $(pmp ${top_padding_curr} ${1} -top) &
        BSPCDF bottom_padding $(pmp ${bottom_padding_curr} ${1} -bottom) &
        ;;
    * ) 
        BSPCDF top_padding $(pmp ${top_padding_curr} ${1} -bottom) &
        BSPCDF bottom_padding $(pmp ${bottom_padding_curr} ${1} -bottom) &
        ;;
  esac

  BSPCDF right_padding $(pmp ${right_padding_curr} ${1}) &
  BSPCDF left_padding $(pmp ${left_padding_curr} ${1}) &
}
