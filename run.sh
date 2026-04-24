#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/files"
DESTINATION_DIR="${HOME}"
CMD="diff"
RSYNC_CMD="rsync -a --checksum --no-links --out-format=%n"
FILES_DIR="$DOTFILES_DIR/files"

usage() {
  echo "Pull and push dotfiles between your home and files/"
  echo "Usage: run.sh [--dot <dir>] [--out <dir>] <command> [args]"
  echo
  echo "Commands:"
  echo "  diff [file... ] Show diff (all files if none specified)"
  echo "  push          Push files from home into dotfiles"
  echo "  pull          Pull dotfiles to home"
  echo "  add <file>... Copy files from home into dotfiles"
  echo
  echo "Options:"
  echo "  --dot <dir>   Dotfiles source directory (default: <script-dir>/files)"
  echo "  --out <dir>   Destination directory (default: \$HOME)"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --dot) DOTFILES_DIR="$2"; shift 2 ;;
    --out) DESTINATION_DIR="$2"; shift 2 ;;
    diff) shift; [[ $# -gt 0 ]] && { DIFF_FILES=("$@"); break; } ;;
    push|pull) CMD="$1"; shift ;;
    add) CMD="$1"; shift; [[ $# -gt 0 ]] || { echo "Usage: run.sh add <file>..." >&2; exit 1; }; ADD_FILES=("$@"); break ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

print_pulled() {
  echo -e "\033[0;33m[~]\033[0m $dst"
}

print_pushed() {
  echo -e "\033[0;33m[~]\033[0m $src"
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

do_push() {
  if [ ! -e "$dst" ]; then
    print_nosuchfile
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
    print_missingfile
    return
  fi
  if diff -q "$dst" "$src" > /dev/null 2>&1; then
    :
  else
    echo "==> $rel"
    diff --color "$dst" "$src"
  fi
}

case "$CMD" in
  add)  do_add; exit ;;
  diff) CMD=do_diff ;;
  push) CMD=do_push ;;
  pull) CMD=do_pull ;;
  *) echo "$CMD" not found; exit ;;
esac

loop() {
  while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES_DIR/"}"
    dst="$DESTINATION_DIR/$rel"
    $CMD
  done < <(find "$DOTFILES_DIR" -type f -print0)
}

loop

## if [[ ${#DIFF_FILES[@]} -gt 0 ]]; then
##   for f in "${DIFF_FILES[@]}"; do
##     echo WIP
##     echo $DOTFILES_DIR
##     echo $f
##   done
##   exit
## fi
## ;;
