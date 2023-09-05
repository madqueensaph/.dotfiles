#!/bin/bash

#
# ".xinitrc"
#

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export SPICE_NOGRAB=1
export NO_AT_BRIDGE=1
#export DRI_PRIME=1
#export DXVK_FILTER_DEVICE_NAME="NAVI10"

# load system xinitrc files
if [ -d /etc/X11/xinit/xinitrc.d ]
then
	for f in /etc/X11/xinit/xinitrc.d/*
	do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# turn Caps Lock into a second Escape button
setxkbmap -option caps:escape
# change delay before repeated keys to 200 ms and repeat it 75 times a second
xset r rate 200 75

# turn off screensaver and power saving features
xset s off -dpms

# set TV output to be left of laptop screen
xrandr --output HDMI-A-1-0 --mode 1920x1080 --left-of eDP
# set laptop screen to be the primary display for the X server
xrandr --output eDP --primary

# load X resource properties into the X resource database
xrdb "${HOME}"/.xresources

# load compositor for (customizably) fancy effects
picom --config "${HOME}/.config/picom/picom.conf" &

# load Xfce4 Power Manager to handle things like when to turn off the screen
xfce4-power-manager &

# load the daemon for Urxvt
#urxvtd &

# load the network manager applet to show connection status in system tray
nm-applet &

# load the PulseAudio applet to show volume status in system tray
pa-applet --disable-key-grabbing &

# load GNOME Authentication Agent so a graphical prompt pops up, helps reduce
# the use of "sudo" by providing user's password
/usr/libexec/polkit-gnome-authentication-agent-1 &

# load keyring daemon to handle cryptography stuff
eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"

# default to AwesomeWM unless a WM is specified at the command line
SESSION=${2:-awesome}
RETURN_VAL=-1

# for when the WM decides to fuck up, just kill it and keep everything else up
while [ $RETURN_VAL != 0 ]
do
    # launch the WM specified in the "SESSION" variable
    "$SESSION"; EXIT_CODE=$?
    if [ "$EXIT_CODE" == 0 ]
    then
        break
    fi
done

# avoid 7000 audio sinks in PulseAudio stuff
pactl unload-module module-remap-sink
