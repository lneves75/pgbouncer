FROM alpine:3.9 as build

ARG VERSION=1.12.0

# Inspiration from https://github.com/gmr/alpine-pgbouncer/blob/master/Dockerfile
# and https://github.com/edoburu/docker-pgbouncer/blob/079b41e591d761f87cb911589c54a7b3fc9d32eb/Dockerfile
RUN apk --update add autoconf autoconf-doc automake udns-dev curl gcc libc-dev libevent-dev libtool make man libressl-dev pkgconfig

WORKDIR /tmp/pgbouncer-$VERSION

ADD pgbouncer-$VERSION.tar.gz /tmp

RUN ./configure --prefix=/usr --with-udns && make 

FROM alpine:3.9

ARG VERSION=1.12.0

WORKDIR /etc/pgbouncer

COPY etc/* /etc/pgbouncer/

COPY --from=build /tmp/pgbouncer-$VERSION/pgbouncer /usr/bin

RUN apk --update add udns libevent libressl-dev postgresql-client && \
  mkdir -p /var/log/pgbouncer /var/run/pgbouncer && \
	chown -R nobody /var/run/pgbouncer /var/log/pgbouncer /etc/pgbouncer

EXPOSE 5432

USER nobody

CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]

