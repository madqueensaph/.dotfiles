#!/bin/bash

if [[ -z "$1" ]]; then

	echo "Please specify Window Manager to launch"
	exit 1
fi

Xephyr -ac -noreset -screen 1280x720 :5 &

sleep 1

DISPLAY=:5 "$1"

pkill Xephyr
