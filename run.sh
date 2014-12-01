#!/bin/sh

readonly CMD_PUSH='push'
readonly CMD_PULL='pull'
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
    res="`diff "$1/${args[$count_]}" "$2/${args[$count_]}" -q`"
    if [ $? -eq 1 ]; then
      echo ${args[$count_]}
    fi
    count_=$((count_ + 1))
  done
}

sync_dotfiles() {
  echo "$3ing..." ## lel
  count_sync=0
  while [ "${args[$count_sync]}" ]
  do
    obj="${args[$count_sync]}"
    ls $2/$obj > /dev/null 2>&1
    if [ $? -eq 1 ]; then
      cp -vr "$1/$obj" "$2" 2> /dev/null;
    else
      if [ -f "$1/$obj" -a ! -f "$2/$obj" -o \
	-d "$1/$obj" -a ! -d "$2/$obj" ]; then
        rm -rfv $2/$obj;
	cp -vr $1/$obj $2 2> /dev/null;
      else
	diff "$1/$obj" "$2/$obj" -q > /dev/null
	if [ $? -eq 1 ]; then
	  cp -vr "$1/$obj" "$2" 2> /dev/null
	fi
      fi
    fi
    count_sync=$((count_sync + 1))
  done
  echo "Done."
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
