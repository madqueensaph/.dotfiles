#!/bin/bash

#
# mpdstatus.sh
# ---------
# display status stuff for the Music Player Daemon in a more fancy output
#

SEPARATOR='\e[1;96m-----------------------------------------------------------'\
'-----------'

ALBUM_NAME="$(   mpc status |
                grep 'ogg' |
                awk -F '/' '{print $1}'
            )"
SONG_NAME="$(   mpc status |
                grep 'ogg' |
                awk -F '/' '{print $2}' |
                sed 's/\.ogg//'
            )"
PLAY_STATUS="$( mpc status |
                grep '\[' |
                awk -F ' ' '{print $1}' |
                tr -d '[]'
              )"
TIMESTAMP="$(   mpc status |
                grep '\[' |
                awk -F ' ' '{print $3 " " $4}'
            )"
VOLUME_LEVEL="$(    mpc status |
                    grep 'volume' |
                    sed 's/:/ /g' |
                    awk -F ' ' '{print $2}'
                )"
SINGLE_MODE="$( mpc status |
                grep 'volume' |
                sed 's/:/ /g' |
                awk -F ' ' '{print $8}'
              )"

echo -e "\e[1;96mSong:\e[0;39m $SONG_NAME"
echo -e "$SEPARATOR"
echo -e "\e[1;96mAlbum:\e[0;39m $ALBUM_NAME"
echo -e "$SEPARATOR"
echo -e "\e[1;96mPlayback Status:\e[0;39m ${PLAY_STATUS^}"
echo -e "$SEPARATOR"
echo -e "\e[1;96mPlayback Time:\e[0;39m $TIMESTAMP"
echo -e "$SEPARATOR"
echo -e "\e[1;96mVolume Level:\e[0;39m $VOLUME_LEVEL"
echo -e "$SEPARATOR"
echo -e "\e[1;96mSingle (Repeat) Mode:\e[0;39m ${SINGLE_MODE^}"
