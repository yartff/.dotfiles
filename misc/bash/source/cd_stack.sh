__cd_reset() {
  _cd_stack=()
  _cd_index=-1
  _cd_size=0
}

if [ "$_cd_stack" == "" ]; then
  __cd_reset
fi

_cd_c_red="$(tput setaf 1)"
_cd_c_magenta="$(tput setaf 5)"
_cd_c_reset="$(tput sgr0)"
_cd_cwd="$(pwd)"

cd() { builtin cd "$@"; _cd_cwd="$(pwd)"; }

## TODO: cdpwd -> prints current value to insert in commands
## TODO: on a tmp cpy stack
## TODO: all var local instead of unset

__cd_is_num() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

__cd_print_error() {
  tput setaf 1  # foreground red
  echo "[ERR] $1"
  tput sgr0     # reset attributes
}

deb() {
  echo $_cd_stack
  echo "(ndx=$_cd_index, size=$_cd_size)"
}

__cd_print_highlightndx() {
  local mode="${1:-Normal}"
  local hl_ndx="${2:--1}"
  local hl_color="${3:-6}"

  if [ "$mode" == "Clear" ]; then
    tput cuu $_cd_size          # move cursor up to first list entry
  elif [ "$mode" == "ClearPlus" ]; then
    tput cuu $((_cd_size+1))    # move cursor up past list and header line
    tput el                     # erase header line
    tput cud1                   # move cursor back down one line
  fi

  local cols=$(tput cols)       # terminal width in columns
  local max_path=$((cols - 6)) # prefix is always "%2d :  " = 6 chars

  local c_hl="$(tput setaf $hl_color)"
  local c_el=""; [ "$mode" != "Normal" ] && c_el="$(tput el)"

  local buf=""
  for ndx in "${!_cd_stack[@]}"; do
    local path="${_cd_stack[$ndx]}"
    [ ${#path} -gt $max_path ] && path="...${path: -$((max_path - 3))}"

    local line="$c_el"
    local ndx_str; printf -v ndx_str "%2d " "$ndx"
    line+="$ndx_str"

    if [ $ndx -eq $hl_ndx ]; then
      line+="${c_hl}>> ${_cd_c_reset}"              # hl_color >> for highlighted entry
    else
      line+=":  "
    fi

    if [ ! -d "${_cd_stack[$ndx]}" ]; then
      line+="$_cd_c_red"                             # red: directory does not exist
    elif [ "$_cd_cwd" == "${_cd_stack[$ndx]}" ]; then
      line+="$_cd_c_magenta"                         # magenta: current working directory
    elif [ $ndx -eq $hl_ndx ]; then
      line+="$c_hl"                                  # hl_color for path
    fi
    line+="${path}${_cd_c_reset}"                    # path + reset

    buf+="${line}"$'\n'
  done
  printf "%s" "$buf"
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
    if ! __cd_is_num "$1"; then
      __cd_print_error "$1: not a number"
      return
    fi
    toqueue=$1
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
      __cd_print_highlightndx Normal $ndx 1
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
    if ! __cd_is_num "$1"; then
      __cd_print_error "$1: not a number"
      return
    fi
    todrop=$1
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
  if [[ ! -d ${_cd_stack[$_cd_index]} ]]; then
    __cd_print_error "${_cd_stack[$_cd_index]}: no such directory"
    __cd_print_highlightndx Normal $_cd_index 1
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
  __cd_print_highlightndx Normal $localndx 6
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
	__cd_print_highlightndx ClearPlus $localndx 6
	if [ $_cd_size -eq 0 ]; then
	  break
	fi
	;;
      "j")
	if ! [ $localndx -eq $((_cd_size - 1)) ]; then
	  ((localndx++))
	  __cd_print_highlightndx Clear $localndx 6
	fi
	;;
      "k")
	if ! [ $localndx -le 0 ]; then
	  ((localndx--))
	  __cd_print_highlightndx Clear $localndx 6
	fi
	;;
      "p")
	cdp $localndx "0"
	__cd_print_highlightndx Clear $localndx 6
	;;
      "")
	_cd_index=$localndx
	cd "${_cd_stack[$_cd_index]}"
	__cd_print_highlightndx Clear
	break
	;;
    esac
  done
  unset localndx
}

cdr() {
  if [ $_cd_size -eq 0 ]; then
    __cd_print_error "no wd"
    return
  fi
  if [ $# -ge 1 ]; then
    local newpath
    newpath=$(realpath "$1" 2>/dev/null)
    if [ ! -d "$newpath" ]; then
      __cd_print_error "no such directory"
      return
    fi
  else
    local newpath="$(pwd)"
  fi
  for ndx in "${!_cd_stack[@]}"; do
    if [ $ndx -ne $_cd_index ] && [[ "${_cd_stack[$ndx]}" == "$newpath" ]]; then
      __cd_print_error "wd already at $ndx"
      __cd_print_highlightndx Normal $ndx 1
      return
    fi
  done
  _cd_stack[$_cd_index]="$newpath"
  cdl
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
    if ! __cd_is_num "$1"; then
      __cd_print_error "$1: not a number"
      return
    fi
    if [ $1 -lt 0 ] || [ $1 -ge $_cd_size ]; then
      __cd_print_error "$1: out of bound"
      cdl
      return
    fi
    _cd_index=$1
  fi
  __cd_index_go
}

cdsave() {
  if [ $# -eq 0 ]; then
    __cd_print_error "usage: cdsave <name|path>"
    return
  fi
  local target="$1"
  if [[ "$target" != /* && "$target" != ~* && "$target" != ./* && "$target" != ../* ]]; then
    target="$HOME/sessions/${target}.cd"
  fi
  mkdir -p "$(dirname "$target")"
  printf "%s\n" "${_cd_stack[@]}" > "$target" || return 1
  printf "%d\n" "$_cd_index" >> "$target" || return 1
  echo "saved ${_cd_size} entries to $target"
}

cdload() {
  if [ $# -eq 0 ]; then
    __cd_print_error "usage: cdload <name|path>"
    return
  fi
  local target="$1"
  if [[ "$target" != /* && "$target" != ~* && "$target" != ./* && "$target" != ../* ]]; then
    target="$HOME/sessions/${target}.cd"
  fi
  if [ ! -f "$target" ]; then
    __cd_print_error "no such file: $target"
    return
  fi
  local lines=()
  while IFS= read -r line; do
    lines+=("$line")
  done < "$target"
  local n=${#lines[@]}
  __cd_reset
  for (( i=0; i<n-1; i++ )); do
    _cd_stack+=("${lines[$i]}")
  done
  _cd_size=$(( n - 1 ))
  _cd_index="${lines[$((n-1))]}"
  echo "loaded $_cd_size entries from $target"
  cdl
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
