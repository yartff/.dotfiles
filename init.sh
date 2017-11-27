#!/bin/tcsh
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

git submodule init
git submodule update
## Install GO
mkdir -p ~/workstation/go

## vim links
mkdir -p ~/.vim/pack/plugins/start/
ln -s ~/.dotfiles/submodules/vim-go ~/.vim/pack/plugins/start/vim-go
mkdir -p ~/.vim/autoload
ln -s ~/.dotfiles/submodules/vim-plug/plug.vim  ~/.vim/autoload/plug.vim
mkdir -p ~/.vim/bundle/
ln -s ~/.dotfiles/submodules/ctrlp.vim  ~/.vim/bundle/ctrlp.vim
