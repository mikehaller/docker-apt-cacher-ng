FROM ubuntu:latest

LABEL maintainer="mike.robin.haller@gmail.com"

ENV http_proxy http://host.docker.internal:3128
ENV https_proxy http://host.docker.internal:3128

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      apt-cacher-ng ca-certificates wget \
      && rm -rf /var/lib/apt/lists/*

COPY acng.conf /etc/apt-cacher-ng/acng.conf

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null  http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]
