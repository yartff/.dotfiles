#!/bin/bash

DOTFILES_DIRNAME="files"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$DOTFILES_DIRNAME"
DESTINATION_DIR="${HOME}"
CMD="do_diff"
RSYNC_CMD="rsync -a --checksum --no-links --out-format=%n"

usage() {
  echo "Pull and push dotfiles between your home and $DOTFILES_DIRNAME/"
  echo "Usage: run.sh [--dot <dir>] [--out <dir>] <command> [args]"
  echo
  echo "Commands:"
  echo "  diff [file... ] Show diff (all files if none specified)"
  echo "  push          Push files from home into dotfiles"
  echo "  pull          Pull dotfiles to home"
  echo "  add <file>... Copy files from home into dotfiles"
  echo "  gitrm         git rm files missing from \$HOME"
  echo
  echo "Options:"
  echo "  --dot <dir>   Dotfiles source directory (default: <script-dir>/$DOTFILES_DIRNAME)"
  echo "  --out <dir>   Destination directory (default: \$HOME)"
}

print_pulled() {
  echo -e "\033[0;33m[<]\033[0m ${dst#$DESTINATION_DIR/}"
}

print_pushed() {
  echo -e "\033[0;33m[>] .dotfiles/\033[0m${src#$DOTFILES_DIR/}"
}

print_added_file() {
  echo -e "\033[0;32m[+]\033[0m $src"
}

print_added_directory() {
  echo -e "\033[0;32m[+]\033[0m \033[1;34m$src/\033[0m"
}

print_missingfile() {
  echo -e "\033[0;31m[-] \033[4;31mMISSING\033[0m: $rel"
}

print_nosuchfile() {
  echo -e "\033[0;31m[x]\033[0m $src"
}

print_created() {
  echo -e "\033[0;32m[+]\033[0m $dst"
}

print_error() {
  echo -e "\033[0;31m[X] \033[4;31mNo such file or directory\033[0m: $1"
}

do_push() {
  if [ ! -e "$dst" ]; then
    ## TODO count and print at the end
    return
  fi
  out=$($RSYNC_CMD "$dst" "$src")
  [ -n "$out" ] && print_pushed
}

do_pull() {
  fn_print="print_pulled"
  dir="$(dirname "$dst")"
  if [ ! -d "$dir" ] || [ ! -f "$dst" ]; then
    mkdir -p "$dir"
    fn_print="print_created"
  fi
  out=$($RSYNC_CMD "$src" "$dst")
  [ -n "$out" ] && $fn_print
}

do_add() {
  for ADD_FILE in "${ADD_FILES[@]}"; do
    src="$(realpath "$ADD_FILE")"
    rel="${src#"$DESTINATION_DIR/"}"
    dst="$DOTFILES_DIR/$rel"
    if [ -d "$src" ]; then
      out=$($RSYNC_CMD "$src/" "$dst")
      if [ $? -ne 0 ]; then
	echo rsync failure
	return 1
      fi
      [ -n "$out" ] && print_added_directory
    else
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst" || return 1
      print_added_file
    fi
  done
}

do_diff() {
  if [ ! -e "$dst" ]; then
    print_nosuchfile
    return
  fi
  if ! diff -q "$dst" "$src" > /dev/null 2>&1; then
    echo "==> $rel"
    diff --color "$dst" "$src"
  fi
}

do_git() {
  [ ! -e "$dst" ] && print_missingfile
}

do_gitrm() {
  cd $DOTFILES_DIR
  [ ! -e "$dst" ] && git rm "$rel"
}

loop() {
  while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES_DIR/"}"
    dst="$DESTINATION_DIR/$rel"
    $CMD
  done < <(find "$dirloop" -type f -print0)
}

if [[ $# -gt 0 ]]; then
  case "$1" in
    -h|--help) usage; exit 0 ;;
    ## diff) shift; [[ $# -gt 0 ]] && { DIFF_FILES=("$@"); break; } ;;
    add) shift; [[ $# -gt 0 ]] || { echo "Usage: run.sh add <file>..." >&2; exit 1; }; ADD_FILES=("$@"); do_add; exit ;;
    git|gitrm) [[ $# -eq 1 ]] || { echo "Usage: run.sh git|gitrm" >&2; exit 1; }; CMD="do_$1"; dirloop="$DOTFILES_DIR"; loop; exit ;;
    diff|push|pull) CMD="do_$1"; shift ;;
    *) echo "Unknown command: $1" >&2; usage >&2; exit 1 ;;
  esac
fi

paths=()
paths_size=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    ## --
    *) ((paths_size++)); paths+=("$1"); shift;;
  esac
done

if [[ $paths_size -eq 0 ]]; then
  dirloop="$DOTFILES_DIR"
  loop
else
  for ndx in "${!paths[@]}"; do
    if [[ -d ${paths[$ndx]} ]]; then
      fpath=`realpath ${paths[$ndx]}`
      case "$fpath" in
	"$DOTFILES_DIR")   dirloop=$DOTFILES_DIR;;
	"$DOTFILES_DIR/"*) dirloop="$fpath";;
	"$HOME/"*)         dirloop="${DOTFILES_DIR}${fpath#$HOME}";;
	## *)
      esac
      loop
    elif [[ -f ${paths[$ndx]} ]]; then
      fpath=`realpath ${paths[$ndx]}`
      case "$fpath" in
	"$DOTFILES_DIR/"*)
	  rel="${fpath#$DOTFILES_DIR/}"
	  src=$fpath
	  dst="${HOME}/$rel"
	  ;;
	"$HOME/"*)
	  rel="${fpath#$HOME/}"
	  src="${DOTFILES_DIR}/${rel}"
	  dst="${fpath}"
	  ;;
	## *)
      esac
      $CMD
    else
      path="$DOTFILES_DIR/${paths[$ndx]}"
      if [[ -f $path ]]; then
	rel="${paths[$ndx]}"
	dst="${HOME}/$rel"
	src="$path"
	$CMD
      elif [[ -d $path ]]; then
	dirloop="$path"
	loop
      else
	print_error $path
      fi
    fi
  done
fi
