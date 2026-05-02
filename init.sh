#!/bin/bash

mkdir -vp ${HOME}/workstation/{claude,download,github,go,projects}
mkdir -vp ${HOME}/sessions

## [[ Submodules ]]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULES_DIR="$SCRIPT_DIR/submodules"
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

## TODO: -c "q" quits before loading
echo nvim --headless -c "TSInstall go" ## -c "q"
