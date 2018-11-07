#!/bin/bash
if [ -e "./.ryjo.conf" ]
then
  source "./.ryjo.conf"
else
  echo "Your current directory $PWD doesn't have a .ryjo.conf file."
  exit 1;
fi

if [ ! -z "$1" ] && declare -f "$1" > /dev/null
then
  "$@"
else
  echo "'$1' is not a known function name. Are you sure you defined it in .ryjo.conf?" >&2
  exit 1;
fi
