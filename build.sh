#!/bin/sh

if [ "$1" = "-h" ]; then
   echo "Usage: build.sh [-h] [-u]"
   echo
   echo "    -h : this help text"
   echo "    -u : use the current user's name and id instead of \"nemo\""
   exit
elif [ "$1" = "-u" ]; then
    docker build --build-arg BUILD_USER=${USER} --build-arg BUILD_UID=$(id --user ${USER}) --build-arg BUILD_GID=$(id --group ${USER}) --tag sfosbid --file Dockerfile .
else
    docker build --tag sfosbid --file Dockerfile .
fi
