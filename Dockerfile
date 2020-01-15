FROM ubuntu:latest AS builder4

ENV DEBIAN_FRONTEND noninteractive

RUN sed --in-place --regexp-extended "s/archive\.ubuntu/azure\.archive\.ubuntu/g" /etc/apt/sources.list \
  && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install build-essential git 

RUN git clone https://github.com/ncopa/su-exec.git /su-exec \
  && cd /su-exec \
  && make \
  && chmod 770 su-exec

# build ripgrep
FROM rust:latest AS builder1

RUN \
  git clone --depth 1 https://github.com/BurntSushi/ripgrep \
  && cd ripgrep \
  && cargo build --release \
  && ./target/release/rg --version \
  && cp ./target/release/rg /usr/local/bin \
  && cd / && git clone --depth 1 https://github.com/lotabout/skim.git \
  && cd skim \
  && cargo build --release \
  && ./target/release/sk --version \
  && cp ./target/release/sk /usr/local/bin

# end of build su-exec

FROM golang:latest AS fzfbuilder
RUN \
  git clone --depth 1 https://github.com/junegunn/fzf.git  \
  && cd fzf \
  && make release && make install && pwd

# build rime
FROM ubuntu:latest AS builder3

ENV DEBIAN_FRONTEND noninteractive

RUN sed --in-place --regexp-extended "s/archive\.ubuntu/azure\.archive\.ubuntu/g" /etc/apt/sources.list \
  && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install build-essential git cmake zlib1g-dev \
  pkg-config libglib2.0  libreadline-dev


RUN apt-get install doxygen  python-gi python3-gi python-xlib \
libboost-dev libboost-filesystem-dev libboost-regex-dev libboost-system-dev libboost-locale-dev libgoogle-glog-dev libgtest-dev 

# Manually install libopencc
RUN git clone https://github.com/BYVoid/OpenCC.git
WORKDIR OpenCC/
RUN make
RUN make install

# Fix libgtest problem during compiling
WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt
RUN make
#copy or symlink libgtest.a and libgtest_main.a to your /usr/lib folder
RUN cp *.a /usr/lib

RUN apt-get install libc6-dev   libyaml-cpp-dev   libleveldb-dev \
  libmarisa-dev  curl

WORKDIR /
RUN git clone https://github.com/rime/librime.git
WORKDIR librime/
RUN make
RUN make install

ENV rime_dir=/usr/local/share/rime
RUN curl -fsSL https://git.io/rime-install | bash

RUN git clone  https://gitlab.com/liberime/liberime.git
WORKDIR liberime/
RUN make




FROM ubuntu:18.04 as dev


RUN apt-get update && \
    apt-get install -y \
            autoconf \
            automake \
            autotools-dev \
            build-essential \
            curl \
            dpkg-dev \
            git \
            gnupg \
            imagemagick \
            ispell \
            libacl1-dev \
            libasound2-dev \
            libcanberra-gtk3-module \
            liblcms2-dev \
            libdbus-1-dev \
            libgif-dev \
            libgnutls28-dev \
            libgpm-dev \
            libgtk-3-dev \
            libjansson-dev \
            libjpeg-dev \
            liblockfile-dev \
            libm17n-dev \
            libmagick++-6.q16-dev \
            libncurses5-dev \
            libotf-dev \
            libpng-dev \
            librsvg2-dev \
            libselinux1-dev \
            libtiff-dev \
            libxaw7-dev \
            libxml2-dev \
            openssh-client \
            python \
            texinfo \
            xaw3dg-dev \
  zlib1g-dev \
  libwebkit2gtk-4.0 \
    && rm -rf /var/lib/apt/lists/*

ENV EMACS_BRANCH="master"
ENV EMACS_VERSION="master"

RUN git clone https://git.savannah.gnu.org/git/emacs.git /opt/emacs

RUN cd /opt/emacs && \
    ./autogen.sh && \
    ./configure --with-modules --with-xwidgets && \
    make -j 8 && \
    make install

ENV PATH="/root/.cask/bin:$PATH"
RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

RUN mkdir -p /root/.emacs.d/elpa/gnupg && \
    chmod 700 /root/.emacs.d/elpa/gnupg && \
    gpg -q --homedir /root/.emacs.d/elpa/gnupg -k | grep 81E42C40 || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --homedir /root/.emacs.d/elpa/gnupg --recv-keys 066DAFCB81E42C40

CMD ["emacs"]


FROM ubuntu:18.04

MAINTAINER cloudqq <cloudqq@gmail.com>

ENV NO_AT_BRIDGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install  software-properties-common \
  apt-utils \
  bash \
  build-essential \
  autoconf \
  automake \
  libx11-dev \
  fontconfig \
  git \
  gzip \
  language-pack-en-base \
  make \
  cmake \
  sudo \
  tar \
  unzip \
  wget \
  curl \
  rlwrap \
  zsh \
  gnupg2 \
  msmtp \
  msmtp-mta \
  ca-certificates \
  ttf-mscorefonts-installer \
  fonts-wqy-zenhei \
  fonts-wqy-microhei \
  ttf-wqy-microhei \
  ttf-wqy-zenhei \
  xfonts-wqy \
  libpng-dev \
  libz-dev \
  libyaml-cpp-dev \
  libleveldb-dev \
  libmarisa-dev \
  libreadline-dev \
  libpoppler-glib-dev \
  libpoppler-glib-dev \
  libpoppler-private-dev \
  fasd \
  isync \
  notmuch \
  net-tools \
  netcat \
  telnet \
  gpm imagemagick libacl1 libasound2 libcanberra-gtk3-module liblcms2-2 libdbus-1-3 \
  libgif7 libgnutls30 libgtk-3-0 libjansson4 libjpeg8 libm17n-0 libpng16-16 librsvg2-2 libsm6 \
  libtiff5 libx11-xcb1 libxml2 libxpm4 openssh-client texinfo \
  default-jdk \
  byzanz \
  xdotool \
  ffmpeg \
  mu4e \
  libboost-dev \
  libboost-filesystem-dev \
  libboost-regex-dev \
  libboost-system-dev \
  libboost-locale-dev \
  libgoogle-glog-dev \
  libgtest-dev \
  systemd \
  && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

RUN dpkg -l | grep libboost

ENV EMACS_BRANCH="master"
ENV EMACS_VERSION="master"

COPY --from=dev /root/.emacs.d /root/.emacs.d
COPY --from=dev /usr/local /usr/local

# install docker client
RUN docker_url=https://download.docker.com/linux/static/stable/x86_64 \
  &&  docker_version=18.09.7 \
  &&  curl -fsSL $docker_url/docker-$docker_version.tgz | \
  tar zxvf - --strip 1 -C /usr/bin docker/docker \
  && curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

COPY --from=builder4 /su-exec/su-exec /usr/local/sbin
COPY asEnvUser /usr/local/sbin/

# Only for sudoers
RUN chown root /usr/local/sbin/asEnvUser \
  && chmod 700  /usr/local/sbin/asEnvUser

# install fonts
ENV FONT_HOME="/usr/share/fonts"

RUN mkdir -p "${FONT_HOME}/adobe-fonts/source-code-pro"

RUN (git clone \
  --branch release \
  --depth 1 \
  'https://github.com/adobe-fonts/source-code-pro.git' \
  "$FONT_HOME/adobe-fonts/source-code-pro" && \
  fc-cache -f -v "$FONT_HOME/adobe-fonts/source-code-pro")

COPY windows "$FONT_HOME/windows"
RUN fc-cache -f -v "$FONT_HOME/windows"

# fzf
#
COPY --from=fzfbuilder /go/fzf/bin/fzf /usr/local/bin

# build rg
COPY --from=builder1 /usr/local/bin /usr/local/bin

#install rime
COPY --from=builder3 /librime/build/bin/*.yaml /usr/local/share/rime/
COPY --from=builder3 /librime/build/bin/*.txt /usr/local/share/rime/
COPY --from=builder3 /librime/build/bin/rime_dict_manager /usr/local/bin/
COPY --from=builder3 /librime/build/bin/rime_deployer /usr/local/bin/
COPY --from=builder3 /librime/build/lib/librime.so.1.5.3 /usr/local/lib/rime/
RUN cd /usr/local/lib/rime && ln -s librime.so.1.5g.3 librime.so.1 && ln -s librime.so.1 librime.so 
COPY --from=builder3 /librime/liberime/build/liberime.so /usr/local/lib/rime/
COPY --from=builder3 /usr/lib/libopencc.so.1.0.0 /usr/lib
RUN cd /usr/lib && ln -s  libopencc.so.1.1.0  libopencc.so.2 && ln -s libopencc.so.2 libopencc.so
COPY --from=builder3 /usr/share/opencc/* /usr/share/opencc/
COPY --from=builder3 /usr/bin/opencc* /usr/bin/

RUN echo '/usr/local/lib/rime' >> /etc/ld.so.conf.d/rime.conf && ldconfig

ENV rime_dir=/usr/local/share/rime
RUN curl -fsSL https://git.io/rime-install | bash -s -- prelude essay luna-pinyin double-pinyin

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod +x /usr/local/bin/youtube-dl

RUN git clone https://github.com/lolilolicon/xrectsel.git && cd xrectsel && ./bootstrap && ./configure && make && make install

RUN echo 'LC_ALL=zh_CN.UTF-8' > /etc/default/locale && \
  echo 'LANG=zh_CN.UTF-8' >> /etc/default/locale && \
  locale-gen zh_CN.UTF-8

ENV LC_CTYPE zh_CN.UTF-8

ENTRYPOINT ["asEnvUser"]
CMD ["bash", "-c", "emacs; /bin/bash"]
