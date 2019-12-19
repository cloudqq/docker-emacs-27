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

RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
  && cd /tmp/su-exec \
  && make \
  && chmod 770 su-exec \
  && mv ./su-exec /usr/local/sbin/ 

COPY asEnvUser /usr/local/sbin/

# Only for sudoers
RUN chown root /usr/local/sbin/asEnvUser \
  && chmod 700  /usr/local/sbin/asEnvUser


ENV UNAME="cloudqq" \
  GNAME="cloudqq" \
  UHOME="/home/cloudqq" \
  UID="1000" \
  GID="1000" \
  WORKSPACE="/mnt/workspace" \
  SHELL="/bin/bash"


RUN apt-get install -y locales sudo
RUN echo 'LC_ALL=zh_CN.UTF-8' > /etc/default/locale && \
  echo 'LANG=zh_CN.UTF-8' >> /etc/default/locale && \
  locale-gen zh_CN.UTF-8

ENV LC_CTYPE zh_CN.UTF-8

WORKDIR "${WORKSPACE}"

ENTRYPOINT ["asEnvUser"]
CMD ["bash", "-c", "emacs; /bin/bash"]




