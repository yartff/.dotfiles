__cd_reset() {
  _cd_stack=()
  _cd_index=-1
  _cd_size=0
}

if [ "$_cd_stack" == "" ]; then
  __cd_reset
fi

## TODO: cdr -> replace current value
## TODO: cdpwd -> prints current value to insert in commands
## TODO: handle if args are not numbers
## TODO: on a tmp cpy stack
## TODO: all var local instead of unset

__cd_print_error() {
  tput setaf 1
  echo "[ERR] $1"
  tput sgr0
}

deb() {
  echo $_cd_stack
  echo "(ndx=$_cd_index, size=$_cd_size)"
}

__cd_print_highlightndx() {
  selecthl=-1
  if [ "$2" != "" ]; then
    selecthl=$2
  fi
  if [ "$1" == "2" ] || [ "$1" == "4" ]; then ## erase above first line
    tput cuu $((_cd_size+1))
    tput el
    tput cud1
  elif [ "$1" == "1" ] || [ "$1" == "3" ]; then
    tput cuu $_cd_size
  fi

  for ndx in "${!_cd_stack[@]}"; do
    if [ "$1" == "3" ] || [ "$1" == "4" ]; then
      tput el
    fi
    ## TODO: if not currentwd, print another color
    if [ $ndx -eq $selecthl ]; then
      tput setaf $3
    elif [ $ndx -eq $_cd_index ]; then
      tput setaf 5
    fi
    printf "%2d : %s\n" "$ndx" "${_cd_stack[$ndx]}"
    tput sgr0
  done
}

cdl() {
  __cd_print_highlightndx
}

cdp() { ## TODO: maybe should be available in cds only
  if [ $_cd_size -eq 0 ]; then
    __cd_print_error "no wd"
    return
  fi
  if [ $# -ge 1 ]; then
    toqueue=$1 ## TODO: NB
  else
    toqueue=$_cd_index
  fi
  if [ $toqueue -lt 0 ] || [ $toqueue -ge $_cd_size ]; then
    __cd_print_error "$toqueue: out of bound"
    cdl
    unset toqueue
    return
  fi
  path="${_cd_stack[$toqueue]}"
  lastndx=0
  if [ $toqueue -eq $_cd_index ]; then
    lastndx=1
  fi
  cdd $toqueue > /dev/null
  unset toqueue
  cda "$path" "0"
  if [ $lastndx -eq 1 ]; then
    _cd_index=$((_cd_size-1))
  fi
  [ "$2" != "0" ] && cdl
}

cda() {
  if [ "$1" != "" ]; then
    toadd=`realpath "$1"`
    if ! [ -d "$1" ]; then
      __cd_print_error "no such directory"
      return
    fi
  else
    toadd="`pwd`"
  fi
  for ndx in "${!_cd_stack[@]}"; do
    if [[ "${_cd_stack[$ndx]}" == "$toadd" ]]; then
      __cd_print_error "wd already at $ndx"
      __cd_print_highlightndx 0 $ndx 1
      return
    fi
  done
  ## if [ $_cd_index -eq $((_cd_size - 1)) ]; then
  ## ((_cd_index++))
  ## fi
  if [ "$1" == "" ] || [ $_cd_size -eq 0 ]; then
    _cd_index=$_cd_size
  fi
  ((_cd_size++))
  _cd_stack+=("$toadd")
  [ "$2" != "0" ] && cdl
}

cdd() {
  if [ $# -eq 0 ]; then
    todrop=$_cd_index
  elif [ $# -ge 1 ]; then
    if [ "$1" == "all" ]; then
      __cd_reset
      return
    fi
    todrop=$1 ## TODO: NB
  fi
  if [ $todrop -lt 0 ] || [ $todrop -ge $_cd_size ]; then
    __cd_print_error "$todrop: out of bound"
    cdl
    return
  fi
  unset "_cd_stack[$todrop]"
  _cd_stack=("${_cd_stack[@]}")
  ((_cd_size--))
  if [ $_cd_index -eq $_cd_size ] || [ $todrop -lt $_cd_index ]; then
    ((_cd_index--))
  fi
  unset todrop
  [ "$2" != "0" ] && cdl
}

__cd_index_go() {
  if [ $_cd_index -eq -1 ]; then
    echo "stack empty"
    return
  fi
  cd "${_cd_stack[$_cd_index]}"
  cdl
}

cds() {
  if [ $_cd_size -eq 0 ]; then
    __cd_print_error "no wd"
    return
  fi
  localndx=$_cd_index
  __cd_print_highlightndx 0 $localndx 6
  while true; do
    read -n 1 -s key
    case "$key" in
      "q")
	break
	;;
      "d")
	cdd $localndx "0"
	if [ $localndx -eq $_cd_size ]; then
	  ((localndx--))
	fi
	__cd_print_highlightndx 4 $localndx 6
	if [ $_cd_size -eq 0 ]; then
	  break
	fi
	;;
      "j")
	if ! [ $localndx -eq $((_cd_size - 1)) ]; then
	  ((localndx++))
	  __cd_print_highlightndx 1 $localndx 6
	fi
	;;
      "k")
	if ! [ $localndx -le 0 ]; then
	  ((localndx--))
	  __cd_print_highlightndx 1 $localndx 6
	fi
	;;
      "p")
	cdp $localndx "0"
	__cd_print_highlightndx 3 $localndx 6
	;;
      "")
	_cd_index=$localndx
	cd "${_cd_stack[$_cd_index]}"
	__cd_print_highlightndx 1
	break
	;;
    esac
  done
  unset localndx
}

cdgo() {
  if [ $_cd_size -eq 0 ]; then
    __cd_print_error "no wd"
    return
  fi
  if [ $# -gt 1 ]; then
    echo cdgo [n]
    return
  fi
  if [ $# -eq 1 ]; then
    ## TODO: NB $1
    if [ $1 -lt 0 ] || [ $1 -ge $_cd_size ]; then
      __cd_print_error "$1: out of bound"
      cdl
      return
    fi
    _cd_index=$1
  fi
  __cd_index_go
}

cdj() {
  if [ $_cd_index -eq $((_cd_size - 1)) ]; then
    __cd_print_error "no next"
    cdl
    return
  fi
  ((_cd_index++))
  __cd_index_go
}

cdk() {
  if [ $_cd_index -le 0 ]; then
    __cd_print_error "no prev"
    cdl
    return
  fi
  ((_cd_index--))
  __cd_index_go
}
