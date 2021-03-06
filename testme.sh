#!/usr/bin/env bash

USER=myname
WORKDIR=/mnt/workdir
docker run --rm -it \
 -v $(pwd):${WORKDIR} \
 -v /etc/localtime:/etc/localtime:ro \
 -e UNAME="${USER}"\
 -e GNAME="${USER}"\
 -e UID="1000"\
 -e GID="1000"\
 -e UHOME="/home/${USER}" \
 -e WORKSPACE="${WORKDIR}" \
 -w "${WORKDIR}" \
testme2:latest sh
