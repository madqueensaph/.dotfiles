# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"
gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg &> /dev/null

if [ -z "$(pidof emacs)" ]
then
    emacs --daemon &
fi

if [ "$(tty)" == "/dev/tty1" ]
then
    startx
fi
