# Possibly reasonable aliases
alias ls="/bin/ls --color=auto"
alias path="echo ${PATH} | tr ':' '\n'"
alias feh="/usr/bin/feh --force-aliasing"
alias datenow="date +'%A, %B %d, %Y%n%I:%M:%S %p'"
alias untar="tar -xf"
alias svim="sudoedit"
alias l="/bin/ls --color=auto -al"
alias m="cmus"
alias ydl="yt-dlp -x --audio-format vorbis --no-playlist"
alias um="sudo umount ${HOME}/Mount/"
alias kb="xset r rate 200 75; setxkbmap -option caps:escape"
alias java="/opt/openjdk-bin-17/bin/java"
alias view-emerge="clear && sudo tail -F /var/log/emerge.log"
alias config="/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"

man() {
	LESS_TERMCAP_md=$'\e[01;36m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;47;30m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;33m' \
	command man "$@"
}
