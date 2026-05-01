#!/bin/bash
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULES_DIR="$SCRIPT_DIR/submodules"
PATHS_JSON="$SUBMODULES_DIR/paths.json"

git submodule update --init --recursive || exit

for submodule_path in "$SUBMODULES_DIR"/*/; do
  name="$(basename "${submodule_path%/}")"
  link_dest="$(jq -r --arg name "$name" '.[$name] // empty' "$PATHS_JSON")"
  [ -z "$link_dest" ] && continue
  echo 1: "$link_dest"
  link_dest="$(realpath -ms ~/"$link_dest")"
  echo 2: "$link_dest"
  mkdir -p "$(dirname "$link_dest")"
  echo ln -fs "$SUBMODULES_DIR/$name" "$link_dest"
done

mkdir -vp ${HOME}/workstation/{claude,download,github,go,projects}
mkdir -vp ${HOME}/sessions
