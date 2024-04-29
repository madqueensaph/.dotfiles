#
# vncviewtunnel.sh
# ----------------
# security or smth idk
#


#alias vncviewer='/usr/bin/vncviewer -via 192.168.69.1 localhost:99'

USAGE=""
USAGE+='Usage:\n'
USAGE+='\t'$(basename "$0")' REMOTE_ADDR DISPLAY_NUMBER\n'
USAGE+='\t\tview VNC session from REMOTE_ADDR, use display DISPLAY'

EXEC_FILE='/usr/bin/vncviewer'

if [[ "$#" != "2" ]]
then
    echo -e "$USAGE"
    exit 0
fi

command "$EXEC_FILE" -via "$1" localhost:"$2"
