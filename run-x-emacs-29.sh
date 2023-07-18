#!/usr/bin/env bash

IMAGE=cloudqq/emacs-slim:20230718
USER=cloudqq
WORKDIR=/mnt/workdir
docker run --rm -it \
 -v $(pwd):${WORKDIR} \
 -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
 -e DISPLAY=$DISPLAY \
 -v /etc/localtime:/etc/localtime:ro \
 -e UNAME="${USER}"\
 -e GNAME="${USER}"\
 -e UID="1000"\
 -e GID="1000"\
 -e UHOME="/home/${USER}" \
 -e WORKSPACE="${WORKDIR}" \
 -w "${WORKDIR}" \
$IMAGE sh
