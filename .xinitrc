#!/bin/bash

#
# ".xinitrc"
#

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export SPICE_NOGRAB=1
export NO_AT_BRIDGE=1
#export DRI_PRIME=1
export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/radeon_icd.i686.json:"
export VK_ICD_FILENAMES+="/usr/share/vulkan/icd.d/radeon_icd.x86_64.json"

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

# if on laptop (will be removed later)
if [ "$HOSTNAME" == "msi-alpha17" ]
then
    # set output order and resolution
    xrandr --output HDMI-A-1-0 --mode 1920x1080 --left-of eDP
    xrandr --output DisplayPort-1-0 --mode 1920x1080 --left-of HDMI-A-1-0
    # set the primary display
    xrandr --output HDMI-A-1-0 --primary
    export DXVK_FILTER_DEVICE_NAME="AMD Radeon RX 5600M"
elif [ "$HOSTNAME" == "saph-gentoo-pc" ]
then
    xrandr --output DisplayPort-0 --mode 1920x1080 --rate 180 --primary
    xrandr --output HDMI-A-0 --mode 1920x1080 --left-of DisplayPort-0
    xrandr --output HDMI-A-1-1 --mode 1920x1080 --right-of DisplayPort-0
    export DXVK_FILTER_DEVICE_NAME="AMD Radeon RX 7900 XT"
fi

# load X resource properties into the X resource database
xrdb "${HOME}"/.xresources

# load compositor for (customizably) fancy effects
picom --config "${HOME}/.config/picom/picom.conf" &

# load the network manager applet to show connection status in system tray
nm-applet &

# load the PulseAudio applet to show volume status in system tray
pasystray &

# load GNOME Authentication Agent so a graphical prompt pops up, helps reduce
# the use of "sudo" by providing user's password
/usr/libexec/polkit-gnome-authentication-agent-1 &

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
