#!/usr/bin/bash

#
# run.sh
# ------
# simple script for running my Makefile to build a project, then run the program
#

# we need the executable, which i assign to "TARGET" in my Makefile
TARGET="$(grep '^TARGET' ./Makefile | sed 's/TARGET.*= //')"

while(true)
do
    read tmp # sometimes doesn't work with just "read"
    unset tmp

    make &&
    ./"$TARGET"
done
