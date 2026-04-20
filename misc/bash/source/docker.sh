dockerm() {
  docker stop $*
  docker rm $*
}

dockerc() {
  docker container $*
}
