FROM ubuntu:24.04

# DuckDB v1.5.2 is the minimum version that ships the quack extension.
ARG DUCKDB_VERSION=v1.5.2
ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Map Docker's TARGETARCH to DuckDB's release asset naming convention.
RUN case "${TARGETARCH:-amd64}" in \
        amd64) DUCKDB_ARCH="amd64" ;; \
        arm64) DUCKDB_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL \
        "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-${DUCKDB_ARCH}.zip" \
        -o /tmp/duckdb.zip \
    && unzip /tmp/duckdb.zip -d /usr/local/bin \
    && rm /tmp/duckdb.zip \
    && chmod +x /usr/local/bin/duckdb

# Pre-install the quack extension at build time so the image is self-contained.
# The extension lives in /root/.duckdb/extensions/ and is version-locked to
# the DuckDB binary above.
RUN duckdb :memory: -c "INSTALL quack FROM core_nightly;"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Persistent storage for the DuckDB database file.
VOLUME ["/data"]

# Quack protocol default port.
EXPOSE 9494

ENTRYPOINT ["docker-entrypoint.sh"]
