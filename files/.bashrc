_workstation="${HOME}/workstation"
_dotfiles="${HOME}/.dotfiles"
_dotfiles_bash="${HOME}/.dotfiles/misc/bash"
_gobase="$_workstation/go"
_sessions="${HOME}/.sessions"

#########################
#
export GOPATH="$_gobase/gopath"
export PAGER="$_dotfiles/submodules/nvimpager/nvimpager"
## export PAGER="batcat"
export VISUAL="nvim"
export PATH=$PATH:"$_dotfiles/bin"
export PATH=$PATH:"$_gobase/root/bin":"$GOPATH/bin"
export PATH=$PATH:"${HOME}/.local/bin"
export PATH=$PATH:"/opt/nvim-linux-x86_64/bin"
export PATH=$PATH:"/opt/luals/bin"

#########################
#
alias src='source ~/.bashrc'
alias ls='ls --color=auto'
alias ll='ls -l'
alias l='clear;ll -a'
alias la='ls -a'
alias grep='grep --color'
alias diff='diff --color'

##

alias r="reset"
alias cdw="cd $_workstation;l"
alias vi='nvim'
alias conf="$_dotfiles/run.sh"

##

## TODO: bash/source
alias gst="git status"
alias gpl="git pull"
alias gps="git push"
alias gci="git commit"
alias gdiff="git diff"

gsh() {
  case $# in
    0) git stash list ;;
    1) git stash show -p "stash@{$1}" ;;
  esac
}

##

alias vpa="$PAGER"

if [[ $- = *i* ]]; then
  for srcfile in "$_dotfiles_bash/source/"*
  do
    source "$srcfile"
  done
fi

# !!!!!!!!!!!!!!!!!!!!!!!
## unset _sessions ## needed by sourced files
unset _gobase
unset _dotfiles
unset _workstation

#########################
## Binds
shopt -s no_empty_cmd_completion

#########################
##                     ##
##       To Sort       ##
##                     ##
#########################

#########################
## ws specific
if [ -f ~/.bashrc_sp ]; then
  . ~/.bashrc_sp
fi

_update_prompt() {
  ps_cd_size=$((_cd_size))
  local _njobs
  _njobs=$(jobs -p | wc -l)
  if [ "$_njobs" -gt 0 ]; then
    ps_jobs=$'{\001\e[35m\002'"${_njobs}"$'\001\e[0m\002}'
  else
    ps_jobs=''
  fi
}
PROMPT_COMMAND='_update_prompt'
PS1='\[\033[0;32m\]@\h\[\033[00m\][$ps_cd_size]$ps_jobs:\[\033[01;34m\]\w\[\033[00m\]\$ '

## if ! shopt -oq posix; then
##   if [ -f /usr/share/bash-completion/bash_completion ]; then
##     . /usr/share/bash-completion/bash_completion
##   elif [ -f /etc/bash_completion ]; then
##     . /etc/bash_completion
##   fi
## fi
## shopt -s histappend
## shopt -s checkwinsize

HISTSIZE=1000
HISTFILESIZE=2000

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

## TP: node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## TP: rust
. "$HOME/.cargo/env"
