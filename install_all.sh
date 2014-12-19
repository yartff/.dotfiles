#!/bin/bash
## DON'T RUN THIS! IT'S UNTESTED!
## Just take the commands you need

MANAGER_CMD="yum -y"
sudo su

$MANAGER_CMD groupinstall 'Development tools'
$MANAGER_CMD install vim
$MANAGER_CMD install tcsh
$MANAGER_CMD install sharutils
$MANAGER_CMD install htop
$MANAGER_CMD install p7zip
$MANAGER_CMD install clang

cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
EOF

$MANAGER_CMD install google-chrome
gsettings set org.gnome.mutter overlay-key ''

## ssh
ssh-keygen -t rsa -C "carbonel.q@gmail.com"
