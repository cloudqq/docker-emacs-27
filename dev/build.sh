#!/usr/bin/env bash

PROXY=http://172.31.0.29:1088

docker build \
--build-arg http_proxy=$PROXY \
--build-arg https_proxy=$PROXY \
  -f Dockerfile -t rustdev .
