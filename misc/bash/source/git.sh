alias gst="git status"
alias gpl="git pull"
##alias gps="git push"
alias gci="git commit"
alias gdiff="git diff"

gsh() {
  case $# in
    0) git stash list ;;
    1) git stash show -p "stash@{$1}" ;;
  esac
}
