#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

export LANG=el_GR.UTF-8
export LC_NUMERIC=C

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# a possible fix for java apps
export _JAVA_AWT_WM_NONREPARENTING=1
wmname LG3D

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option grp:caps_toggle us,el
xsetroot -cursor_name left_ptr
xset -b
numlockx on
sh ~/.fehbg &
dropbox &
transmission-gtk &
urxvt &
volumeicon &
exec awesome
