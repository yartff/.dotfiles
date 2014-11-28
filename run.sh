#!/bin/sh

readonly CMD_PUSH='modify'
readonly CMD_PULL='install'
readonly DIR_HOME="$HOME"
readonly DIR_FILE="$DIR_HOME/.dotfiles/files"

count=0;

usage() {
  echo -n Usage:' '
  echo sh $0 "{$CMD_PUSH,$CMD_PULL}" [FILE]...;
  exit
}

sync_dotfiles() {
  echo "$3ing..." ## lel
  count_sync=0
  while [ "${args[$count_sync]}" ]
  do
    if [ $? -eq 1 ]; then
      cp -vr "$1/${args[$count_sync]}" "$2"
    fi
    count_sync=$((count_sync + 1))
  done
  echo "Done."
}

if [ $# -eq 0 ]; then
  usage;
elif [ $# -le 1 ]; then
  all_files="$DIR_FILE/.*"
  for tmp in $all_files
  do
    tmp=`echo $tmp | grep -o '[^/]*$'`
    if [ $tmp != "." ] && [ $tmp != ".." ]; then
      args[$count]="$tmp"
      count=$((count + 1))
    fi
  done
else
  count=2
  while [ $count -le $# ]
  do
    args[$((count - 2))]=`echo "${!count}" | grep -o '[^/]*$'`
    count=$((count + 1))
  done
fi

if [ $1 == $CMD_PUSH ]; then
  sync_dotfiles "$DIR_HOME" "$DIR_FILE" $1;
elif [ $1 == $CMD_PULL ]; then
  sync_dotfiles "$DIR_FILE" "$DIR_HOME" $1;
else
  usage;
fi
