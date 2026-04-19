## mkcd
mkcd() {
  mkdir -p $*
  if [ $? -ne 0 ]; then
    return 1
  fi
  cd "${@: -1}"
}
