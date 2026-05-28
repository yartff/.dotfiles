## vs — open a neovim session from ~/sessions/*.vim

vs() {
  local session="$_sessions/${1}.vim"
  nvim -S "$session"
}

vsrm() {
  local f
  for f in "$@"; do
    rm -f "$_sessions/${f}.vim"
  done
}

_vs_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local sessions
  sessions=$(ls "$_sessions/"*.vim 2>/dev/null | xargs -I{} basename {} .vim)
  COMPREPLY=($(compgen -W "$sessions" -- "$cur"))
}

complete -F _vs_complete vs
complete -F _vs_complete vsrm
