FROM ubuntu:latest AS builder

ENV DEBIAN_FRONTEND noninteractive

RUN sed --in-place --regexp-extended "s/archive\.ubuntu/azure\.archive\.ubuntu/g" /etc/apt/sources.list \
  && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && apt-get update && \
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
  libwebkit2gtk-4.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://git.savannah.gnu.org/git/emacs.git /opt/emacs

RUN cd /opt/emacs && \
    ./autogen.sh && \
    ./configure --with-modules --with-x-toolkit=lucid && \
    make PREFIX=/usr/local -j `nproc` && \
    make install

ENV PATH="/root/.cask/bin:$PATH"
RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

RUN mkdir -p /root/.emacs.d/elpa/gnupg && \
    chmod 700 /root/.emacs.d/elpa/gnupg && \
    gpg -q --homedir /root/.emacs.d/elpa/gnupg -k | grep 81E42C40 || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --homedir /root/.emacs.d/elpa/gnupg --recv-keys 066DAFCB81E42C40

FROM rimeenv:latest

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share/emacs /usr/local/share/emacs
COPY --from=builder /usr/local/libexec /usr/local/libexec

RUN apt-get update && apt-get -y install libtiff5 libpng16-16 libgif7 libsm6 libasound2 libxpm4 xaw3dg  libxrender1 \
librsvg2-2 libdbus-1-3  libxrandr2 libxinerama1 libxfixes3 libgpm2 libotf0 libm17n-0 liblcms2-2 libjansson4

RUN emacs --version

