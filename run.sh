#!/bin/bash

DOTFILES_DIR="${HOME}/.dotfiles/files"
DESTINATION_DIR="${HOME}"
CMD="diff"
RSYNC_CMD="rsync -a --checksum --no-links --out-format=%n"
FILES_DIR="$DOTFILES_DIR/files"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dot) DOTFILES_DIR="$2"; shift 2 ;;
    --out) DESTINATION_DIR="$2"; shift 2 ;;
    diff|push|pull) CMD="$1"; shift ;;
    add) CMD="$1"; ADD_FILE="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

print_pulled() {
  echo -e "\033[0;33m[~]\033[0m $src"
}

print_pushed() {
  echo -e "\033[0;33m[~]\033[0m $dst"
}

print_added() {
  echo -e "\033[0;34m[+]\033[0m $src"
}

print_nosuchfile() {
  echo -e "\033[0;31m[x]\033[0m $src"
}

print_created() {
  echo -e "\033[0;34m[+]\033[0m $dst"
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
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    fn_print="print_created"
  fi
  out=$($RSYNC_CMD "$src" "$dst")
  [ -n "$out" ] && $fn_print
}

do_add() {
  src="$(realpath "$ADD_FILE")"
  rel="${src#"$DESTINATION_DIR/"}"
  dst="$DOTFILES_DIR/$rel"
  echo mkdir -vp "$(dirname "$dst")"
  echo cp -v "$src" "$dst"
}

do_diff() {
  if [ ! -e "$dst" ]; then
    echo -e "\033[0;31m==> \033[4;31mMISSING\033[0m in $DESTINATION_DIR: $rel"
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

while IFS= read -r -d '' src; do
  rel="${src#"$DOTFILES_DIR/"}"
  dst="$DESTINATION_DIR/$rel"
  $CMD 
done < <(find "$DOTFILES_DIR" -type f -print0)
