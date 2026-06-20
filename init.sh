#!/bin/bash

mkdir -vp "${HOME}/workstation/github/yartff"
mkdir -vp "${HOME}/workstation/go"
mkdir -vp "${HOME}/workstation/go/gopath/src"
mkdir -vp "${HOME}/workstation/go/gopath/pkg"
mkdir -vp "${HOME}/workstation/go/gopath/bin"
mkdir -vp "${HOME}/workstation/projects"
mkdir -vp "${HOME}/.sessions"
mkdir -vp "${HOME}/.local/bin"

## [[ Submodules ]]

cd "$(dirname "$0")"

SUBMODULES_DIR="${HOME}/.dotfiles/submodules"
PATHS_JSON="$SUBMODULES_DIR/paths.json"

git submodule update --init --recursive || exit

for submodule_path in "$SUBMODULES_DIR"/*/; do
  name="$(basename "${submodule_path%/}")"
  link_dest="$(jq -r --arg name "$name" '.[$name] // empty' "$PATHS_JSON")"
  [ -z "$link_dest" ] && continue
  link_dest="$(realpath -ms ~/"$link_dest")"
  [[ -L $link_dest ]] && continue
  mkdir -p "$(dirname "$link_dest")"
  ln -vfs "$SUBMODULES_DIR/$name" "$link_dest"
done
