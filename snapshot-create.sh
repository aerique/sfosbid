#!/bin/sh

if [ "$1" = "" ]; then
    echo "Usage: snapshot-create.sh CONTAINER-ID"
else
    docker commit $1 sfosbid:snapshot
fi
