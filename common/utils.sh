absolute() {
  if [ "$1" -lt 0 ]; then
    echo $((-1 * $1))
  else
    echo "$1"
  fi
}