#!/bin/sh
#PROXY=http://`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`:30888
PROXY=http://192.168.2.80:2099
echo $PROXY
FILE=tests/Dockerfile.20230719
TAG=20230719
docker build . -t cloudqq/emacs-slim:$TAG -f $FILE --build-arg http_proxy=$PROXY --build-arg https_proxy=$PROXY
