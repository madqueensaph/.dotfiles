#!/bin/bash

playerctl -a stop

muted=$(pacmd list-sinks | grep -A 15 '* index' | \
	awk '/muted:/{ print $2 }')

if [[ "$muted" == "no" ]]
then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
	muted="script"
fi

str=$(echo -e "\n$(uname -nr)\n$(whoami)")
physlock -p "$str"

if [[ "$muted" == "script" ]]
then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
fi
