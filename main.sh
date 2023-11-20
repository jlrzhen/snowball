#!/bin/bash

function handle_interrupt() {
    echo -e "\n\n\nexit\n"
    exit 0
}
# Set up trap to call the handle_interrupt function on SIGINT
trap 'handle_interrupt' SIGINT
function exit_cleanup() {
    echo -e "\r\e[Kexit\n\r\e[K"
    exit 0
} 

# ANSI escape sequences
SAVE_CURSOR="\033[s"
RESTORE_CURSOR="\033[u"
MOVE_TO_POSITION="\033[1000D\033[1C" # 1st column (so 1C)
RESET_LINE="\r"
NEWLINE="\n"

HEADER=("$SAVE_CURSOR \
        $MOVE_TO_POSITIO \
        $RESET_LINE"
)

function clear_frame() {
    # three empty lines
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

# Frames
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

# Sequences
sequence_1() {
  loop_frames 4 0.3 0 2 "${SCOOT_SIDE[@]}"
  clear_frame
}

sequence_2() {
  loop_frames 1 1 0 1 "${CRAWL_GLANCE[@]}"
  clear_frame
}

sequence_3() {
  loop_frames 1 2 0 0 "${CRAWL_GLANCE[@]}"
  clear_frame
  loop_frames 1 2 1 1 "${SIT_SIDE[@]}"
  for i in {1..2}; do
      loop_frames 2 0.1 0 1 "${SIT_SIDE[@]}"
      loop_frames 2 1 1 1 "${SIT_SIDE[@]}"
  done
  clear_frame
  loop_frames 1 2 0 0 "${SCOOT_FRONT[@]}"
  clear_frame
}

sequence_4() {
  loop_frames 4 0.3 0 2 "${SCOOT_FRONT[@]}"
  clear_frame
}

# TODO: params to adjust frequency of each sequence
sequences=(
  sequence_1
  sequence_2
  sequence_3
  sequence_4
)

REPEATS=4;
while :; do
    # duplicate sequences
    for ((i = 0; i < REPEATS; i++)); do
        random_index=$((RANDOM % ${#sequences[@]}))

        # play sequence at the random index
        ${sequences[random_index]}
    done
done
