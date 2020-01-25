FROM ubuntu:18.04
MAINTAINER cloudqq <cloudqq@gmail.com>

RUN sed --in-place --regexp-extended "s/archive\.ubuntu/azure\.archive\.ubuntu/g" /etc/apt/sources.list \
  && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install build-essential git curl wget


ENV RUST_VERSION 1.40.0

RUN curl https://sh.rustup.rs -sSf | sh
