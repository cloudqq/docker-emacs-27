ARG VERSION=latest
FROM ubuntu:$VERSION

MAINTAINER cloudqq <cloudqq@gmail.com>

ENV NO_AT_BRIDGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update && apt-get install \
  git \
  build-essential \
  automake

RUN git clone https://git.savannah.gnu.org/git/emacs.git

RUN apt-get install \
  autoconf \
  libtool \
  texinfo \
  xorg-dev \
  libgtk-3-dev \
  libjpeg-dev \
  libncurses5-dev \
  libdbus-1-dev \
  libgif-dev \
  libtiff-dev \
  libm17n-dev \
  libpng-dev \
  librsvg2-dev \ 
  libotf-dev \
  libgnutls28-dev \
  libxml2-dev \ 
  libxpm-dev
 
RUN cd emacs && ./autogen.sh && ./configure && make
RUN cd emacs &&  make install
