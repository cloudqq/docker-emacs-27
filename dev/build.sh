#!/usr/bin/env bash

docker build --build-arg http_proxy=http://10.3.4.10:1088 --build-arg https_proxy=http://10.3.4.10:1088  -f Dockerfile -t rustdev .
