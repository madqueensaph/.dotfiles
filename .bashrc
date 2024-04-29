#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# messy but I like the look of this prompt
PS1='\[\e[0;91m\][\[\e[1;92m\]\u\[\e[1;96m\]@\h\[\e[0;91m\]:\[\e[0;93m\]\W\'\
'[\e[0;91m\]]\[\e[0;39m\]$ '
if [ -n "$SSH_CLIENT" ]
then
    PS1="(ssh)$PS1"
fi

# environment variables
export PATH="${PATH}:${HOME}/.scripts:${HOME}/.bin:${HOME}/.config/emacs/bin"
export LS_COLORS="di=1;94"
export XZ_OPT="-9 -T16"
export GREP_COLORS="ms=01;36"
export HISTCONTROL=ignoreboth:erasedups
export EDITOR="nvim"

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


qrcodegen() {
    command qrencode -o - "$1" | command feh --force-aliasing -
}

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
alias vncviewer='/usr/bin/vncviewer -via 192.168.69.1 localhost:99'
alias fancy-ping='watch -d -n 0.5 ping -D -c2'
alias minecraft_autofarm='ACTIVE_WINDOW=$(xdotool selectwindow); '\
'sleep 2 && xdotool mousedown --window $ACTIVE_WINDOW 1'
alias resmon='tmux new -As ResMon & sleep 0.5 && tmux run-shell "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh" && fg'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
