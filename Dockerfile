FROM ubuntu:26.04 AS base

ARG PGBOUNCER_TAG
ARG PGBOUNCER_VERSION
ARG PGBOUNCER_CHECKSUM

# Install dependencies
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential libevent-dev pkg-config libssl-dev libc-ares-dev libpam-modules python3 pandoc

ADD --checksum=${PGBOUNCER_CHECKSUM} --link \
  https://www.pgbouncer.org/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz \
  pgbouncer.tar.gz

RUN tar -xvf pgbouncer.tar.gz && \
  cd pgbouncer-${PGBOUNCER_VERSION} && \
  ./configure --prefix=/usr/local --with-pam && \
  make  && \
  make install

FROM ubuntu:26.04

# Install runtime dependencies
# we like scripting with ruby
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y libcares2 libevent-2.1-7t64 ruby && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Create pgbouncer user and group
RUN groupadd -r pgbouncer && \
  useradd -r -g pgbouncer -d /var/lib/pgbouncer -s /bin/bash pgbouncer && \
  mkdir -p /var/lib/pgbouncer /var/log/pgbouncer /etc/pgbouncer && \
  chown -R pgbouncer:pgbouncer /var/lib/pgbouncer /var/log/pgbouncer /etc/pgbouncer

COPY --link --from=base /usr/local/bin/pgbouncer /usr/local/bin/pgbouncer

# Switch to pgbouncer user
USER pgbouncer

# Set working directory
WORKDIR /var/lib/pgbouncer
