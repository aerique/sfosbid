#!/bin/sh

docker run --interactive --tty --volume $(pwd)/projects:/home/nemo/projects sfosbid:snapshot
