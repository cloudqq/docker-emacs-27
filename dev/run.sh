#!/usr/bin/env bash

USER=cloudqq
WORKDIR=/mnt/workspace
VOL_DEV_VOLUME=vol_rust_runtime6
VOL_DEV_PATH=/usr/local/rust
PROXY=http://172.31.0.29:1088

docker volume create $VOL_DEV_VOLUME

docker run -ti --rm  \
 --ulimit core=-1 --security-opt seccomp=unconfined \
 --privileged \
 -v ${VOL_DEV_VOLUME}:${VOL_DEV_PATH} \
 -v $(pwd):${WORKDIR} \
 -e http_proxy=$PROXY \
 -e https_proxy=$PROXY \
 -e privileged \
 -e UNAME="${USER}"\
 -e GNAME="${USER}"\
 -e UID="1000"\
 -e GID="1000"\
 -e UHOME="/home/${USER}" \
 -e WORKSPACE="${WORKDIR}" \
 -e LANG=zh_CN.UTF-8 \
 -e LANGUAGE=zh_CN:en_US \
 -e LC_CTYPE=en_US.UTF-8 \
 -e RUST_VERSION=1.40.0 \
 -e CARGO_HOME=/usr/local/rust/.cargo \
 -e RUSTUP_HOME=/usr/local/rust/.rustup \
 -w "${WORKDIR}" \
 rustdev:latest /mnt/workspace/build-rust.sh
 #rustdev:latest bash
