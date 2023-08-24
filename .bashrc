#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# messy but I like the look of this prompt
PS1='\[\e[0;91m\][\[\e[1;92m\]\u\[\e[0;91m\]:\[\e[0;93m\]\W\[\e[0;91m\]]'\
'\[\e[0;39m\]$ '

# environment variables
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.emacs.d/bin"
export LS_COLORS="di=1;94"
export XZ_OPT="-9 -T16"

# aliases
alias ls='/bin/ls --color=auto'
alias ll='/bin/ls --color=auto -al'
alias path='echo ${PATH} | tr ":" "\n"'
alias feh='/usr/bin/feh --force-aliasing'
alias ydl='yt-dlp -x --audio-format vorbis --no-playlist'
alias kb='xset r rate 200 75; setxkbmap -option caps:escape'
alias view-emerge='clear && sudo tail -F /var/log/emerge.log'
alias dotf-git='/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'
alias clock='watch -tn .25 date +"%H:%M:%S"'
alias largest-folders='du -Sh ~/ | sort -rh | head -40'
alias scrcpy='/usr/bin/scrcpy --video-bit-rate 2M --max-fps 30 --max-size 900'
alias vncviewer='/usr/bin/vncviewer -FullScreen -FullScreenSystemKeys=0'
alias fancy-ping='watch -d -n 0.5 ping -D -c2'
alias minecraft_autofarm='ACTIVE_WINDOW=$(xdotool selectwindow); '\
'sleep 2 && xdotool mousedown --window $ACTIVE_WINDOW 1'

# change colors for 'man'
man() {
	LESS_TERMCAP_md=$'\e[01;36m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;47;30m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;33m' \
	command man "$@"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
