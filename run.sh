#!/bin/bash

readonly CMD_PUSH='push'
readonly CMD_PULL='pull'
readonly CMD_DIFF='diff'
readonly CMD_CHECK='reset'
readonly CMD_UNTR='rm'
readonly DIR_HOME="$HOME"
readonly DIR_FILE="$DIR_HOME/.dotfiles/files"

readonly SYNC_CMD="rsync -va --no-links --delete"
readonly RM_CMD="rm -rfv"
shopt -s dotglob

usage() {
  echo -n Usage:' '
  echo sh $0 "<command>" "[FILE]...";
  echo
  echo Commands:
  echo "  " "$CMD_PUSH" ": Pushes tracked files from ~/ to files/."
  echo "  " "$CMD_PULL" ": Pulls tracked files from files/ to ~/."
  echo "  " "$CMD_DIFF" ": Outputs diff of tracked files"
  echo "  " "$CMD_CHECK" ": Reset changes of files/ from the repo"
  echo "  " "$CMD_UNTR" ": Untrack files (no args untracks all files)"
  exit
}

DIFF_FILE="/tmp/.diff_tmpFile.txt"
diff_dotfiles() {
  count_=0
  while [ "${args[$count_]}" ]
  do
    ## Careful: if a link has the same name than a monitored directory, it will also ignore it
    find "$1/${args[$count_]}" -type l -exec sh -c "echo {} | tr '/' '\n' | tail -n 1" \; > $DIFF_FILE
    ## TODO: empty directories because of links
    diff --color -X $DIFF_FILE -r "$1/${args[$count_]}" "$2/${args[$count_]}"
    count_=$((count_ + 1))
  done
}

sync_untrack() {
  count_unt=0
  while [ "${args[$count_unt]}" ]
  do
    obj="${args[$count_unt]}"
    $RM_CMD "$DIR_FILE/$obj"
    count_unt=$((count_unt+ 1))
  done
}

sync_dotfiles() {
  count_sync=0
  while [ "${args[$count_sync]}" ]
  do
    obj="${args[$count_sync]}"
    if [ ! -e "$1/$obj" ]; then
      $RM_CMD "$2/$obj"
    else
      $SYNC_CMD "$1/$obj`[ -d "$1/$obj" ] && echo -n '/'`" "$2/$obj"
    fi
    count_sync=$((count_sync + 1))
  done
}

re_checkout() {
  $RM_CMD "$DIR_FILE" 2> /dev/null
  git checkout "$DIR_FILE"
}

if [ $# -eq 0 ]; then
  usage;
elif [ $# -le 1 ]; then
  count=0;
  SAVE_IFS="$IFS"
  IFS=$(echo -en "\n\b")
  for entry in "$DIR_FILE"/*
  do
    args[$count]="${entry##*/}"
    count=$((count + 1))
  done
  IFS="$SAVE_IFS"
else
  count=2
  while [ $count -le $# ]
  do
    args[$((count - 2))]=`basename "${!count}"`
    count=$((count + 1))
  done
fi

if [ $1 == $CMD_PUSH ]; then
  echo "Pushing..."
  sync_dotfiles "$DIR_HOME" "$DIR_FILE"
elif [ $1 == $CMD_PULL ]; then
  echo "Pulling..."
  sync_dotfiles "$DIR_FILE" "$DIR_HOME"
  ./init.sh
elif [ $1 == $CMD_DIFF ]; then
  echo "Diff:"
  diff_dotfiles "$DIR_HOME" "$DIR_FILE"
elif [ $1 == $CMD_CHECK ]; then
  echo "Re-Checking out files..."
  re_checkout
elif [ $1 == $CMD_UNTR ]; then
  echo "Deleting files..."
  sync_untrack
else
  usage;
fi
echo "Done."
