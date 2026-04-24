_vim_sessions="${HOME}/sessions"
_workstation="${HOME}/workstation"
_dotfiles="${HOME}/.dotfiles"
_gobase="$_workstation/go"

#########################
#
export GOPATH="$_gobase/gopath"
export PAGER="$_dotfiles/submodules/vimpager/vimpager"
export PATH=$PATH:"$_dotfiles/bin"
export PATH=$PATH:"$_gobase/root/bin":"$GOPATH/bin"
export PATH=$PATH:"${HOME}/.local/bin"

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

alias r="tput reset"
alias cdw="cd $_workstation;l"
alias cdg="cd $GOPATH/src/github.com/yartff;l"
alias vi='vim'
alias vt="vi -S $_vim_sessions/setup.vim"

##

alias vcat="$_dotfiles/submodules/vimpager/vimcat"
alias vpa="$_dotfiles/submodules/vimpager/vimpager"

for srcfile in "$_dotfiles/misc/bash/source/"*
do
  source "$srcfile"
done

# !!!!!!!!!!!!!!!!!!!!!!!
unset _gobase
unset _dotfiles
unset _workstation
unset _vim_sessions

#########################
## Binds
shopt -s no_empty_cmd_completion

if [[ $- = *i* ]]; then ## load bind source file instead
  bind	'"\e(": complete-into-braces'
  # bind -r '\e\e' ## double ESC
  # "\e*"
  # unbind "\e{"
  # bind -p > file
fi

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

PS1='${debian_chroot:+($debian_chroot)}\[\033[0;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
## PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
