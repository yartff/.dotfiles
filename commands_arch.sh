#!/bin/bash
## DON'T RUN THIS! IT'S UNTESTED!
## Just take the commands you need

chsh -s /bin/bash

pacman -Syu

pacman -S cmake
pacman -S tree
## vim-gtk3

## $MANAGER_CMD install sharutils
## $MANAGER_CMD install clang

###############################
mkdir -p "${HOME}/vim_sessions"
mkdir -p "${HOME}/workstation/go/gopath"
# install go in "${HOME}/workstation/go/root"

