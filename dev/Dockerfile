FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y build-essential git curl wget sudo

RUN git clone https://github.com/ncopa/su-exec.git /su-exec \
  && cd /su-exec \
  && make \
  && chmod 770 su-exec

RUN cp /su-exec/su-exec /usr/local/sbin
COPY asEnvUser /usr/local/sbin

RUN chown root /usr/local/sbin/asEnvUser \
  && chmod 700  /usr/local/sbin/asEnvUser

ENTRYPOINT ["asEnvUser"]
CMD ["bash"]
