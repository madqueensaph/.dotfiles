#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]
then
	for f in /etc/X11/xinit/xinitrc.d/*
	do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xinput disable "ETPS/2 Elantech Touchpad"
setxkbmap -option caps:escape
xset r rate 200 75
xset s off -dpms

xrdb "${HOME}"/.xresources

LOCK_STR_NAME=$(echo -e "\n$(uname -nr)\n$(whoami)")
xss-lock -- physlock -p "$LOCK_STR_NAME" &

eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"

picom --config "${HOME}/.config/picom/picom.conf" &
xfce4-power-manager &
nm-applet &
xfce4-clipman &
pa-applet --disable-key-grabbing &

SESSION=${2:-awesome}

case "$SESSION" in
	awesome			) exec awesome;;
	dwm				) exec "$HOME"/.local/bin/dwm;;
	bspwm			) exec bspwm;;
	herbstluftwm 	) exec herbstluftwm;;
	i3 				) exec i3;;
	qtile 			) exec qtile start;;
	xmonad 			) exec xmonad;;
esac
