FROM ubuntu:xenial

# silence Dialog TERM not set errors in apt-get install
ENV DEBIAN_FRONTEND noninteractive

# factory requirements plus a couple of useful things
RUN apt-get update && apt-get install -y \
    bzip2 \
    unzip \
    vim \
    wget \
    zip \
    bc \
    libsqlite3-dev \
    curl \
    net-tools \
    xinetd \
    tftpd-hpa \
    isc-dhcp-server \
    minicom \
    netbase \
    nfs-kernel-server \
    supervisor

RUN mkdir -p /var/log/supervisor
# Use bash, not dash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure dash

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./exports /etc/exports
COPY ./isc-dhcp-server /etc/default/isc-dhcp-server
COPY ./dhcpd.conf /etc/dhcp/dhcpd.conf
COPY ./tftpd-hpa /etc/default/tftpd-hap
COPY ./tftp /etc/xinetd.d/tftp

EXPOSE 111/udp 2049/tcp

RUN mkdir -p /nfsboot
RUN mkdir -p /tftpboot
VOLUME /workdir
WORKDIR /workdir

COPY entrypoint.sh /workdir

CMD ["/workdir/entrypoint.sh"]
