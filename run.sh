#!/bin/sh

readonly CMD_PUSH='push'
readonly CMD_PULL='pull'
readonly CMD_DIFF='diff'
readonly CMD_CHECK='checkout'
readonly DIR_HOME="$HOME"
readonly DIR_FILE="$DIR_HOME/.dotfiles/files"
readonly CP_COMM="cp -uvr "
shopt -s dotglob

usage() {
  echo -n Usage:' '
  echo sh $0 "{$CMD_PUSH,$CMD_PULL,$CMD_DIFF,$CHECKOUT}" [FILE]...;
  exit
}

diff_dotfiles() {
  count_=0
  echo "Diff:"
  while [ "${args[$count_]}" ]
  do
    res="`diff "$1/${args[$count_]}" "$2/${args[$count_]}" -q`"
    if [ $? -eq 1 ]; then
      echo ${args[$count_]}
    fi
    count_=$((count_ + 1))
  done
}

sync_dotfiles_push() {
  echo "Pushing..."
  count_sync=0
  while [ "${args[$count_sync]}" ]
  do
    obj="${args[$count_sync]}"
    if [ -d "$DIR_HOME/$obj" -a -f "$DIR_FILE/$obj" -o \
      -f "$DIR_HOME/$obj" -a -d "$DIR_FILE/$obj" ]; then
      rm -rfv "$DIR_FILE/$obj";
    fi
    if [ ! -f "$DIR_HOME/$obj" -a ! -d "$DIR_HOME/$obj" ]; then
      rm -rfv "$DIR_FILE/$obj"
      return
    fi
    mkdir -vp "$DIR_FILE/`dirname $obj`"
    if [ -d "$DIR_HOME/$obj" -a -d "$DIR_FILE/$obj" ]; then
      $CP_COMM $DIR_HOME/$obj/* "$DIR_FILE/$obj"
    else
      $CP_COMM "$DIR_HOME/$obj" "$DIR_FILE/$obj"
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
  all_files=`find $DIR_FILE`
  count=-1;
  nb_char=0;
  for tmp in $all_files
  do
    if [ $count -eq -1 ]; then
      nb_char=`echo $tmp/ | wc -c`
    else
      args[$count]="`echo $tmp | cut -c $nb_char-`"
    fi
    count=$((count + 1))
  done
else
  count=2
  while [ $count -le $# ]
  do
    args[$((count - 2))]=`echo "${!count}"`
    count=$((count + 1))
  done
fi

if [ $1 == $CMD_PUSH ]; then
  sync_dotfiles_push "$DIR_HOME" "$DIR_FILE"
elif [ $1 == $CMD_PULL ]; then
  echo Pull Not ok
  ## sync_dotfiles "$DIR_FILE" "$DIR_HOME" $1;
elif [ $1 == $CMD_DIFF ]; then
  diff_dotfiles "$DIR_HOME" "$DIR_FILE"
elif [ $1 == $CMD_CHECK ]; then
  re_checkout
else
  usage;
fi
echo "Done."
