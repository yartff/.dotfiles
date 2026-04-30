#!/bin/bash
## TODO if (diff files/.tcshrc ~/.tcshrc) ./run pull

git submodule update --init --recursive

make_link() {
  if [ ! -L $2 ]; then
    ln -fs $1 $2
  fi
}

### vim
# :GoInstallBinaries in vim
mkdir -vp ~/.config/nvim/pack/plugins/start/
# make_link ~/.dotfiles/submodules/vim-go			~/.config/nvim/pack/plugins/start/vim-go
make_link ~/.dotfiles/submodules/ctrlp.vim		~/.config/nvim/pack/plugins/start/ctrlp.vim

mkdir -vp ~/.config/nvim/pack/nvim/start
make_link ~/.dotfiles/submodules/nvim-lspconfig		~/.config/nvim/pack/nvim/start/nvim-lspconfig

### YCM (TODO)
# make_link
# ./install.py --clang-completer

mkdir -vp ${HOME}/workstation/{claude,download,github,go,projects}
mkdir -vp ${HOME}/sessions
