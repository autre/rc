#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export LANG=el_GR.UTF-8
export LC_ALL=el_GR.UTF-8
export LC_CTYPE=el_GR.UTF-8
export LANGUAGE=el_GR.UTF-8
export LC_NUMERIC=C

# a possible fix for java apps
export _JAVA_AWT_WM_NONREPARENTING=1

test -f ~/.Xdefaults && xrdb ~/.Xdefaults
test -f ~/.Xresources && xrdb -merge ~/.Xresources
setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option grp:caps_toggle us,el
xsetroot -cursor_name left_ptr
xset -b

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
	--expand true --width 10 --transparent true --tint 0x191970 --height 19 &

eval `cat ~/.fehbg` &

dropboxd &
pidgin &
transmission-gtk &
gnome-terminal --hide-menubar&

exec xmonad

