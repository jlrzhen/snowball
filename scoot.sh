#!/bin/bash

function handle_interrupt() {
    echo -e "\r\e[Kexit\n\r\e[K"
    exit 1
}
# Set up trap to call the handle_interrupt function on SIGINT
trap 'handle_interrupt' SIGINT

# ANSI escape sequences
SAVE_CURSOR="\033[s"
RESTORE_CURSOR="\033[u"
MOVE_TO_POSITION="\033[1000D\033[1C" # 1st column (so 1C)
RESET_LINE="\r"
NEWLINE="\n"

HEADER="$SAVE_CURSOR \
        $MOVE_TO_POSITION \
        $RESET_LINE"

FRAMES=(
    "     (\_(\ $NEWLINE  c( ( ·.·)"
    "     (\_(\ $NEWLINE   c(( ·.·)"
    "   (\_(\   $NEWLINE c(( ·.·)  "
)

while true; do
    for frame in "${FRAMES[@]}"; do
        echo -ne "${HEADER}${frame}${RESTORE_CURSOR}"
        sleep 0.4
    done
done
