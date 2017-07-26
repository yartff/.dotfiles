#!/bin/tcsh
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

git submodule init
git submodule update
mkdir -p $GOPATH/{bin,src/github.com/$USER/}
