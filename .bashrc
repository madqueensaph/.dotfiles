#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[0;91m\][\[\e[1;92m\]\u\[\e[0;91m\]:\[\e[0;93m\]\W\[\e[0;91m\]]\[\e[0;39m\]$ '

export PATH="$PATH:${HOME}/.local/bin:${HOME}/.emacs.d/bin"
export LS_COLORS="di=1;94"

if [ -f "${HOME}/.bash_aliases" ]
then
	. "${HOME}/.bash_aliases"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
