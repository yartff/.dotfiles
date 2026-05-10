#!/bin/bash
## DON'T RUN THIS! IT'S UNTESTED!
## Just take the commands you need

MANAGER_CMD="apt -y"
$MANAGER_CMD update
$MANAGER_CMD upgrade

$MANAGER_CMD install build-essential
$MANAGER_CMD install git
$MANAGER_CMD install vim-gtk3
$MANAGER_CMD install rsync
$MANAGER_CMD install htop
$MANAGER_CMD install tree
$MANAGER_CMD install curl wget
$MANAGER_CMD install p7zip
$MANAGER_CMD install sshpass
$MANAGER_CMD install universal-ctags
$MANAGER_CMD install mlocate ## && updatedb

## nvm

## rust/cargo
echo $MANAGER_CMD install clang
echo 'curl https://sh.rustup.rs -sSf | sh'

## tree-sitter
echo cargo install --locked tree-sitter-cli

## claude

## luals
echo 'https://github.com/LuaLS/lua-language-server/releases'
# in /opt/luals

## TODO: -c "q" quits before loading
echo nvim --headless -c "GoInstallBinaries" ## -c "q"
echo nvim --headless -c "TSInstall go" ## -c "q"

###
## nvim lsp configs
## https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
