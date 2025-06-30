FROM ubuntu:24.04 AS base

ARG PGBOUNCER_TAG
ARG PGBOUNCER_VERSION
ARG PGBOUNCER_CHECKSUM

# Install dependencies
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential libevent-dev pkg-config libssl-dev libc-ares-dev libpam-modules

ADD --checksum=${PGBOUNCER_CHECKSUM} --link https://github.com/pgbouncer/pgbouncer/releases/download/pgbouncer_${PGBOUNCER_TAG}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz pgbouncer-${PGBOUNCER_VERSION}.tar.gz

RUN tar -xvf pgbouncer-${PGBOUNCER_VERSION}.tar.gz && \
  cd pgbouncer-${PGBOUNCER_VERSION} && \
  ./configure --prefix=/usr/local --with-pam && \
  make  && \
  make install

FROM ubuntu:24.04

# Install runtime dependencies
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y libcares2 libevent-2.1-7t64 && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --link --from=base /usr/local/bin/pgbouncer /usr/local/bin/pgbouncer
