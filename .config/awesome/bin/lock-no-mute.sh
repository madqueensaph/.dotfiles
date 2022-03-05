#!/bin/bash

str=$(echo -e "\n$(uname -nr)\n$(whoami)")
physlock -p "$str"
