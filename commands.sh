#!/bin/bash
## DON'T RUN THIS! IT'S UNTESTED!
## Just take the commands you need

MANAGER_CMD="apt -y"
$MANAGER_CMD update
$MANAGER_CMD upgrade

$MANAGER_CMD install build-essential
$MANAGER_CMD install git
$MANAGER_CMD install jq
$MANAGER_CMD install rsync
$MANAGER_CMD install htop
$MANAGER_CMD install tree
$MANAGER_CMD install curl wget
$MANAGER_CMD install p7zip
$MANAGER_CMD install sshpass
$MANAGER_CMD install universal-ctags
$MANAGER_CMD install mlocate ## && updatedb
## $MANAGER_CMD install bat

## chmod 600 ~/.ssh/id_25519
## chmod 644 ~/.ssh/id_25519.pub

## Note: make sure for every install in /opt/ :
## sudo chown -R wslflask:wslflask /opt/luals/

## neovim
## in "/opt/nvim-linux-x86_64"

## nvm
echo 'https://github.com/nvm-sh/nvm#installing-and-updating'

## rust/cargo
echo $MANAGER_CMD install clang
echo 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh'

## tree-sitter
echo cargo install --locked tree-sitter-cli

## claude
