#!/bin/sh

readonly CMD_PUSH='modify'
readonly CMD_PULL='install'
readonly CMD_DIFF='diff'
readonly DIR_HOME="$HOME"
readonly DIR_FILE="$DIR_HOME/.dotfiles/files"

usage() {
  echo -n Usage:' '
  echo sh $0 "{$CMD_PUSH,$CMD_PULL,$CMD_DIFF}" [FILE]...;
  exit
}

diff_dotfiles() {
  count_=0
  echo "Diff:"
  while [ "${args[$count_]}" ]
  do
    diff "$1/${args[$count_]}" "$2/${args[$count_]}" -qr
    count_=$((count_ + 1))
  done
}

sync_dotfiles() {
  echo "$3ing..." ## lel
  count_sync=0
  while [ "${args[$count_sync]}" ]
  do
    diff "$1/${args[$count_sync]}" "$2/${args[$count_sync]}" -qr > /dev/null
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
  count=0;

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
elif [ $1 == $CMD_DIFF ]; then
  diff_dotfiles "$DIR_HOME" "$DIR_FILE"
else
  usage;
fi
