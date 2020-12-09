#!/bin/sh

if [ "$1" = "-h" ]; then
   echo "Usage: run.sh [-h] [-u]"
   echo
   echo "    -h : this help text"
   echo "    -u : use the current user's name instead of \"nemo\""
   exit
elif [ "$1" = "-u" ]; then
    BUILD_USER=${USER}
else
    BUILD_USER=nemo
fi

docker run --interactive --tty --volume $(pwd)/projects:/home/${BUILD_USER}/projects sfosbid:latest
