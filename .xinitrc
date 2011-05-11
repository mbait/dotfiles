#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Set keyboard layout
setxkbmap -model pc105 -layout "us,ru(winkeys)" -option "grp:alt_shift_toggle,grp:led_scroll"
# Merge in defaults and keymaps
[ -f $sysresources ] && /usr/bin/xrdb -merge $sysresources
[ -f $sysmodmap ] && /usr/bin/xmodmap $sysmodmap
[ -f $userresources ] && /usr/bin/xrdb -merge $userresources
[ -f $usermodmap ] && /usr/bin/xmodmap $usermodmap
# Run programs
urxvtd -q -o -f
screen -wipe
screen -list | pgrep irssi || screen -dmS irssi irssi
screen -list | pgrep rtorrent || screen -dmS rtorrent rtorrent 
screen -list | pgrep mcabber || screen -dmS mcabber mcabber

urxvtc -title irssi -e screen -r irssi &
urxvtc -title mcabber -e screen -r mcabber &

xsetroot -cursor_name left_ptr

exec /usr/bin/xmonad

