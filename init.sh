#!/bin/bash
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

git submodule update --init --recursive

## Install GO
mkdir -p ~/workstation/go

make_link() {
  if [ ! -L $2 ]; then
    ln -fs $1 $2
  fi
}

## vim links

### vim-go
# :GoInstallBinaries in vim
mkdir -p ~/.vim/pack/plugins/start/
make_link ~/.dotfiles/submodules/vim-go ~/.vim/pack/plugins/start/vim-go
mkdir -p ~/.vim/autoload
make_link ~/.dotfiles/submodules/vim-plug/plug.vim  ~/.vim/autoload/plug.vim
mkdir -p ~/.vim/bundle/
make_link ~/.dotfiles/submodules/ctrlp.vim  ~/.vim/bundle/ctrlp.vim

### YCM (TODO)
# make_link
# ./install.py --clang-completer
