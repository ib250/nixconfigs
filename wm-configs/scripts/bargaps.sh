#!/usr/bin/env bash

# needs polybar
[ -z $(pgrep polybar) ] && {
  polybar example &
  squeezewin.sh -fix +bar && exit
} || {
  pkill polybar
  squeezewin.sh -fix -bar
}
