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

## $MANAGER_CMD install sharutils
## $MANAGER_CMD install clang

###############################
# install go in "${HOME}/workstation/go/root"

## google-chrome
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
EOF
$MANAGER_CMD install google-chrome

## disable super key
gsettings set org.gnome.mutter overlay-key ''

## YouCompleteMe
$MANAGER_CMD install python automake gcc gcc-c++ kernel-devel cmake
$MANAGER_CMD install python-devel python3-devel
