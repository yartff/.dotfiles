#!/bin/sh

readonly CMD_PUSH='edit'
readonly CMD_PULL='update'
readonly DIR_FILE='files/'

usage() {
  echo -n Usage:' '
  echo sh $0 "{$CMD_PUSH,$CMD_PULL}" [FILE]...;
  exit
}

if [ $# -eq 0 ]; then
  usage
elif [ $# -le 1 ]; then
  count=0;
  for f in "$DIR_FILE"/.*
  do
    f=`echo $f | grep -o '[^/]*$'`
    if [ $f != "." ] && [ $f != ".." ]; then
      args[$count]="$f"
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
  dir_from="~/"
  dir_to="$DIR_FILE"
elif [ $1 == $CMD_PULL ]; then
  dir_from="$DIR_FILE/"
  dir_to="~/"
else
  usage
fi

echo $1
echo "$dir_from -> $dir_to"
count=0
while [ ${args[$count]} ]
do
  echo ${args[$count]}
  count=$((count + 1))
done
