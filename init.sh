#!/bin/bash
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

git submodule update --init --recursive

make_link() {
  if [ ! -L $2 ]; then
    ln -fs $1 $2
  fi
}

## if uname -o != "Cygwin" ## TODO

## vim links

### vim-go
# :GoInstallBinaries in vim
mkdir -p ~/.vim/pack/plugins/start/
## mkdir -p ~/.vim/autoload

make_link ~/.dotfiles/submodules/vim-go ~/.vim/pack/plugins/start/vim-go
make_link ~/.dotfiles/submodules/ctrlp.vim  ~/.vim/pack/plugins/start/ctrlp.vim
## make_link ~/.dotfiles/submodules/vim-plug/plug.vim  ~/.vim/autoload/plug.vim

### YCM (TODO)
# make_link
# ./install.py --clang-completer
mkdir -vp ${HOME}/workstation/{claude,download,github,go,projects}
mkdir -vp ${HOME}/sessions
