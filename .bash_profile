# .bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

# Only start services when logging onto TTY1
if [[ $(tty) == "/dev/tty1" ]]
then
		# Start ssh-agent
		if [[ $(pidof pulseaudio) == "" ]]
		then
		    eval "$(ssh-agent -s)"
		fi
		
		# Start Pulseaudio
		if [[ $(pidof pulseaudio) == "" ]]
		then
			pulseaudio --daemonize &
		fi
		
		# Start Emacs
		if [[ $(pidof emacs) == "" ]]
		then
			emacs --daemon &
		fi
fi
