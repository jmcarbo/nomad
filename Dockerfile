FROM ubuntu

MAINTAINER jmcarbo

RUN addgroup nomad && \
    useradd -r -g nomad nomad

ENV GOSU_VERSION 1.10

RUN set -x && \
    apt-get update && apt-get install -y gnupg openssl curl wget unzip && \
    arch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$arch" && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true 

ENV NOMAD_VERSION 0.5.6
ENV NOMAD_SHA256 3f5210f0bcddf04e2cc04b14a866df1614b71028863fe17bcdc8585488f8cb0c

ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip /tmp/nomad.zip
RUN echo "${NOMAD_SHA256}  /tmp/nomad.zip" > /tmp/nomad.sha256 \
  && sha256sum -c /tmp/nomad.sha256 \
  && cd /bin \
  && unzip /tmp/nomad.zip \
  && chmod +x /bin/nomad \
  && rm /tmp/nomad.zip

RUN mkdir -p /nomad/data && \
    mkdir -p /etc/nomad && \
    chown -R nomad:nomad /nomad

EXPOSE 4646 4647 4648

ADD start.sh /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
