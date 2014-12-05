#!/bin/sh

readonly CMD_PUSH='push'
readonly CMD_PULL='pull'
readonly CMD_DIFF='diff'
readonly CMD_CHECK='checkout'
readonly DIR_HOME="$HOME"
readonly DIR_FILE="$DIR_HOME/.dotfiles/files"

readonly SYNC_CMD="echo rsync -va --delete"
readonly RM_CMD="echo rm -rfv"
shopt -s dotglob

usage() {
  echo -n Usage:' '
  echo sh $0 "{$CMD_PUSH,$CMD_PULL,$CMD_DIFF,$CMD_CHECK}" [FILE]...;
  exit
}

diff_dotfiles() {
  count_=0
  while [ "${args[$count_]}" ]
  do
    res="`diff -qr "$1/${args[$count_]}" "$2/${args[$count_]}"`"
    if [ $? -eq 1 ]; then
      echo ${args[$count_]}
    fi
    count_=$((count_ + 1))
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
      $SYNC_CMD "$1/$obj`[ -d "$1/$obj" ] && echo '/'`" "$2/$obj"
    fi
    count_sync=$((count_sync + 1))
  done
}

re_checkout() {
  rm -rf "$DIR_FILE" 2> /dev/null
  git checkout "$DIR_FILE"
}

if [ $# -eq 0 ]; then
  usage;
elif [ $# -le 1 ]; then
  count=0;
  # IFS=$(echo -en "\n\b")
  for entry in $DIR_FILE/*
  do
    args[$count]="${entry##*/}"
    count=$((count + 1))
  done
  # IFS=" "
else
  count=2
  while [ $count -le $# ]
  do
    args[$((count - 2))]=`echo "${!count}"`
    count=$((count + 1))
  done
fi

if [ $1 == $CMD_PUSH ]; then
  echo "Pushing..."
  sync_dotfiles "$DIR_HOME" "$DIR_FILE"
elif [ $1 == $CMD_PULL ]; then
  echo "Pulling..."
  sync_dotfiles "$DIR_FILE" "$DIR_HOME"
elif [ $1 == $CMD_DIFF ]; then
  echo "Diff:"
  diff_dotfiles "$DIR_HOME" "$DIR_FILE"
elif [ $1 == $CMD_CHECK ]; then
  echo "Re-Checking out files..."
  re_checkout
else
  usage;
fi
echo "Done."
