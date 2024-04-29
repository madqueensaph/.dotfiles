#!/bin/bash

#
# mpdsync
# ---------
# sync files for Music Player Daemon
#

set -x

mpc clear

mpc update

mpc rm main

mpc ls | mpc add

mpc save main

mpc shuffle
