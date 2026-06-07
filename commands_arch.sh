#!/bin/bash
## DON'T RUN THIS! IT'S UNTESTED!
## Just take the commands you need

chsh -s /bin/bash

pacman -Syu ## Upgrades everything

pacman -S neovim
pacman -S cmake
pacman -S tree
pacman -S docker

## $MANAGER_CMD install sharutils
## $MANAGER_CMD install clang
