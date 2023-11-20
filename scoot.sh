#!/bin/bash

function handle_interrupt() {
    #echo -e "\r\e[Kexit\n\r\e[K"
    echo -e "\n\n\nexit\n"
    exit 0
}
# Set up trap to call the handle_interrupt function on SIGINT
trap 'handle_interrupt' SIGINT

# ANSI escape sequences
SAVE_CURSOR="\033[s"
RESTORE_CURSOR="\033[u"
# 1st column (so 1C)
MOVE_TO_POSITION="\033[1000D\033[1C"
RESET_LINE="\r"
NEWLINE="\n"

HEADER=("$SAVE_CURSOR \
        $MOVE_TO_POSITIO \
        $RESET_LINE"
)

function clear_frame() {
    echo -ne "${HEADER}          $NEWLINE\          $NEWLINE                ${RESTORE_CURSOR}"
}

function loop_frames() {
    local num_loops=$1
    local delay=$2
    local start_frame=$3
    local end_frame=$4
    local frames=("${@:$((5+start_frame)):$((5+end_frame))}")
    local num_frames=$((end_frame-start_frame+1))
    local total_iterations=$((num_loops * num_frames))

    for ((i=0; i<total_iterations; i++)); do
        frame_index=$((i % $num_frames))
        frame="${frames[$frame_index]}"
        echo -ne "${HEADER}${frame}${RESTORE_CURSOR}"
        sleep $delay
    done
}

SCOOT_FRONT=(
    "$NEWLINE     (\_(\ $NEWLINE  c( ( ·.·)"
    "$NEWLINE     (\_(\ $NEWLINE   c(( ·.·)"
    "$NEWLINE   (\_(\   $NEWLINE c(( ·.·)  "
)

SCOOT_SIDE=(
    "$NEWLINE      ((\  $NEWLINE  o(    ·) "
    "$NEWLINE      ((\  $NEWLINE   o(   ·) "
    "$NEWLINE     ((\   $NEWLINE  o(   ·)  "
)

CRAWL_GLANCE=(
    "$NEWLINE     (\_(\ $NEWLINE  c( ( ·.·)"
    "$NEWLINE     ((\   $NEWLINE  o(   ·)  "
)

SIT_SIDE=(
    " /)_/)  $NEWLINE ( -.-) $NEWLINE c(\")(\")"
    " /)_/)  $NEWLINE ( T.T) $NEWLINE c(\")(\")"
)

while :; do
    loop_frames 4 0.3 0 2 "${SCOOT_SIDE[@]}"
    clear_frame
    loop_frames 1 1 0 1 "${CRAWL_GLANCE[@]}"
    loop_frames 1 2 0 0 "${CRAWL_GLANCE[@]}"
    clear_frame
    loop_frames 1 2 1 1 "${SIT_SIDE[@]}"
    loop_frames 4 1 0 1 "${SIT_SIDE[@]}"
    loop_frames 1 1 1 1 "${SIT_SIDE[@]}"
    clear_frame
    loop_frames 1 2 0 0 "${SCOOT_FRONT[@]}"
    loop_frames 4 0.3 0 2 "${SCOOT_FRONT[@]}"
    clear_frame
done
