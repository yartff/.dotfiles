#!/bin/tcsh
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

git submodule init
git submodule update
## Install GO
mkdir -p ~/workstation/go
