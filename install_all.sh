#!/bin/bash
## DON'T RUN THIS! IT'S UNTESTED!
## Just take the commands you need

sudo su

yum groupinstall 'Development tools'
yum install vim
yum install tcsh
yum install sharutils

cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
EOF

yum install google-chrome
gsettings set org.gnome.mutter overlay-key ''

## ssh
ssh-keygen -t rsa -C "carbonel.q@gmail.com"
