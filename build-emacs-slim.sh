#!/bin/sh
PROXY=http://`hostname -I | awk '{print $1}'`:30888
FILE=tests/Dockerfile.20230718
TAG=20230718
docker build . -t cloudqq/emacs-slim:$TAG -f $FILE --build-arg http_proxy=$PROXY --build-arg https_proxy=$PROXY
