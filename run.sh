#!/bin/sh

count=1
command=""

while [ $count -le $# ]
do
  if [ $count -eq 1 ]
  then
    command="$1" 
  else
    args[$((count - 1))]="${!count}"
  fi
  count=$((count + 1))
done

count=1
echo command: $command
while [ ${args[$count]} ]
do
  echo -n arg: 
  echo ${args[$count]}
  count=$((count + 1))
done

echo $count
