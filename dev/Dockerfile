FROM ubuntu:latest AS build01

ENV DEBIAN_FRONTEND noninteractive

RUN sed --in-place --regexp-extended "s/archive\.ubuntu/azure\.archive\.ubuntu/g" /etc/apt/sources.list \
  && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install build-essential git

RUN git clone https://github.com/ncopa/su-exec.git /su-exec \
  && cd /su-exec \
  && make \
  && chmod 770 su-exec


FROM ubuntu:18.04
LABEL maintainer="cloudqq@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN sed --in-place --regexp-extended "s/archive\.ubuntu/azure\.archive\.ubuntu/g" /etc/apt/sources.list \
  && echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
  && apt-get update \
  && apt-get install build-essential git curl wget sudo

COPY --from=build01 /su-exec/su-exec /usr/local/sbin
COPY asEnvUser /usr/local/sbin

RUN chown root /usr/local/sbin/asEnvUser \
  && chmod 700  /usr/local/sbin/asEnvUser

ENTRYPOINT ["asEnvUser"]
CMD ["bash"]

